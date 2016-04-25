//
//  OBContainerViewController.h
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBBaseViewController.h"

@interface OBContainerViewController : OBBaseViewController
@property(nonatomic,assign)NSInteger jblastReadPage;
- (void)loadOpenView;
@property(nonatomic,assign)BOOL isSlide;
@end
