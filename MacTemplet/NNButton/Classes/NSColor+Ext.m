//
//  NSColor+Ext.m
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/23.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "NSColor+Ext.h"

#import <AppKit/AppKit.h>


@implementation NSColor (Ext)

+ (NSColor *)nn_lightBlue{
    return [NSColor hexValue:0x29B5FE alpha:1];
}

+ (NSColor *)nn_lightOrange{
    return [NSColor hexValue:0xFFBB50 alpha:1];
}

+ (NSColor *)nn_lightGreen{
    return [NSColor hexValue:0x1AC756 alpha:1];
}

+ (NSColor *)nn_line{
    return [NSColor hexValue:0xe4e4e4 alpha:1];
}

+ (NSColor *)hexValue:(NSInteger)rgbValue alpha:(CGFloat)alpha {
    return [NSColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                            alpha:alpha];
}

@end
