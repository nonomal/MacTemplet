//
//  ListViewController.m
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/8.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

#import "ListViewController.h"

#define MAS_SHORTHAND_GLOBALS
#define MAS_SHORTHAND
#import "Masonry.h"

#import "NNTableRowView.h"
#import "NNTextField.h"

#import <SwiftExpand-Swift.h>

#import "MacTemplet-Swift.h"

@interface ListViewController ()<NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) NNTableView *tableView;
@property (nonatomic, strong) NSArray *list;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
//    self.view.layer.backgroundColor = NSColor.redColor.CGColor;
    
    [self setupTableView];
}

- (void)viewDidLayout{
    [super viewDidLayout];
    
    [self.tableView.enclosingScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.enclosingScrollView.superview);
    }];
}

- (void)viewWillAppear{
    [super viewWillAppear];

}

#pragma mark - NSTableViewDelegate,NSTableViewDataSource

//返回行数
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.list.count;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 50;
}
//// 使用默认cell显示数据
//-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    NSInteger item = [tableView.tableColumns indexOfObject:tableColumn];
//    NSArray * array = self.list[row];
//    return array[item];
//}
//// 使用自定义cell显示数据
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSInteger item = [tableView.tableColumns indexOfObject:tableColumn];
    NSArray *array = self.list[row];
    
    //获取表格列的标识符
    NSString *columnID = tableColumn.identifier;
//    DDLog(@"columnID : %@ ,row : %ld",columnID,row);
    
    static NSString *identifier = @"one";
//    NSTableCellView *cell = [NSTableCellView makeViewWithTableView:tableView identifier:identifier owner:self];
    NSTableCellView *cell = [tableView makeViewWithIdentifier:identifier owner:self];
    if (!cell) {
        NNTextField *textField = [NNTextField create:cell.bounds placeholder:@""];
        textField.alignment = NSTextAlignmentCenter;
        textField.isTextAlignmentVerticalCenter = true;
        
        cell = [[NSTableCellView alloc]init];
        cell.identifier = identifier;
        cell.textField = textField;
        [cell addSubview:textField];
    }

//    cell.layer.backgroundColor = NSColor.yellowColor.CGColor;
//    cell.imageView.image = [NSImage imageNamed:@"swift"];
    cell.textField.stringValue = [NSString stringWithFormat:@"cell %ld",(long)row];
    cell.textField.stringValue = [NSString stringWithFormat:@"%@",array[item]];
    cell.textField.stringValue = array[item];

    return cell;
}

//设置每行容器视图
- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
    NNTableRowView *rowView = [[NNTableRowView alloc]init];
    rowView.backgroundColor = NSColor.yellowColor;
    return rowView;
}

#pragma mark - 是否可以选中单元格
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    //设置cell选中高亮颜色
    NSTableRowView *rowView = [tableView rowViewAtRow:row makeIfNecessary:NO];
    rowView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
    rowView.emphasized = false;
    
    DDLog(@"shouldSelectRow : %ld",row);
    return YES;
}

// 点击表头
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    
    DDLog(@"%@", tableColumn);
}

//选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification *)notification{
//    NSTableView *tableView = notification.object;
//    DDLog(@"didSelect：%@",notification);
}

- (NSString *)tableView:(NSTableView *)tableView toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect tableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation{
    NSInteger item = [tableView.tableColumns indexOfObject:tableColumn];
    NSString *string = [NSString stringWithFormat:@"{%@,%@}", @(row), @(item)];
    return string;
}

- (BOOL)tableView:(NSTableView *)tableView shouldShowCellExpansionForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    return true;
}

- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return true;
}

