//
//  OBMyCollectionModel.h
//  YouKe
//
//  Created by obally on 15/8/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBKPListModel.h"
#import "OBKWListModel.h"

@interface OBMyCollectionModel : NSObject
@property(nonatomic,copy)NSString *type;
@property (nonatomic, retain) OBKPListModel *kpModel;
//@property (nonatomic, retain) OBKWListModel *kwModel;
@end
