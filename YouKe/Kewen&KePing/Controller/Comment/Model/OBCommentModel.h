//
//  OBCommentModel.h
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBUserModel.h"
@interface OBCommentModel : NSObject

@property (nonatomic, assign) NSInteger created_time;
@property (nonatomic, assign) NSInteger changed_time;
@property (nonatomic, assign) NSInteger nid; //被评论的内容节点ID
@property (nonatomic, assign) NSInteger pid; //评论的父id
@property (nonatomic, assign) NSInteger uid; //发布评论的用户id
@property (nonatomic, assign) NSInteger cid;  //评论唯一id
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *thread;
@property (nonatomic, retain) OBUserModel *user;

@end
