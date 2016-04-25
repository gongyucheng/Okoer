//
//  OBChatListModel.h
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBChatListModel : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) NSInteger changed_time;
@property (nonatomic, assign) NSInteger chat_count;
@property (nonatomic, assign) NSInteger created_time;
@property (nonatomic, copy) NSString *img_uri;
@property (nonatomic, copy) NSString *last_message;
@property (nonatomic, copy) NSString *last_user;
@property (nonatomic, copy) NSString *last_user_img_uri;
@property (nonatomic, assign) NSInteger nid;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *title;
@end
