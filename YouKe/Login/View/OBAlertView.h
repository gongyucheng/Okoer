//
//  OBAlertView.h
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OBAlertView;
@protocol OBAlertViewDelegate <NSObject>

@optional
- (void)alertView:(OBAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface OBAlertView : UIView
- (OBAlertView *)initAlertViewWithTitle:(NSString *)titleString delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButton otherButtonTitle:(NSString *)otherButton;
/** title文字的颜色 */
@property (nonatomic, retain) UIColor *titleColor;
/** 确认按钮的颜色 */
@property (nonatomic, retain) UIColor *otherButtonColor;
/** 确认按钮的背景颜色 */
@property (nonatomic, retain) UIColor *otherButtonBackgroundColor;
/** 取消按钮的颜色 */
@property (nonatomic, retain) UIColor *cancelButtonColor;
/** 取消按钮的背景颜色 */
@property (nonatomic, retain) UIColor *cancelButtonBackgroundColor;

@property(nonatomic,assign)id<OBAlertViewDelegate> alertViewDelegate;
- (void)show;
@end
