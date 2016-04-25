//
//  OBAccount.m
//  YouKe
//
//  Created by obally on 15/7/23.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBAccount.h"

@implementation OBAccount
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.sid forKey:@"sid"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.originalicon forKey:@"originalicon"];
    [encoder encodeObject:self.created_time forKey:@"created_time"];
    [encoder encodeObject:self.passWord forKey:@"passWord"];
    [encoder encodeObject:self.imei forKey:@"imei"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isOKerLogin] forKey:@"isOKerLogin"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isQQLogin] forKey:@"isQQLogin"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isSinaLogin] forKey:@"isSinaLogin"];
    
    
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.token = [decoder decodeObjectForKey:@"token"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.originalicon = [decoder decodeObjectForKey:@"originalicon"];
        self.created_time = [decoder decodeObjectForKey:@"created_time"];
        self.passWord = [decoder decodeObjectForKey:@"passWord"];
        self.imei = [decoder decodeObjectForKey:@"imei"];
        self.isOKerLogin = [[decoder decodeObjectForKey:@"isOKerLogin"] integerValue];
        self.isQQLogin = [[decoder decodeObjectForKey:@"isQQLogin"] integerValue];
        self.isSinaLogin = [[decoder decodeObjectForKey:@"isSinaLogin"] integerValue];
        self.sid = [decoder decodeObjectForKey:@"sid"];
    }
    return self;
}

@end
