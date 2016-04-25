//
//  OBTokenExpired.h
//  YouKe
//
//  Created by obally on 15/9/10.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBTokenExpired : NSObject
+ (void)tokenExPiredWithControllerTarget:(id)target WithSelector:(SEL)aSelector;
@end
