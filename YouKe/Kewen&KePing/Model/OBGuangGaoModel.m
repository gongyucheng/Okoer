//
//  OBGuangGaoModel.m
//  YouKe
//
//  Created by obally on 15/8/20.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBGuangGaoModel.h"

@implementation OBGuangGaoModel
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.click_uri forKey:@"click_uri"];
    [encoder encodeObject:self.click_uri forKey:@"img_uri"];
    [encoder encodeObject:self.subtitle forKey:@"subtitle"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:[NSNumber numberWithBool:self.nid] forKey:@"nid"];
    
    
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.click_uri = [decoder decodeObjectForKey:@"click_uri"];
        self.click_uri = [decoder decodeObjectForKey:@"click_uri"];
        self.subtitle = [decoder decodeObjectForKey:@"subtitle"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.nid = [[decoder decodeObjectForKey:@"nid"] integerValue];
        self.image = [decoder decodeObjectForKey:@"image"];
    }
    return self;
}

@end
