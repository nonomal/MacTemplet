//
//  FirstViewController.m
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/11.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

#import "FirstViewController.h"
#import "ListViewController.h"

#import <SwiftExpand-Swift.h>

@interface FirstViewController ()

@property (nonatomic, strong) NSWindowController *windowCtrl;
@property (nonatomic, strong) NSSegmentedControl *segmentCtl;
@property (nonatomic, assign) NSModalSession modalSession;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.segmentCtl];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(windowWillClose:)
                                               name:NSWindowWillCloseNotification
                                             object:nil];
}

-(void)viewDidLayout{
    [super viewDidLayout];
    
    self.segmentCtl.frame = CGRectMake(0, 0, 200, 50);

}

- (void)viewWillAppear{
    [super viewWillAppear];

}

- (void)handleActionSender:(NSSegmentedControl *)sender{
    switch (sender.selectedSegment) {
        case 0:
        {
            [self.windowCtrl showWindow:nil];
        }
            break;
        case 1:
        {
            [NSApplication.sharedApplication runModalForWindow:self.windowCtrl.window];

        }
            break;
        case 2:
        {
            self.modalSession = [NSApplication.sharedApplication beginModalSessionForWindow:self.windowCtrl.window];

        }
            break;
        default:
            break;
    }
//    DDLog(@"%@", self.windowCtrl.contentViewController);
}

- (void)windowWillClose:(NSNotification *)notification {
    switch (self.segmentCtl.selectedSegment) {
        case 0:
        {
            [NSApplication.sharedApplication stopModal];
        }
            break;
        case 1:
        {
            [NSApplication.sharedApplication stopModal];

        }
            break;
        case 2:
        {
            [NSApplication.sharedApplication endModalSession:self.modalSession];

        }
            break;
        default:
            break;
    }
}

#pragma mark -lazy
-(NSWindowController *)windowCtrl{
    if (!_windowCtrl) {
        NSWindow *window = [[NSWindow alloc] initWithVc:nil size:NSWindow.defaultSize];
        window.title = @"First";
        ListViewController *contentVC = [[ListViewController alloc]init];
        window.contentViewController = contentVC;

        _windowCtrl = [[NSWindowController alloc]initWithWindow:window];

    }
    return _windowCtrl;
}

-(NSSegmentedControl *)segmentCtl{
    if (!_segmentCtl) {
        _segmentCtl = ({
            NSArray *items = @[@"事件_0", @"事件_1", @"事件_2",];
            NSSegmentedControl *view = [[NSSegmentedControl alloc] init];
            view.items = items;
            [view addActionHandler:^(NSControl * _Nonnull control) {
                NSSegmentedControl *sender = (NSSegmentedControl *)control;
                DDLog(@"%@", @(sender.selectedSegment));
                [self handleActionSender:sender];
                
            }];
            view;
        });
    }
    return _segmentCtl;
}

@end
