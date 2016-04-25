//
//  OBVisualEffectView.h
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OBShareType) {
    OBShareTypeSinaWeibo = 0,
    OBShareTypeWeiXinSession = 1,
    OBShareTypeWeixinTimeline = 2,
    OBShareTypeQQSession = 3,
    OBShareTypeQQTimeline = 4,
    OBShareTypeEmail = 5
};

@protocol OBVisualEffectViewDelegate <NSObject>
@optional
- (void)didSelectedLoveButtonWithSelected:(BOOL)isSelected;
- (void)didSelectedCommentButton;
- (void)didSelectedCollectionButtonWithSelected:(BOOL)isSelected;
- (void)didSelectedShareButtonWithSelectedShareType:(OBShareType)type;
@end
@interface OBVisualEffectView : UIView
//- (OBVisualEffectView *)effectViewWithFrame:(CGRect)rect;
@property(nonatomic,assign)id<OBVisualEffectViewDelegate> visualDelegate;
@property(nonatomic,assign)NSInteger likeCount;
@property(nonatomic,assign)NSInteger commentCount;
@property(nonatomic,assign)NSInteger nid;
@property(nonatomic,assign)BOOL isKePing;

@end
