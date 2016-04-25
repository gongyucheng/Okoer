//
//  OBBaseViewController.m
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBBaseViewController.h"


@interface OBBaseViewController ()<UIGestureRecognizerDelegate>
{
//    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@end

@implementation OBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //侧滑
//    [self setupSlideButton];w

    
}



/**
 *  侧滑按钮
// */
//- (void)setupSlideButton
//{
//    
//    //侧滑按钮
//    UIImageView *slideImage = [[UIImageView alloc]initWithFrame:CGRectMake(KbuttonEdgeWidth, kScreenHeight - KbuttonEdgeWidth - KbuttonWidth, KbuttonWidth, KbuttonWidth)];
//    slideImage.userInteractionEnabled = YES;
//    slideImage.image = [UIImage imageNamed:@"icon_0003_Menu48"];
//    UITapGestureRecognizer *slideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideTapped)];
//    slideTap.delegate = self;
//    [slideImage addGestureRecognizer:slideTap];
//    
//    slideImage.layer.cornerRadius = slideImage.height/2;
//    slideImage.backgroundColor = [UIColor grayColor];
//    slideImage.alpha = 0.7;
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    [window addSubview:slideImage];
//    self.slideImage = slideImage;
//   
//   
//}
//
//- (void)slideTapped
//{
//
//    if (self.currentView.x == 0) {
//        _isSlide = YES;
//    } else
//        _isSlide = NO;
//    
//    if (_isSlide) {
//        [OBNotificationCenter postNotificationName:OBDidSlideNotification object:nil];
//       
//    }else
//        [OBNotificationCenter postNotificationName:OBDidDeSlideNotification object:nil];
//}
#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
