//
//  OBJBKWDataTool.m
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBJBKWDataTool.h"
#import "FMDB.h"
#import "OBKWListModel.h"
@implementation OBJBKWDataTool
static FMDatabase *_db;
+ (void)initialize
{
    //    [_db executeUpdate:@"DROP TABLE OBKWListModel"];
    //1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"jbkwListModel.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    //2.创表  资讯列表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS OBJBKWListModel (nid real PRIMARY KEY,author text,category text,collection_count real,comment_count real ,created_time text ,img_uri text,like_count real,subtitle text ,summary text,title text)"];
}

+(NSArray *)listModels
{
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM OBJBKWListModel;"];
    NSMutableArray *kwListModels = [NSMutableArray array];
    while (set.next) {
        OBKWListModel *kwListModel = [[OBKWListModel alloc]init];
        kwListModel.nid = [set doubleForColumn:@"nid"];
        kwListModel.author = [set stringForColumn:@"author"];
        kwListModel.category = [set stringForColumn:@"category"];
        kwListModel.collection_count = [set doubleForColumn:@"collection_count"];
        kwListModel.comment_count = [set doubleForColumn:@"comment_count"];
        kwListModel.created_time = [set doubleForColumn:@"created_time"];
        kwListModel.img_uri = [set stringForColumn:@"img_uri"];
        kwListModel.like_count = [set doubleForColumn:@"like_count"];
        kwListModel.subtitle = [set stringForColumn:@"subtitle"];
        kwListModel.summary = [set stringForColumn:@"summary"];
        kwListModel.title = [set stringForColumn:@"title"];
        [kwListModels addObject:kwListModel];
    }
    return kwListModels;
}

+(void)addListModel:(OBKWListModel *)listModel
{
    [_db executeUpdateWithFormat:@"INSERT INTO OBJBKWListModel (nid, author,category,collection_count,comment_count,created_time, img_uri,like_count, subtitle,summary,title) VALUES (%ld,%@,%@,%ld,%ld,%ld,%@,%ld,%@,%@,%@);",listModel.nid,listModel.author,listModel.category,listModel.collection_count,listModel.comment_count,listModel.created_time,listModel.img_uri,listModel.like_count,listModel.subtitle,listModel.summary,listModel.title];
}
+ (void)deleSql
{
    [_db executeQuery:@"DELETE FROM OBKWListModel;"];
}
@end
