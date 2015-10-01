//
//  XDKLrcView.m
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/11.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import "XDKLrcView.h"
#import "Masonry.h"
#import "XDKLrcTool.h"
#import "XDKLrcCell.h"
#import "XDKLrc.h"
#import "XDKLrcLabel.h"

@interface XDKLrcView() <UITableViewDataSource>

@property (nonatomic,weak)UITableView * tableView;

@property (nonatomic,strong) NSArray  *lrcArray;

@property (nonatomic,assign)NSInteger currentIndex;

@end

@implementation XDKLrcView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpTableView];
    }
    return self;
}

- (void)setLrcName:(NSString *)lrcName
{
    _lrcName = [lrcName copy];
    _lrcArray = [XDKLrcTool currentLrcArray:lrcName];
    [self.tableView reloadData];
}

- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = 30;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDKLrcCell *cell = [XDKLrcCell lrcCell:tableView];
    XDKLrc *lrc = self.lrcArray[indexPath.row];
    cell.lrc = lrc ;
    
    
    if (self.currentIndex == indexPath.row) {
        cell.label.font = [UIFont systemFontOfSize:15];
    }else{
        cell.label.font = [UIFont systemFontOfSize:13];
        cell.label.progress = 0;
    }
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
    }];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    NSInteger count = self.lrcArray.count;
    for (int i = 0; i < count; i++) {
        XDKLrc *lrc = self.lrcArray[i];
        if (i + 1 > count - 1) return;
        XDKLrc *nextLrc = self.lrcArray[i + 1];
        
        if (currentTime >= lrc.time && currentTime < nextLrc.time && self.currentIndex != i ) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            NSIndexPath *previousIndexPath = nil;
            if (self.currentIndex < count - 1) {
                previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            }
            self.currentIndex = i;
            
            [self.tableView reloadRowsAtIndexPaths:previousIndexPath == nil ? @[indexPath] :@[previousIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // 设置外面label文字
            self.lrcLabel.text = lrc.text;
        }
        
        if (self.currentIndex == i) {
            CGFloat ratio = (currentTime - lrc.time) / (nextLrc.time - lrc.time);
            XDKLrcCell *cell = (XDKLrcCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.label.progress = ratio;
            
            // 设置外面label进度
            self.lrcLabel.progress = (currentTime - lrc.time) / (nextLrc.time - lrc.time);
        }
    }
}

@end
















