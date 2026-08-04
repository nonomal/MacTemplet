//
//  NNWrapView.swift
//  MacTemplet
//
//  macOS 版 Flutter Wrap：主轴排布，放不下则换 run。
//  内存策略：复用 ContiguousArray 缓冲、尺寸缓存、同 bounds 跳过重排。
//

import Cocoa

// MARK: - Flutter-aligned enums

/// 对应 Flutter `Axis`
@objc enum NNWrapAxis: Int {
    case horizontal = 0
    case vertical = 1
}

/// 对应 Flutter `WrapAlignment`
@objc enum NNWrapAlignment: Int {
    case start = 0
    case end = 1
    case center = 2
    case spaceBetween = 3
    case spaceAround = 4
    case spaceEvenly = 5
}

/// 对应 Flutter `WrapCrossAlignment`
@objc enum NNWrapCrossAlignment: Int {
    case start = 0
    case end = 1
    case center = 2
    case stretch = 3
}

/// 对应 Flutter `VerticalDirection`
@objc enum NNWrapVerticalDirection: Int {
    case down = 0
    case up = 1
}

/// 对应 Flutter `TextDirection`
@objc enum NNWrapTextDirection: Int {
    case ltr = 0
    case rtl = 1
}

// MARK: - NNWrapView

/// Flutter `Wrap` 的 AppKit 实现。
@objcMembers final class NNWrapView: NSView {

    // MARK: Public API (Flutter parity)

    var direction: NNWrapAxis = .horizontal {
        didSet { guard oldValue != direction else { return }; invalidateWrapLayout() }
    }

    var alignment: NNWrapAlignment = .start {
        didSet { guard oldValue != alignment else { return }; invalidateWrapLayout() }
    }

    var spacing: CGFloat = 0 {
        didSet { guard oldValue != spacing else { return }; invalidateWrapLayout() }
    }

    var runAlignment: NNWrapAlignment = .start {
        didSet { guard oldValue != runAlignment else { return }; invalidateWrapLayout() }
    }

    var runSpacing: CGFloat = 0 {
        didSet { guard oldValue != runSpacing else { return }; invalidateWrapLayout() }
    }

    var crossAxisAlignment: NNWrapCrossAlignment = .start {
        didSet { guard oldValue != crossAxisAlignment else { return }; invalidateWrapLayout() }
    }

    var textDirection: NNWrapTextDirection = .ltr {
        didSet { guard oldValue != textDirection else { return }; invalidateWrapLayout() }
    }

    var verticalDirection: NNWrapVerticalDirection = .down {
        didSet { guard oldValue != verticalDirection else { return }; invalidateWrapLayout() }
    }

    /// Flutter `clipBehavior != Clip.none`
    var clipContent: Bool = false {
        didSet {
            wantsLayer = true
            layer?.masksToBounds = clipContent
        }
    }

    private(set) var arrangedSubviews: [NSView] = []

    /// 布局后真实内容尺寸（保证能完整包住所有子项）
    private(set) var fittedContentSize: CGSize = .zero

    // MARK: Private layout buffers (reused)

    private struct ChildMetric {
        var main: CGFloat
        var cross: CGFloat
    }

    private struct RunInfo {
        var start: Int
        var count: Int
        var mainExtent: CGFloat
        var crossExtent: CGFloat
    }

    private var metrics = ContiguousArray<ChildMetric>()
    private var runs = ContiguousArray<RunInfo>()
    private var measureCache = [ObjectIdentifier: CGSize]()
    private var lastLaidBounds = CGSize(width: -1, height: -1)
    private var needsRelayout = true

