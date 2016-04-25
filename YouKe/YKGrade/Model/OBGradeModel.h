//
//  OBGradeModel.h
//  YouKe
//
//  Created by obally on 15/8/14.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBGradeModel : NSObject
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic_uri;
@property (nonatomic, assign)NSInteger publisher_id;
@property (nonatomic, copy) NSString *publisher_name;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger rank_id;
@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy)NSString *c_title;
@end
