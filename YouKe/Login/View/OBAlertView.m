//
//  OBAlertView.m
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBAlertView.h"

@interface OBAlertView ()
@property (nonatomic, strong) OBAlertView *alertView;
@property (nonatomic, strong) UIButton *cButton;
@end
@implementation OBAlertView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    }
    
    return self;
    
}
- (OBAlertView *)initAlertViewWithTitle:(NSString *)titleString delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButton otherButtonTitle:(NSString *)otherButton
{
    
    if (titleString == nil) {
        titleString = @"";
    }
    if (cancelButton == nil) {
        titleString = @"";
    }
    if (cancelButton == nil) {
        titleString = @"";
    }
    CGFloat leftEdge = KViewWidth(10);
    self =  [self initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    OBAlertView *totalView = [[OBAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    self.alertView = totalView;
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(250))/2, (kScreenHeight - KViewHeight(100))/2, KViewWidth(250), KViewHeight(100))];
    [self addSubview:alertView];
    CGSize maxSize = CGSizeMake(self.width, MAXFLOAT);
//    alertView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(leftEdge, KViewHeight(20), alertView.width - 2*KViewWidth(10), KViewHeight(50))];
    label.textAlignment = NSTextAlignmentCenter;
    if (self.titleColor) {
        label.textColor = self.titleColor;
    } else
        self.titleColor = OBGrayColor;
    label.textColor = self.titleColor;
    label.text = titleString;
    label.font = [UIFont systemFontOfSize:KFont(15.0)];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = label.font;
    CGSize size = [label.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attrs context:nil].size;
    label.height = size.height + KViewHeight(20);
    label.numberOfLines = 0;
    [alertView addSubview:label];
    
    UIButton *cancelBu = [[UIButton alloc]initWithFrame:CGRectMake(leftEdge, label.bottom + KViewHeight(10), (alertView.width - 3* leftEdge)/2, KViewHeight(35))];
    [cancelBu setTitle:cancelButton forState:UIControlStateNormal];
    self.cButton = cancelBu;
    if (!self.cancelButtonColor) {
       self.cancelButtonColor = [UIColor whiteColor];
    }
    if (!self.cancelButtonBackgroundColor) {
        self.cancelButtonBackgroundColor = OBGrayColor;
    }
    [cancelBu setTitleColor:self.cancelButtonColor forState:UIControlStateNormal];
    cancelBu.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    cancelBu.backgroundColor = self.cancelButtonBackgroundColor;
    cancelBu.layer.cornerRadius = 2;
    cancelBu.layer.masksToBounds = YES;
    [cancelBu addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelBu];
    
//    [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(cancelBu.right + leftEdge, cancelBu.top, cancelBu.width, cancelBu.height)];
    [sureButton setTitle:otherButton forState:UIControlStateNormal];
    if (!self.otherButtonColor) {
        self.otherButtonColor = [UIColor whiteColor];
    }
    if (!self.otherButtonBackgroundColor) {
        self.otherButtonBackgroundColor = HWColor(227, 76, 87);
    }
    [sureButton setTitleColor:self.otherButtonColor forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    sureButton.backgroundColor = self.otherButtonBackgroundColor;
    sureButton.layer.cornerRadius = 2;
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:sureButton];
    alertView.height = sureButton.bottom + KViewHeight(20);
    //设置阴影
    alertView.layer.cornerRadius = 2;
    alertView.layer.shadowColor = [UIColor grayColor].CGColor;
    alertView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    //    alertView.layer.borderColor = [UIColor grayColor].CGColor;
    //    alertView.layer.borderWidth = 1;
    alertView.layer.shadowOpacity = 1;//阴影透明度，默认0
    alertView.layer.shadowRadius = 3;//阴影半径，默认3
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = alertView.bounds.size.width;
    float height = alertView.bounds.size.height;
    float x = alertView.bounds.origin.x;
    float y = alertView.bounds.origin.y;
    float addWH = KViewWidth(8);
    
    CGPoint topLeft      = alertView.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    alertView.layer.shadowPath = path.CGPath;
    
    alertView.backgroundColor = [UIColor whiteColor];
//    self.alertView = alertView;
    self.alertViewDelegate = delegate;
    return self;
}
- (void)show
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    [lastWindow addSubview:self];
}
- (void)cancelButton:(UIButton *)button
{
    if (self.alertViewDelegate && [self.alertViewDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.alertViewDelegate alertView:self clickedButtonAtIndex:0];
        [self removeFromSuperview];
    }
}
- (void)sureButton:(UIButton *)button
{
    if (self.alertViewDelegate && [self.alertViewDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.alertViewDelegate alertView:self clickedButtonAtIndex:1];
        [self removeFromSuperview];
    }
}
@end
