//
//  OBKWDetailModel.h
//  YouKe
//
//  Created by obally on 15/8/10.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBKWDetailModel : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) NSInteger changed_time;
@property (nonatomic, copy) NSString *collection_count;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger created_time;
@property (nonatomic, copy) NSString *img_uri;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger nid;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *relateds;
@property (nonatomic, copy) NSString *web_path;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, assign) NSInteger publish_time;
@end
