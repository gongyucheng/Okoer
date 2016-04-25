//
//  OBBottomBackView.h
//  YouKe
//
//  Created by obally on 15/8/20.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OBBottomBackViewDelegate <NSObject>
@optional
- (void)backViewdidSelectedBackbutton;
- (void)backViewdidSelectedCommentButton;
- (void)backViewdidSelectedShareButton;
- (void)backViewdidSelectedChatButton;
@end
@interface OBBottomBackView : UIView
@property(nonatomic,assign)BOOL showChat;
@property(nonatomic,assign)id<OBBottomBackViewDelegate> backbottomDelegate;
@property(nonatomic,assign)NSInteger nid;
@end
