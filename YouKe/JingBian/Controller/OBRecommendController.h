//
//  OBRecommendController.h
//  YouKe
//
//  Created by obally on 15/7/23.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBRecommendController : UIViewController
- (void)loadOpenView;
- (void)removeLoadOpenView;
@property(nonatomic,assign)NSInteger lastReadPage;
@property(nonatomic,assign)BOOL isFirstLoad;
@property(nonatomic,assign)BOOL isNotFirstLoad;
@end
