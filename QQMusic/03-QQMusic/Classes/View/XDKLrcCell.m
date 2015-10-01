//
//  XDKLrcCell.m
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/11.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import "XDKLrcCell.h"
#import "xdklrc.h"
#import "XDKLrcLabel.h"
#import "Masonry.h"

@interface XDKLrcCell()

@end

@implementation XDKLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        XDKLrcLabel *label = [[XDKLrcLabel alloc] init];
        [self.contentView addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        _label = label;
    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.label.frame = self.contentView.bounds;
//}


+ (instancetype)lrcCell:(UITableView *)tableView
{
    static NSString * ID = @"lrc";
    XDKLrcCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDKLrcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setLrc:(XDKLrc *)lrc
{
    self.label.text = lrc.text;
}

@end
