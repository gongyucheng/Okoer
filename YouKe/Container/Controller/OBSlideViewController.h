//
//  OBSlideViewController.h
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ListIndexBlock)(NSInteger index);
@interface OBSlideViewController : UIViewController
@property(nonatomic,copy)ListIndexBlock block;
@end
