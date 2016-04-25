//
//  OBChatMessageModel.h
//  YouKe
//
//  Created by obally on 15/8/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBChatMsgModel.h"
#import "OBChatUserModel.h"

@interface OBChatMessageModel : NSObject

@property (nonatomic, copy) NSString *chat_id;
@property (nonatomic, copy) NSString *req_id;
@property (nonatomic, retain) OBChatUserModel *user;
@property (nonatomic, retain) OBChatMsgModel *msg;


@end
