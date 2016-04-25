//
//  OBChatRoomController.h
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBChatMessageFrame.h"

typedef void (^ChatMessageTableBlock)(OBChatMessageFrame *messageFrame);
@interface OBChatRoomController : UIViewController
@property (nonatomic, assign) NSInteger chatId;
@property (nonatomic, copy) NSString *roomtitle;
@property(nonatomic,copy)ChatMessageTableBlock chatMessageblock;
@end
