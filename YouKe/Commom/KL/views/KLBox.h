//
//  KLBox.h
//  SuperCal
//
//  Created by Lu Ming on 13-9-9.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLBox <NSObject>

@property (nonatomic, assign) CGFloat margin;

@end



@interface KLVBox : UIView <KLBox>

@property (nonatomic, assign) CGFloat margin;

@end



@interface KLHBox : UIView <KLBox>

@property (nonatomic, assign) CGFloat margin;

@end
