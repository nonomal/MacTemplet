/*
 File: DragDropImageView.swift
 Abstract: Custom subclass of NSImageView with support for drag and drop operations.
 */

import AppKit

@objc protocol DragDropImageViewDelegate: NSObjectProtocol {
    func dropComplete(_ filePath: String, name filename: String)
    @objc optional func dragComplete(_ filePath: String?, name filename: String, success: Bool)
}

@objcMembers
class DragDropImageView: NSImageView, NSDraggingSource, NSFilePromiseProviderDelegate {

    var highlight = false {
        didSet { needsDisplay = true }
    }

    var allowDrag = true
    var allowDrop = true
    weak var delegate: DragDropImageViewDelegate?
    var path: String?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        var types = NSImage.imageTypes.map { NSPasteboard.PasteboardType($0) }
        types.append(.fileURL)
        registerForDraggedTypes(types)
        allowDrag = true
        allowDrop = true
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard allowDrop else { return [] }
        guard NSImage.canInit(with: sender.draggingPasteboard),
              sender.draggingSourceOperationMask.contains(.copy) else {
            return []
        }
        highlight = true
        return .copy
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        highlight = false
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if highlight {
            NSColor.gray.set()
            let path = NSBezierPath(rect: bounds)
            path.lineWidth = 5
            path.stroke()
        }
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        highlight = false
        return true
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard sender.draggingSource as AnyObject? !== self else { return true }

        if NSImage.canInit(with: sender.draggingPasteboard) {
            image = NSImage(pasteboard: sender.draggingPasteboard)
        }

        if let fileURL = NSURL(from: sender.draggingPasteboard) as URL? {
            path = fileURL.path
            window?.title = fileURL.lastPathComponent
            delegate?.dropComplete(fileURL.path, name: fileURL.lastPathComponent)
        } else if path == nil {
            window?.title = "(no name)"
        }
        return true
    }

    override func mouseDown(with event: NSEvent) {
        guard allowDrag, let image = image else { return }

        let provider = NSFilePromiseProvider(fileType: "public.png", delegate: self)
        let draggingItem = NSDraggingItem(pasteboardWriter: provider)
        draggingItem.setDraggingFrame(bounds, contents: image)
        beginDraggingSession(with: [draggingItem], event: event, source: self)
    }

    func draggingSession(_ session: NSDraggingSession,
                         sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        .copy
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    // MARK: - NSFilePromiseProviderDelegate

    func filePromiseProvider(_ filePromiseProvider: NSFilePromiseProvider, fileNameForType fileType: String) -> String {
        (path as NSString?)?.lastPathComponent ?? "test.png"
    }

    func filePromiseProvider(_ filePromiseProvider: NSFilePromiseProvider,
                             writePromiseTo url: URL,
                             completionHandler: @escaping (Error?) -> Void) {
        let filename = url.lastPathComponent
        guard let image = image else {
            delegate?.dragComplete?(path, name: filename, success: false)
            completionHandler(NSError(domain: "DragDropImageView", code: -1))
            return
        }

        let data: Data?
        if let tiff = image.tiffRepresentation,
           let rep = NSBitmapImageRep(data: tiff) {
            data = rep.representation(using: .png, properties: [:]) ?? tiff
        } else {
            data = image.tiffRepresentation
        }

        do {
            guard let data else {
                delegate?.dragComplete?(path, name: filename, success: false)
                completionHandler(NSError(domain: "DragDropImageView", code: -2))
                return
            }
            try data.write(to: url, options: .atomic)
            delegate?.dragComplete?(path, name: filename, success: true)
            completionHandler(nil)
        } catch {
            delegate?.dragComplete?(path, name: filename, success: false)
            completionHandler(error)
        }
    }
}
