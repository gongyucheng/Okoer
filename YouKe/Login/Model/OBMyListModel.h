//
//  OBMyListModel.h
//  YouKe
//
//  Created by obally on 16/1/6.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBMyListModel : NSObject
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger lid; //清单id
@property(nonatomic,assign)NSInteger product_count;//清单数量
@property(nonatomic,assign)BOOL isSelected;
@end
