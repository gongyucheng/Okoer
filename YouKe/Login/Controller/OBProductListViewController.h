//
//  OBProductListViewController.h
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RemoveCompelitionBlock) ();
@interface OBProductListViewController : UIViewController
@property(nonatomic,assign)NSInteger lid;
@property (nonatomic, copy) NSString *listName;
@property (nonatomic, copy)RemoveCompelitionBlock complitionBlock ;
@end
