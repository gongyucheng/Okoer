//
//  OBKPDataTool.m
//  YouKe
//
//  Created by obally on 15/7/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKPDataTool.h"
#import "FMDB.h"
#import "OBKPListModel.h"

@implementation OBKPDataTool
static FMDatabase *_db;
+ (void)initialize
{
    
    //1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"kpListModel.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
//    [_db executeUpdate:@"DROP TABLE OBKPListModel"];
    //2.创表  恪评列表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS OBKPListModel (nid real,author text,category text,chat_count real,collection_count real,comment_count real,created_time real,img_uri text,like_count real ,subtitle text,summary text ,title text,publisher text,web_path text)"];
   
}

+(NSArray *)listModels
{
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM OBKPListModel;"];
    NSMutableArray *kpListModels = [NSMutableArray array];
    while (set.next) {
        OBKPListModel *kpListModel = [[OBKPListModel alloc]init];
        kpListModel.nid = [set doubleForColumn:@"nid"];
        kpListModel.author = [set stringForColumn:@"author"];
        kpListModel.category = [set stringForColumn:@"category"];
        kpListModel.chat_count = [set doubleForColumn:@"chat_count"];
        kpListModel.collection_count = [set doubleForColumn:@"collection_count"];
        kpListModel.comment_count = [set doubleForColumn:@"comment_count"];
        kpListModel.created_time = [set doubleForColumn:@"created_time"];
        kpListModel.img_uri = [set stringForColumn:@"img_uri"];
        kpListModel.like_count = [set doubleForColumn:@"like_count"];
        kpListModel.subtitle = [set stringForColumn:@"subtitle"];
        kpListModel.summary = [set stringForColumn:@"summary"];
        kpListModel.title = [set stringForColumn:@"title"];
        kpListModel.publisher = [set stringForColumn:@"publisher"];
        kpListModel.web_path = [set stringForColumn:@"web_path"];
        [kpListModels addObject:kpListModel];
    }
    return kpListModels;
}

+(void)addListModel:(OBKPListModel *)listModel
{
    [_db executeUpdateWithFormat:@"INSERT INTO OBKPListModel (nid, author,category, chat_count,collection_count, comment_count,created_time, img_uri,like_count, subtitle,summary,title,publisher,web_path) VALUES (%ld,%@,%@,%ld,%ld,%ld,%ld,%@,%ld,%@,%@,%@,%@,%@);",listModel.nid,listModel.author,listModel.category,listModel.chat_count,listModel.collection_count,listModel.comment_count,listModel.created_time,listModel.img_uri,listModel.like_count,listModel.subtitle,listModel.summary,listModel.title,listModel.publisher,listModel.web_path];
}

+(BOOL)isSameListModelWithModel:(OBKPListModel *)model
{
    NSString *base = @"SELECT * FROM OBKPListModel WHERE nid = %ld";
    NSString *text = [NSString stringWithFormat:base,model.nid];
    FMResultSet *set = [_db executeQuery:text];
    if (set.next) {
        return YES;
    } else
        return NO;

}

+ (void)deleSql
{
    [_db executeUpdate:@"DELETE FROM OBKPListModel"];
}
@end
