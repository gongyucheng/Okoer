//
//  OBRankTool.h
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OBRankModel;
@interface OBRankTool : NSObject
+ (OBRankModel *)rankModelWithRankId:(NSInteger)rid;
@end
