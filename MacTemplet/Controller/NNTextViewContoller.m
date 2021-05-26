//
//  NNTextViewContoller.m
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/26.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

#import "NNTextViewContoller.h"
#import "NNHeaderView.h"
#import "NoodleLineNumberView.h"

#import <SwiftExpand-Swift.h>

@interface NNTextViewContoller ()<NSControlTextEditingDelegate>

@property (nonatomic, strong) NSTextView *textView;
@property (nonatomic, strong) NSSlider *slider;
@property (nonatomic, strong) NSSlider *sliderOne;

@end

@implementation NNTextViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view addSubview:self.textView.enclosingScrollView];
    [NoodleLineNumberView setupLineNumberWithTextView:self.textView];
    
    [self.view addSubview:self.slider];
    [self.view addSubview:self.sliderOne];

    [self.view getViewLayer];
}

- (void)viewDidLayout{
    [super viewDidLayout];
    
    [self.textView.enclosingScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kX_GAP);
        make.left.equalTo(self.view).offset(kX_GAP);
        make.width.equalTo(400);
        make.bottom.equalTo(self.view).offset(-kX_GAP);
    }];
    
    [self.slider makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kX_GAP);
        make.left.equalTo(self.textView.enclosingScrollView.right).offset(20);
        make.width.equalTo(200);
        make.height.equalTo(50);
    }];
    
    [self.sliderOne makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kX_GAP);
        make.left.equalTo(self.slider.right).offset(20);
        make.width.equalTo(100);
        make.height.equalTo(50);
    }];
    
}

#pragma mark -NSControlTextEditingDelegate

- (void)controlTextDidBeginEditing:(NSNotification *)obj{
//    print("开始编辑")
}

- (void)controlTextDidChange:(NSNotification *)obj {
//    print("修改内容")
    NSTextField *textField = (NSTextField *)obj.object;
    DDLog(@"%@",textField.stringValue);
}

- (void)controlTextDidEndEditing:(NSNotification *)obj{
    NSTextField *textField = (NSTextField *)obj.object;
    //    DDLog(@"%@",textField.stringValue);
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector{
    NSLog(@"Selector method is (%@)", NSStringFromSelector(commandSelector));
    if (commandSelector == @selector(insertNewline:)) {
        //Do something against ENTER key

    } else if (commandSelector == @selector(deleteForward:)) {
        //Do something against DELETE key

    } else if (commandSelector == @selector(deleteBackward:)) {
        //Do something against BACKSPACE key

    } else if (commandSelector == @selector(insertTab:)) {
        //Do something against TAB key

    } else if (commandSelector == @selector(cancelOperation:)) {
        //Do something against Escape key
    }
    return YES;
}

#pragma mark -funtions

- (void)handleActionSlider:(NSSlider *)sender {
    CGFloat value = sender.floatValue;
    NSLog(@"sliderAction value： %f", value);
}


#pragma mark -lazy

-(NSTextView *)textView{
    if (!_textView) {
        _textView = ({
            NSTextView *view = [NSTextView create:CGRectZero];
            view.delegate = self;
            view.string = @"";
            view.font = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
            
            ///
            NSScrollView *scrollView = [[NSScrollView alloc] init];
            scrollView.backgroundColor = NSColor.redColor;
            
            scrollView.drawsBackground = false;//不画背景（背景默认画成白色）
//            scrollView.hasHorizontalScroller = true;
//            scrollView.hasVerticalScroller = true;
//            scrollView.autohidesScrollers = true;//自动隐藏滚动条（滚动的时候出现）
            scrollView.documentView = view;
            
            view;
        });
    }
    return _textView;
}

- (NSSlider *)slider{
    if (!_slider) {
        _slider = ({
            NSSlider *slider = [[NSSlider alloc]init];
            slider.wantsLayer = YES;
            slider.layer.backgroundColor = NSColor.lightGreen.CGColor;
            slider.sliderType = NSSliderTypeLinear;
            slider.tickMarkPosition = NSTickMarkPositionAbove;

            slider.numberOfTickMarks = 10;
            slider.allowsTickMarkValuesOnly = YES;
//            slider.vertical = true;
            slider.target = self;
            slider.action = @selector(handleActionSlider:);
            
            slider;
        });
        
    }
    return _slider;
}

- (NSSlider *)sliderOne{
    if (!_sliderOne) {
        _sliderOne = ({
            NSSlider *slider = [[NSSlider alloc]init];
            slider.wantsLayer = YES;
            slider.layer.backgroundColor = NSColor.lightGreen.CGColor;
            slider.sliderType = NSSliderTypeCircular;
            slider.tickMarkPosition = NSTickMarkPositionAbove;

            slider.numberOfTickMarks = 10;
            slider.allowsTickMarkValuesOnly = YES;
            slider.target = self;
            slider.action = @selector(handleActionSlider:);
            
            slider;
        });
    }
    return _sliderOne;
}



@end
