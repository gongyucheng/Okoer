//
//  OBKeWenAndKePingController.h
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OBBaseViewController.h"
@protocol OBKeWenAndKePingControllerDelegate <NSObject>
@optional
- (void)didSelectedChatButtonCallUpButton;

@end
@interface OBKeWenAndKePingController : UIViewController
@property(nonatomic,assign)BOOL isSlide;
@property(nonatomic,assign)NSInteger jblastReadPage;
@property(nonatomic,assign)id<OBKeWenAndKePingControllerDelegate> kwAndkpDelegate;
@end
