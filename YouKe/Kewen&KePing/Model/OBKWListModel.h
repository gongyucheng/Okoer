//
//  OBKWListModel.h
//  YouKe
//
//  Created by obally on 15/8/10.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBKWListModel : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *changed_time;
@property (nonatomic, assign) NSInteger collection_count;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, assign) NSInteger created_time;
@property (nonatomic, copy) NSString *img_uri;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger nid;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *publish_time;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, copy) NSString *web_path;
@property (nonatomic, assign) NSInteger publish_time;
@end
