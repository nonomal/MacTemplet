//
//  NSViewController+Hook.m
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/10.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

#import "NSViewController+Hook.h"
#import "NSObject+Hook.h"
#import "MacTemplet-Swift.h"

@implementation NSViewController (Hook)

+ (void)initialize{
    // Only swizzle the base class once. `self == self.class` is always true and
    // would re-swizzle every NSViewController subclass that inherits +initialize.
    if (self != [NSViewController class]) {
        return;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwizzleInstanceMethod([NSViewController class], @selector(loadView), @selector(hook_loadView));
    });
}

- (void)hook_loadView{
    // Use size only — window.frame origin is in screen space and must not be
    // applied as a view frame inside the window hierarchy.
    NSWindow *window = NSApplication.sharedApplication.mainWindow ?: NSApplication.sharedApplication.keyWindow;
    NSSize size = window ? window.contentLayoutRect.size : NSMakeSize(900, 600);
    if (size.width < 1 || size.height < 1) {
        size = NSMakeSize(900, 600);
    }
    self.view = [[NNView alloc] initWithFrame:NSMakeRect(0, 0, size.width, size.height)];
    self.view.wantsLayer = true;
    self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
}

@end
