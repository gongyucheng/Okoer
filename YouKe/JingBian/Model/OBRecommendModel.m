//
//  OBRecommendModel.m
//  YouKe
//
//  Created by obally on 15/8/11.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBRecommendModel.h"

@implementation OBRecommendModel
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.kpModel forKey:@"kpModel"];
    [encoder encodeObject:self.kwModel forKey:@"kwModel"];
    
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.type = [decoder decodeObjectForKey:@"type"];
        self.kpModel = [decoder decodeObjectForKey:@"kpModel"];
        self.kwModel = [decoder decodeObjectForKey:@"kwModel"];
    }
    return self;
}
@end