//手势滑动（要用触摸板，用普通鼠标不能实现）
- (NSArray<NSTableViewRowAction *> *)tableView:(NSTableView *)tableView rowActionsForRow:(NSInteger)row edge:(NSTableRowActionEdge)edge {
    //向左边水滑动
    if(edge == NSTableRowActionEdgeTrailing) {
       NSTableViewRowAction* action =  [NSTableViewRowAction rowActionWithStyle:NSTableViewRowActionStyleDestructive title:@"DEMO" handler:
                                        ^(NSTableViewRowAction *action, NSInteger row){
            
           printf("点击了DEMO");
       }];
        action.backgroundColor = NSColor.orangeColor;
        
        NSTableViewRowAction *action2 =  [NSTableViewRowAction rowActionWithStyle:NSTableViewRowActionStyleDestructive title:@"DEMO1" handler:^(NSTableViewRowAction *action, NSInteger row){

            printf("点击了DEMO1");
        }];
        
        action2.backgroundColor = NSColor.redColor;
        return @[action , action2];
    }
    
    if(edge == NSTableRowActionEdgeLeading) {
        NSTableViewRowAction *action =  [NSTableViewRowAction rowActionWithStyle:NSTableViewRowActionStyleDestructive title:@"AAA" handler:
                                         ^(NSTableViewRowAction *action, NSInteger row){
                                             
                                             printf("点击了AAA");
                                         }];
         action.backgroundColor = NSColor.orangeColor;
        
        NSTableViewRowAction* action2 =  [NSTableViewRowAction rowActionWithStyle:NSTableViewRowActionStyleDestructive title:@"BBB" handler:^(NSTableViewRowAction *action, NSInteger row){
            printf("点击了BBB");
        }];
        action2.backgroundColor = NSColor.redColor;
        return @[action , action2];
    }
    return @[];
}

#pragma mark -funtions

-(void)setupTableView{
    NSArray *columns = @[@"columeOne", @"columeTwo", @"columeThree",];
    columns = self.list.firstObject;
    [columns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSTableColumn *column = [NSTableColumn createWithIdentifier:obj title:obj];
        [self.tableView addTableColumn:column];
    }];
    [self.view addSubview:self.tableView.enclosingScrollView];
}

#pragma mark -lazy
-(NNTableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            NNTableView *view = [NNTableView create:CGRectZero];
            view.delegate = self;
            view.dataSource = self;
            view;
        });
    }
    return _tableView;
}

- (NSArray *)list{
    if (!_list) {
        _list = @[@[@"名称",@"总数",@"剩余",@"IP",@"状态",@"状态1",@"状态2",@"状态3",@"状态4"],
                    @[@"ces1",@0,@0,@"3.4.5.6",@"027641081087",@"1",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces2",@0,@0,@"3.4.5.6",@"027641081087",@"2",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces3",@0,@0,@"3.4.5.6",@"027641081087",@"3",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces4",@0,@0,@"3.4.5.6",@"027641081087",@"4",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces5",@0,@0,@"3.4.5.6",@"027641081087",@"5",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces6",@"",@0,@"3.4.5.6",@"027641081087",@"6",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces7",@0,@0,@"3.4.5.6",@"027641081087",@"7",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces8",@0,@0,@"3.4.5.6",@"027641081087",@"8",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces9",@0,@0,@"3.4.5.6",@"027641081087",@"9",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces10",@0,@0,@"3.4.5.6",@"027641081087",@"1",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces11",@0,@0,@"3.4.5.6",@"027641081087",@"1",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces12",@0,@0,@"3.4.5.6",@"027641081087",@"2",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces13",@0,@0,@"3.4.5.6",@"027641081087",@"3",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces14",@0,@0,@"3.4.5.6",@"027641081087",@"4",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces15",@0,@0,@"3.4.5.6",@"027641081087",@"5",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces16",@"",@0,@"3.4.5.6",@"027641081087",@"6",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces17",@0,@0,@"3.4.5.6",@"027641081087",@"7",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces18",@0,@0,@"3.4.5.6",@"027641081087",@"8",@0,@"3.4.5.6",@"027641081087"],
                    @[@"ces19",@0,@0,@"3.4.5.6",@"027641081087",@"9",@0,@"3.4.5.6",@"027641081087"],
                    ];
    }
    return _list;
}


@end
