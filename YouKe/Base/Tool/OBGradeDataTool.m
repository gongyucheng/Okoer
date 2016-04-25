//
//  OBGradeDataTool.m
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBGradeDataTool.h"
#import "FMDB.h"
#import "OBGradeModel.h"

@implementation OBGradeDataTool
static FMDatabase *_db;
+ (void)initialize
{
    //1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"gradeModel.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
//    [_db executeUpdate:@"DROP TABLE OBGradeModel"];

    //2.创表  列表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS OBGradeModel (pid real,desc text ,name text ,pic_uri text ,publisher_id real ,publisher_name text ,rank_id real ,rid real)"];
}

+(NSArray *)listModels
{
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM OBGradeModel"];
    NSMutableArray *gradeModels = [NSMutableArray array];
    while (set.next) {
        OBGradeModel *gradeModel = [[OBGradeModel alloc]init];
        gradeModel.pid = [set doubleForColumn:@"pid"];
        gradeModel.desc = [set stringForColumn:@"desc"];
        gradeModel.name = [set stringForColumn:@"name"];
        gradeModel.pic_uri = [set stringForColumn:@"pic_uri"];
        gradeModel.publisher_id = [set doubleForColumn:@"publisher_id"];
        gradeModel.publisher_name = [set stringForColumn:@"publisher_name"];
        gradeModel.rank_id = [set doubleForColumn:@"rank_id"];
        gradeModel.rid = [set doubleForColumn:@"rid"];
        [gradeModels addObject:gradeModel];
    }
    return gradeModels;
}

+(void)addListModel:(OBGradeModel *)listModel
{
    if (!listModel.publisher_name) {
        listModel.publisher_name = @"";
    }
    [_db executeUpdateWithFormat:@"INSERT INTO OBGradeModel (pid, desc,name,pic_uri,publisher_id,publisher_name, rank_id,rid) VALUES (%ld,%@,%@,%@,%ld,%@,%ld,%ld);",listModel.pid,listModel.desc,listModel.name,listModel.pic_uri,listModel.publisher_id,listModel.publisher_name,listModel.rank_id,listModel.rid];
}
+(BOOL)isSameListModelWithModel:(OBGradeModel *)model
{
    NSString *base = @"SELECT * FROM OBGradeModel WHERE pid = %ld";
    NSString *text = [NSString stringWithFormat:base,model.pid];
    FMResultSet *set = [_db executeQuery:text];
    if (set.next) {
        return YES;
    } else
        return NO;
}
+ (void)deleSql
{
    [_db executeUpdate:@"DELETE FROM OBGradeModel;"];
}
@end