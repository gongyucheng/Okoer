//
//  KLDialog.h
//  SuperCal
//
//  Created by Lu Ming on 13-5-22.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import "KLOverlayView.h"
#import "KLDialogTitleView.h"
#import "KLDialogMessageView.h"
#import "KLDialogActionView.h"

@class KLDialog;

@protocol KLDialogDelegate <NSObject>
- (void)dialog:(KLDialog *)dialog tappedButton:(KLDialogButton)which;
- (void)dialog:(KLDialog *)dialog tappedClose:(id)sender;
@end



///---------------------------------------------------------------------------------------------------------------------
@interface KLDialog : KLOverlayView

+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)msg buttonTitle:(NSString *)btnTitle; // quick show dialog with simple msg

@property (nonatomic, assign) CGFloat contentTop;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, strong) KLDialogTitleView *titleView;
@property (nonatomic, strong) KLDialogMessageView *messageView;
@property (nonatomic, strong) KLDialogActionView *actionView;
@property (nonatomic, weak) id<KLDialogDelegate> delegate;
@property (nonatomic, copy) void (^delegateBlock)(KLDialog *dialog, KLDialogButton button); // in conflict with delegate, when delegate exist, delegateBlock will not be call

- (void)overlayDialogAddSubviews; // just used by subclass to reorder subviews's sequence


///---------------------------------------------------------------------------------------------------------------------
/// property for close
@property (nonatomic, assign) BOOL autoDismissOnDimArea;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) BOOL closeButtonHidden;
@property (nonatomic, assign) CGPoint closeOffset;
@property (nonatomic, copy) void (^closeBlock)(KLDialog *dialog, id sender); // sender is dialog self when tap dim area, sender is the close button when click close button; closeBlock is also conflict with delegate, when delegate exist, closeBlock will not be call


///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for titleView
@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, assign) CGSize logoSize;

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) UITextAlignment titleAlignment;
@property (nonatomic, assign) UILineBreakMode titleLineBreakMode;
@property (nonatomic, assign) NSInteger titleNumberOfLines;



///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for messageView
@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, assign) UITextAlignment messageAlignment;
@property (nonatomic, assign) UILineBreakMode messageLineBreakMode;
@property (nonatomic, assign) NSInteger messageNumberOfLines;
@property (nonatomic, strong) UIView *messageCustomView;


///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for actionView
@property (nonatomic, assign) CGFloat buttonMinWidth;
@property (nonatomic, assign) CGFloat buttonMargin;
- (void)setButtonTitle:(NSString *)title which:(KLDialogButton)which;
- (void)setButtonColor:(UIColor *)color which:(KLDialogButton)which;
- (void)setButtonImage:(UIImage *)image which:(KLDialogButton)which;
- (void)resetButtons;


@end