    // MARK: - Init

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        wantsLayer = true
        layer?.masksToBounds = clipContent
    }

    /// Flutter 坐标系：原点左上，y 向下
    override var isFlipped: Bool { true }

    override var intrinsicContentSize: NSSize {
        let proposal = bounds.size.width > 0 || bounds.size.height > 0
            ? bounds.size
            : CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        performLayout(in: proposal, applyFrames: false)
        return fittedContentSize
    }

    /// 按给定主轴可用宽度/高度计算完整包住子项所需尺寸
    func sizeThatFitsContent(in proposedSize: CGSize) -> CGSize {
        performLayout(in: proposedSize, applyFrames: false)
        return fittedContentSize
    }

    // MARK: - Arranged children

    func replaceArrangedSubviews(_ views: [NSView]) {
        let nextIDs = Set(views.map(ObjectIdentifier.init))
        for view in arrangedSubviews where !nextIDs.contains(ObjectIdentifier(view)) {
            view.removeFromSuperview()
            measureCache.removeValue(forKey: ObjectIdentifier(view))
        }

        arrangedSubviews = views
        for view in views where view.superview !== self {
            addSubview(view)
        }
        invalidateWrapLayout()
    }

    func addArrangedSubview(_ view: NSView) {
        guard !arrangedSubviews.contains(where: { $0 === view }) else { return }
        arrangedSubviews.append(view)
        addSubview(view)
        invalidateWrapLayout()
    }

    func removeArrangedSubview(_ view: NSView) {
        guard let idx = arrangedSubviews.firstIndex(where: { $0 === view }) else { return }
        arrangedSubviews.remove(at: idx)
        view.removeFromSuperview()
        measureCache.removeValue(forKey: ObjectIdentifier(view))
        invalidateWrapLayout()
    }

    func invalidateChildSizes() {
        measureCache.removeAll(keepingCapacity: true)
        invalidateWrapLayout()
    }

    // MARK: - Layout entry

    private func invalidateWrapLayout() {
        needsRelayout = true
        invalidateIntrinsicContentSize()
        needsLayout = true
    }

    override func layout() {
        super.layout()
        performLayout(in: bounds.size, applyFrames: true)
    }

    override func setFrameSize(_ newSize: NSSize) {
        let changed = abs(newSize.width - bounds.size.width) > 0.5
            || abs(newSize.height - bounds.size.height) > 0.5
        super.setFrameSize(newSize)
        if changed {
            needsRelayout = true
        }
    }

    private func performLayout(in containerSize: CGSize, applyFrames: Bool) {
        let childCount = arrangedSubviews.count
        if childCount == 0 {
            fittedContentSize = .zero
            lastLaidBounds = containerSize
            needsRelayout = false
            return
        }

        if applyFrames,
           !needsRelayout,
           abs(lastLaidBounds.width - containerSize.width) < 0.5,
           abs(lastLaidBounds.height - containerSize.height) < 0.5 {
            return
        }

        let isHorizontal = direction == .horizontal
        let mainLimit: CGFloat = {
            let value = isHorizontal ? containerSize.width : containerSize.height
            return value.isFinite && value > 0 ? value : CGFloat.greatestFiniteMagnitude
        }()
        let crossLimit: CGFloat = {
            let value = isHorizontal ? containerSize.height : containerSize.width
            return value.isFinite && value > 0 ? value : CGFloat.greatestFiniteMagnitude
        }()

        // 1) Measure — 使用完整展示尺寸
        metrics.removeAll(keepingCapacity: true)
        if metrics.capacity < childCount {
            metrics.reserveCapacity(childCount)
        }
        for view in arrangedSubviews {
            let size = measuredSize(for: view)
            metrics.append(isHorizontal
                           ? ChildMetric(main: size.width, cross: size.height)
                           : ChildMetric(main: size.height, cross: size.width))
        }

        // 2) Pack runs
        runs.removeAll(keepingCapacity: true)
        var index = 0
        while index < childCount {
            var runMain: CGFloat = 0
            var runCross: CGFloat = 0
            var count = 0
            let start = index

            while index < childCount {
                let child = metrics[index]
                let nextMain = count == 0 ? child.main : runMain + spacing + child.main
                // 子项本身比主轴还宽时仍独占一行，保证完整展示
                if count > 0, nextMain > mainLimit {
                    break
                }
                runMain = nextMain
                runCross = max(runCross, child.cross)
                count += 1
                index += 1
            }

            if count == 0 {
                let child = metrics[index]
                runs.append(RunInfo(start: index, count: 1, mainExtent: child.main, crossExtent: child.cross))
                index += 1
            } else {
                runs.append(RunInfo(start: start, count: count, mainExtent: runMain, crossExtent: runCross))
            }
        }

        let runCount = runs.count
        var totalRunCross: CGFloat = 0
        var maxRunMain: CGFloat = 0
        for i in 0..<runCount {
            totalRunCross += runs[i].crossExtent
            maxRunMain = max(maxRunMain, runs[i].mainExtent)
        }
        if runCount > 1 {
            totalRunCross += CGFloat(runCount - 1) * runSpacing
        }

        // 内容尺寸必须包住所有子项（含比容器更宽的单个子项）
        if isHorizontal {
            fittedContentSize = CGSize(width: maxRunMain, height: totalRunCross)
        } else {
            fittedContentSize = CGSize(width: totalRunCross, height: maxRunMain)
        }

        guard applyFrames else {
            lastLaidBounds = containerSize
            needsRelayout = false
            return
        }

        // 3) Place — 交叉轴多余空间仅在「容器比内容更大」时分配，不压缩子项
        let freeCross = max(crossLimit - totalRunCross, 0)
        let runLead = leadingSpace(free: freeCross, count: runCount, alignment: runAlignment)
        let runGap = betweenSpace(free: freeCross, count: runCount, alignment: runAlignment)

        let reverseMain = (isHorizontal && textDirection == .rtl)
            || (!isHorizontal && verticalDirection == .up)
        let reverseCross = (isHorizontal && verticalDirection == .up)
            || (!isHorizontal && textDirection == .rtl)

        var crossCursor = runLead
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0

        for runOffset in 0..<runCount {
            let runIndex = reverseCross ? (runCount - 1 - runOffset) : runOffset
            let run = runs[runIndex]
            // 主轴对齐基于「内容主轴」而非可能更小的容器，避免把子项挤出可视区
            let alignMainLimit = max(mainLimit, run.mainExtent)
            let freeMain = max(alignMainLimit - run.mainExtent, 0)
            let childLead = leadingSpace(free: freeMain, count: run.count, alignment: alignment)
            let childGap = betweenSpace(free: freeMain, count: run.count, alignment: alignment)

            var mainCursor = childLead
            for childOffset in 0..<run.count {
                let childIndex = reverseMain
                    ? (run.start + run.count - 1 - childOffset)
                    : (run.start + childOffset)
                let metric = metrics[childIndex]
                let view = arrangedSubviews[childIndex]

                let childMain = metric.main
                let childCross = (crossAxisAlignment == .stretch) ? run.crossExtent : metric.cross

                let crossOffset: CGFloat
                switch crossAxisAlignment {
                case .start, .stretch: crossOffset = 0
                case .end: crossOffset = run.crossExtent - childCross
                case .center: crossOffset = (run.crossExtent - childCross) * 0.5
                }

                let frame: NSRect
                if isHorizontal {
                    frame = NSRect(x: mainCursor,
                                   y: crossCursor + crossOffset,
                                   width: childMain,
                                   height: childCross)
                } else {
                    frame = NSRect(x: crossCursor + crossOffset,
                                   y: mainCursor,
                                   width: childCross,
                                   height: childMain)
                }

                if view.frame != frame {
                    view.frame = frame
                }
                maxX = max(maxX, frame.maxX)
                maxY = max(maxY, frame.maxY)

                mainCursor += childMain
                if childOffset < run.count - 1 {
                    mainCursor += spacing + childGap
                }
            }

            crossCursor += run.crossExtent
            if runOffset < runCount - 1 {
                crossCursor += runSpacing + runGap
            }
        }

        // 以子项实际帧并集为准，确保完全展示
        fittedContentSize = CGSize(width: ceil(maxX), height: ceil(maxY))
        lastLaidBounds = containerSize
        needsRelayout = false
    }

    // MARK: - Measure

    private func measuredSize(for view: NSView) -> CGSize {
        let key = ObjectIdentifier(view)
        if let cached = measureCache[key] {
            return cached
        }

        let size = fullyVisibleSize(for: view)
        measureCache[key] = size
        return size
    }

    /// 保证标题/控件完整可见的测量（尤其修正 NSButton.sizeThatFits 偏小）
    private func fullyVisibleSize(for view: NSView) -> CGSize {
        if let button = view as? NSButton {
            return fullyVisibleButtonSize(button)
        }

        if let control = view as? NSControl {
            var size = control.sizeThatFits(NSSize(width: CGFloat.greatestFiniteMagnitude,
                                                   height: CGFloat.greatestFiniteMagnitude))
            if size.width <= 0 || size.height <= 0 {
                let fitting = control.fittingSize
                size = CGSize(width: max(size.width, fitting.width),
                              height: max(size.height, fitting.height))
            }
            return CGSize(width: max(ceil(size.width), 1), height: max(ceil(size.height), 1))
        }

        let fitting = view.fittingSize
        if fitting.width > 0 || fitting.height > 0 {
            return CGSize(width: max(ceil(fitting.width), 1), height: max(ceil(fitting.height), 1))
        }

        let intrinsic = view.intrinsicContentSize
        if intrinsic.width > 0, intrinsic.width < NSView.noIntrinsicMetric,
           intrinsic.height > 0, intrinsic.height < NSView.noIntrinsicMetric {
            return CGSize(width: ceil(intrinsic.width), height: ceil(intrinsic.height))
        }

        if view.frame.width > 0 || view.frame.height > 0 {
            return CGSize(width: ceil(view.frame.width), height: ceil(view.frame.height))
        }
        return CGSize(width: 44, height: 24)
    }

    private func fullyVisibleButtonSize(_ button: NSButton) -> CGSize {
        // 优先走 Cell 尺寸（NNButtonCell 已含 contentInsets）
        if let cell = button.cell as? NSButtonCell {
            let size = cell.cellSize
            if size.width > 0, size.height > 0 {
                return CGSize(width: ceil(size.width), height: ceil(size.height))
            }
        }

        let attrs: [NSAttributedString.Key: Any] = [
            .font: button.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        ]
        let title = button.attributedTitle.length > 0
            ? button.attributedTitle
            : NSAttributedString(string: button.title, attributes: attrs)
        let titleSize = title.size()

        let insets = (button.cell as? NNButtonCell)?.contentInsets ?? NSEdgeInsets()
        let horizontalPadding = insets.left + insets.right
        let verticalPadding = insets.top + insets.bottom

        var imageSize = CGSize.zero
        if let image = button.image {
            imageSize = image.size
        }

        let width: CGFloat
        let height: CGFloat
        if button.imagePosition == .imageLeft || button.imagePosition == .imageRight
            || button.imagePosition == .imageLeading || button.imagePosition == .imageTrailing {
            width = titleSize.width + imageSize.width + horizontalPadding + (imageSize.width > 0 ? 6 : 0)
            height = max(titleSize.height, imageSize.height) + verticalPadding
        } else if button.imagePosition == .imageAbove || button.imagePosition == .imageBelow {
            width = max(titleSize.width, imageSize.width) + horizontalPadding
            height = titleSize.height + imageSize.height + verticalPadding + (imageSize.height > 0 ? 4 : 0)
        } else if button.imagePosition == .imageOnly {
            width = imageSize.width + horizontalPadding
            height = imageSize.height + verticalPadding
        } else {
            width = titleSize.width + horizontalPadding
            height = titleSize.height + verticalPadding
        }

        let fitted = button.sizeThatFits(NSSize(width: CGFloat.greatestFiniteMagnitude,
                                                height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: max(ceil(width), ceil(fitted.width), 1),
                      height: max(ceil(height), ceil(fitted.height), 22))
    }

    // MARK: - Alignment (Flutter WrapAlignment)

    private func leadingSpace(free: CGFloat, count: Int, alignment: NNWrapAlignment) -> CGFloat {
        guard free > 0, count > 0 else { return 0 }
        switch alignment {
        case .start, .spaceBetween: return 0
        case .end: return free
        case .center: return free * 0.5
        case .spaceAround: return free / CGFloat(count) * 0.5
        case .spaceEvenly: return free / CGFloat(count + 1)
        }
    }

    private func betweenSpace(free: CGFloat, count: Int, alignment: NNWrapAlignment) -> CGFloat {
        guard free > 0, count > 1 else { return 0 }
        switch alignment {
        case .start, .end, .center: return 0
        case .spaceBetween: return free / CGFloat(count - 1)
        case .spaceAround: return free / CGFloat(count)
        case .spaceEvenly: return free / CGFloat(count + 1)
        }
    }
}
