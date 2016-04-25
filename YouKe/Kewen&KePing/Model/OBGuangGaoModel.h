//
//  OBGuangGaoModel.h
//  YouKe
//
//  Created by obally on 15/8/20.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBGuangGaoModel : NSObject
@property (nonatomic, copy) NSString *click_uri;
@property (nonatomic, copy) NSString *img_uri;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger nid;
@property (nonatomic, retain) UIImage *image;

@end
