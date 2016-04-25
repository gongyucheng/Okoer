//
//  OBChatMsgModel.h
//  YouKe
//
//  Created by obally on 15/8/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBChatMsgModel : NSObject
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger revision;
@property (nonatomic, copy) NSString *content;
@end
