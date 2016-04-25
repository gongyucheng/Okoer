//
//  OBAccount.h
//  YouKe
//
//  Created by obally on 15/7/23.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, OBLoginType) {
    OBLoginTypeOkoer = 0,
    OBLoginTypeSina = 1,
    OBLoginTypeQQ = 2,
};
@interface OBAccount : NSObject
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *uid;  //okoer id
@property (nonatomic, copy) NSString *icon; //
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSString *imei; 
@property (nonatomic, copy) NSString *originalicon;
/**	access token的创建时间 */
@property (nonatomic, strong) NSDate *created_time;
@property(nonatomic,assign)BOOL isOKerLogin;
@property(nonatomic,assign)BOOL isQQLogin;
@property(nonatomic,assign)BOOL isSinaLogin;
@property (nonatomic, copy) NSString *sid; //第三方的id
//@property (nonatomic, assign) OBLoginType type;// 0 表示是Okoer   1 表示是第三方登录
@end
