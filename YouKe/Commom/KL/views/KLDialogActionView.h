//
//  KLDialogActionView.h
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLDialogActionView;

typedef enum {
	KLDialogButton_Negative = 0,
	KLDialogButton_Neutral,
	KLDialogButton_Positive,
	KLDialogButton_MAX
} KLDialogButton;

@protocol KLDialogActionViewDelegate <NSObject>
- (void)dialogActionView:(KLDialogActionView *)actionView tappedButton:(KLDialogButton)which;
@end



///---------------------------------------------------------------------------------------------------------------------
@interface KLDialogActionView : UIView

@property (nonatomic, readonly) NSDictionary *buttonDict;
@property (nonatomic, assign) CGFloat buttonMinWidth;
@property (nonatomic, weak) id<KLDialogActionViewDelegate> delegate;
@property (nonatomic, assign) CGFloat customButtonMargin;
- (void)setButtonTitle:(NSString *)title which:(KLDialogButton)which;
- (void)setButtonColor:(UIColor *)color which:(KLDialogButton)which;
- (void)setButtonImage:(UIImage *)image which:(KLDialogButton)which;
- (void)resetButtons;


@end
