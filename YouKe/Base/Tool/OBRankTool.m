//
//  OBRankTool.m
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBRankTool.h"
#import "OBRankModel.h"
@implementation OBRankTool
+ (OBRankModel *)rankModelWithRankId:(NSInteger)rid
{
    OBRankModel *model = [[OBRankModel alloc]init];
    if (rid == 1) {
        model.name = @"A+";
        model.chineseName = @"卓越";
        model.color = HWColor(31, 167, 86);
        return model;
    }else if (rid == 2) {
        model.name = @"A";
        model.chineseName = @"优";
        model.color = HWColor(90, 207, 56);
        return model;
    }else if (rid == 3) {
        model.name = @"B";
        model.chineseName = @"良";
        model.color =HWColor(166, 206, 57);
        return model;
    }else if (rid == 4) {
        model.name = @"C";
        model.chineseName = @"中";
        model.color = HWColor(238, 232, 9);
        return model;
    }else if (rid == 5) {
        model.name = @"D";
        model.chineseName = @"差";
        model.color = HWColor(255, 194, 14);
        return model;
    }else if (rid == 6) {
        model.name = @"D-";
        model.chineseName = @"警示";
        model.color = HWColor(243, 112, 33);
        return model;
    } else
        return nil;
}
@end
