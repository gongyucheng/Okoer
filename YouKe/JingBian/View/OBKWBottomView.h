//
//  OBKWBottomView.h
//  YouKe
//
//  Created by obally on 15/7/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OBKWBottomviewDelegate <NSObject>
@optional
- (void)didSelectedLoveButtonWithSelected:(BOOL)isSelected;
- (void)didSelectedCommentButton;
- (void)didSelectedShareButton;
@end
@interface OBKWBottomView : UIView
@property(nonatomic,assign)id<OBKWBottomviewDelegate> kwbottomDelegate;
//@property(nonatomic,copy)NSString *chatCount;
@property(nonatomic,assign)NSInteger likeCount;
@property(nonatomic,assign)NSInteger commentCount;
@end
