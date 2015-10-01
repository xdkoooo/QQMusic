//
//  XDKLrcCell.h
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/11.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDKLrc;
@class XDKLrcLabel;
@interface XDKLrcCell : UITableViewCell

@property (nonatomic,strong) XDKLrc  *lrc;

+ (instancetype)lrcCell:(UITableView *)tableView;

@property (nonatomic,weak,readonly)XDKLrcLabel * label;

@end
