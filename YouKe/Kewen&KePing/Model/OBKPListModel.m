//
//  OBKPListModel.m
//  YouKe
//
//  Created by obally on 15/8/10.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKPListModel.h"

@implementation OBKPListModel
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.category forKey:@"category"];
    [encoder encodeObject:self.changed_time forKey:@"changed_time"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.collection_count] forKey:@"collection_count"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.chat_count] forKey:@"chat_count"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.comment_count] forKey:@"comment_count"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.created_time] forKey:@"created_time"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.like_count] forKey:@"like_count"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.nid] forKey:@"nid"];
    [encoder encodeObject:self.img_uri forKey:@"img_uri"];
    [encoder encodeObject:self.subtitle forKey:@"subtitle"];
    [encoder encodeObject:self.summary forKey:@"summary"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.tags forKey:@"tags"];
     [encoder encodeObject:self.publisher forKey:@"publisher"];
    
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.author = [decoder decodeObjectForKey:@"author"];
        self.category = [decoder decodeObjectForKey:@"category"];
        self.changed_time = [decoder decodeObjectForKey:@"changed_time"];
        self.collection_count = [[decoder decodeObjectForKey:@"collection_count"]integerValue];
        self.chat_count = [[decoder decodeObjectForKey:@"chat_count"]integerValue];
        self.created_time = [[decoder decodeObjectForKey:@"created_time"]integerValue];
        self.like_count = [[decoder decodeObjectForKey:@"like_count"]integerValue];
        self.nid = [[decoder decodeObjectForKey:@"nid"]integerValue];
        self.img_uri = [decoder decodeObjectForKey:@"img_uri"];
        self.subtitle = [decoder decodeObjectForKey:@"subtitle"];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.tags = [decoder decodeObjectForKey:@"tags"];
        self.publisher = [decoder decodeObjectForKey:@"publisher"];
    }
    return self;
}
@end
