//
//  OBMyCenterViewController.h
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SummaryBlock)(NSString *summary);
@interface OBMyCenterViewController : UIViewController
@property(nonatomic,copy)SummaryBlock summaryBlock;
@property (nonatomic, copy) NSString *summary;
@end
