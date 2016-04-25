//
//  OBAddNewListView.h
//  YouKe
//
//  Created by obally on 16/1/6.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OBMyListModel;
typedef void(^SuccessAddToListBlock)(OBMyListModel *listModel);
@interface OBAddNewListView : UIView
@property(nonatomic,copy)SuccessAddToListBlock addSuccessBlock;
@end
