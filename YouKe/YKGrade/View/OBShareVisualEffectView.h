//
//  OBShareVisualEffectView.h
//  YouKe
//
//  Created by obally on 15/8/30.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBVisualEffectView.h"

@protocol OBShareVisualEffectViewDelegate <NSObject>

@optional
- (void)shareVisualDidSelectedShareButtonWithSelectedShareType:(OBShareType)type;
@end

@interface OBShareVisualEffectView : UIView
//- (OBVisualEffectView *)effectViewWithFrame:(CGRect)rect;
@property(nonatomic,assign)id<OBShareVisualEffectViewDelegate> shareVisualDelegate;

@end

