//
//  OBPhoto.m
//  OBNewCar
//
//  Created by Obally on 14-10-26.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import "OBPhoto.h"

@implementation OBPhoto
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView
{
    _srcImageView = srcImageView;
    _placeholder = srcImageView.image;
    if (srcImageView.clipsToBounds) {
        _capture = [self capture:srcImageView];
    }
}

@end
