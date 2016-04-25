//
//  OBProfileModel.h
//  YouKe
//
//  Created by obally on 15/9/4.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBProfileModel : NSObject
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *brief;
@property(nonatomic,copy)NSString *cityid;
@property(nonatomic,copy)NSString *countryid;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *okoerpage;
@property(nonatomic,copy)NSString *originalicon;
@property(nonatomic,copy)NSString *page;
@property(nonatomic,copy)NSString *phonenumber;
@property(nonatomic,copy)NSString *provinceid;
@property(nonatomic,assign)NSInteger uid;
@property(nonatomic,assign)NSInteger gender;
@end
