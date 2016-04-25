//
//  OBReplyCell.m
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBReplyCell.h"
@interface OBReplyCell ()
@property (nonatomic, retain) UIImageView *userIcon;
@property (nonatomic, retain) UILabel *userName;
@property (nonatomic, retain) UILabel *userText;
@property (nonatomic, retain) UILabel *timeLabel;
@end
@implementation OBReplyCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"kpcell";
    OBReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBReplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundView = nil;
        //        cell.backgroundColor = HWRandomColor;
        
        //创转单元格内容视图
        //        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        
    }
    return self;
}

- (void)initViews
{
    
    
}

@end
