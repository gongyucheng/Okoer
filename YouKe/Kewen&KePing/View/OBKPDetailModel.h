//
//  OBKPDetailModel.h
//  YouKe
//
//  Created by obally on 15/8/10.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBKPDetailModel : NSObject
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) NSInteger changed_time;
@property (nonatomic, assign) NSInteger chat_count;
@property (nonatomic, assign) NSInteger collection_count;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, copy) NSString *cover_uri;
@property (nonatomic, assign) NSInteger created_time;
@property (nonatomic, copy) NSString *explain;
@property (nonatomic, retain) NSArray *grade_mb_pic_img_uri;
@property (nonatomic, retain) NSArray *grade_pc_pic_img_uri;
@property (nonatomic, copy) NSString *img_uri;
//@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, assign) NSInteger nid;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, retain) NSArray *relateds;
@property (nonatomic, copy) NSString *report_lead;
@property (nonatomic, copy) NSString *scoring_info;

@property (nonatomic, retain) NSArray *sheet_imgs;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, retain) NSArray *test_info;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, copy) NSString *unscramble;
@property (nonatomic, copy) NSString *vendor_feedback;
@property (nonatomic, copy) NSString *web_path;

@end
