//
//  OBProductDetailModel.h
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBProductDetailModel : NSObject
@property (nonatomic, copy) NSString *b_name;
@property (nonatomic, copy) NSString *c_title;
@property (nonatomic, copy) NSString *defects;
@property (nonatomic, copy) NSString *law_info;
@property (nonatomic, retain) NSArray *parameters;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *namede;
@property (nonatomic, copy) NSString *pic_uri;
@property (nonatomic, copy) NSString *product_ingredient;
@property (nonatomic, copy) NSString *product_buy_details;
@property (nonatomic, copy) NSString *product_cn_channel;
@property (nonatomic, assign) NSInteger rank_id;
@property (nonatomic, copy) NSString *rank_rule;
@property (nonatomic, copy) NSString *test_method;
@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *source_uri;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *rank_desc_cn;
@property (nonatomic, copy) NSString *product_buy_time;
@property (nonatomic, copy) NSString *web_path;
@property (nonatomic, assign) NSInteger bid;
@property (nonatomic, assign) NSInteger cid;
@end
