//
//  KLDialog.m
//  SuperCal
//
//  Created by Lu Ming on 13-5-22.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import "KLDialog.h"
//#import "PPYUIToolkit.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_CLOSE_BUTTON_SIZE       18
#define DEFAULT_CONTENT_INSETS_TOP      10
#define DEFAULT_CONTENT_INSETS_LEFT     10
#define DEFAULT_CONTENT_INSETS_BOTTOM   10
#define DEFAULT_CONTENT_INSETS_RIGHT    10


///---------------------------------------------------------------------------------------------------------------------
@interface KLDialog () <KLDialogActionViewDelegate>

@end



///---------------------------------------------------------------------------------------------------------------------
@implementation KLDialog

@dynamic closeButtonHidden;
@dynamic buttonMargin;

///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for titleView
@dynamic logoImage;
@dynamic logoSize;
@dynamic titleText;
@dynamic titleFont;
@dynamic titleColor;
@dynamic titleAlignment;
@dynamic titleLineBreakMode;
@dynamic titleNumberOfLines;
///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for messageView
@dynamic messageText;
@dynamic messageFont;
@dynamic messageColor;
@dynamic messageAlignment;

@dynamic messageLineBreakMode;
@dynamic messageNumberOfLines;
@dynamic messageCustomView;


///---------------------------------------------------------------------------------------------------------------------
/// class method
+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)msg buttonTitle:(NSString *)btnTitle {
    dispatch_async(dispatch_get_main_queue(), ^{
        KLDialog *dialog = [[KLDialog alloc] init];
        dialog.titleText = title;
        dialog.messageText = msg;
        
        if (btnTitle.length > 0)
            [dialog setButtonTitle:btnTitle which:KLDialogButton_Negative];
        
        [dialog setDelegateBlock:^(KLDialog *dialog, KLDialogButton button) {
            [dialog dismissAnimated:YES];
        }];
        [dialog showAnimated:YES];
    });
}


///---------------------------------------------------------------------------------------------------------------------
/// instance method
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        { // default propert
            self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
            _autoDismissOnDimArea = YES;
            _contentInsets = UIEdgeInsetsMake(DEFAULT_CONTENT_INSETS_TOP, DEFAULT_CONTENT_INSETS_LEFT, DEFAULT_CONTENT_INSETS_BOTTOM, DEFAULT_CONTENT_INSETS_RIGHT);
            _cornerRadius = 2;
            _shadowOpacity = 1;
            _shadowOffset = CGSizeMake(0, 0);
            _shadowRadius = 2;
            _closeOffset = CGPointMake(-3, 3);
        }
        
        { // content subviews
            _titleView = [[KLDialogTitleView alloc] init];
            
            _messageView = [[KLDialogMessageView alloc] init];
            
            _actionView = [[KLDialogActionView alloc] init];
            _actionView.delegate = self;
        }
        
        { // self subviews
            _contentView = [[UIView alloc] init];
            _contentView.backgroundColor = [UIColor whiteColor];
            
            _closeButton = [[UIButton alloc] init];
            _closeButton.backgroundColor = [UIColor whiteColor];
            _closeButton.layer.cornerRadius = DEFAULT_CLOSE_BUTTON_SIZE * 0.5;
            [_closeButton setImage:[UIImage imageNamed:@"ppy_icon_close.png"] forState:UIControlStateNormal];
            [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self overlayDialogAddSubviews];
        
    }
    return self;
}

- (void)overlayDialogAddSubviews {
    [_contentView addSubview:_titleView];
    [_contentView addSubview:_messageView];
    [_contentView addSubview:_actionView];
    
    [self addSubview:_contentView];
    [self addSubview:_closeButton];
}

- (void)overlayViewWillAppear:(BOOL)animated {
    [super overlayViewWillAppear:animated];
    CGRect rect = self.bounds;
    CGFloat margin = 10;
    _contentView.frame = rect;
    
    _contentView.width = rect.size.width * 15 / 16;
    _contentView.centerX = CGRectGetMidX(rect);
    
    CGRect bounds = UIEdgeInsetsInsetRect(_contentView.bounds, _contentInsets);//CGRectInset(_contentView.bounds, margin, margin);
    
    _titleView.frame = bounds;
    [_titleView sizeToFit];
    
    _messageView.size = CGSizeMake(bounds.size.width, rect.size.height - _titleView.height);
    [_messageView sizeToFit];
    _messageView.top = _titleView.bottom + margin;
    _messageView.left = _titleView.left;
    
    _actionView.size = CGSizeMake(bounds.size.width, rect.size.height - _titleView.height - _messageView.height);
    [_actionView sizeToFit];
    _actionView.top = _messageView.bottom + margin;
    _actionView.left = _messageView.left;
    
    _contentView.height = _actionView.bottom + margin;
    if(_contentTop<=0)
        _contentView.centerY = CGRectGetMidY(rect);
    else
        _contentView.top = _contentTop;
    
    {// shadow and cornerRadius
        _contentView.layer.cornerRadius = _cornerRadius;
        
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentView.layer.shadowOpacity = _shadowOpacity;
        _contentView.layer.shadowOffset = _shadowOffset;
        _contentView.layer.shadowRadius = _shadowRadius;
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds cornerRadius:_cornerRadius];
        _contentView.layer.shadowPath = shadowPath.CGPath;
    }
    
    _closeButton.size = CGSizeMake(DEFAULT_CLOSE_BUTTON_SIZE, DEFAULT_CLOSE_BUTTON_SIZE);
    _closeButton.centerX = self.contentView.right + _closeOffset.x;
    _closeButton.centerY = self.contentView.top + _closeOffset.y;
}

- (void)setTitleView:(KLDialogTitleView *)titleView {
    [_contentView insertSubview:titleView aboveSubview:_titleView];
    [_titleView removeFromSuperview];
    _titleView = titleView;
}

- (void)setMessageView:(KLDialogMessageView *)messageView {
    [_contentView insertSubview:messageView aboveSubview:_messageView];
    [_messageView removeFromSuperview];
    _messageView = messageView;
}

- (void)setActionView:(KLDialogActionView *)actionView {
    [_contentView insertSubview:actionView aboveSubview:_actionView];
    [_actionView removeFromSuperview];
    _actionView = actionView;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, point)) {
        if (!CGRectContainsPoint(_contentView.frame, point) && _autoDismissOnDimArea) {
            [self dismissAnimated:YES];
            if (_delegate)
                [_delegate dialog:self tappedClose:self];
            else if (_closeBlock)
                _closeBlock(self, self);
        }
    }
}

- (void)closeButtonClicked {
    [self dismissAnimated:YES];
    if (_delegate)
        [_delegate dialog:self tappedClose:self];
    else if (_closeBlock)
        _closeBlock(self, _closeButton);
}


///---------------------------------------------------------------------------------------------------------------------
/// @dynamic
- (BOOL)closeButtonHidden {    return _closeButton.hidden;}
- (void)setCloseButtonHidden:(BOOL)closeButtonHidden {    _closeButton.hidden = closeButtonHidden;}


///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for titleView
- (UIImage *)logoImage {    return [_titleView logoImage];}
- (void)setLogoImage:(UIImage *)logoImage {    [_titleView setLogoImage:logoImage];}

- (CGSize)logoSize {    return [_titleView logoSize];}
- (void)setLogoSize:(CGSize)logoSize {    [_titleView setLogoSize:logoSize];}

- (NSString *)titleText {    return [_titleView titleText];}
- (void)setTitleText:(NSString *)titleText {    [_titleView setTitleText:titleText]; [_titleView setNeedsDisplay];}

- (UIFont *)titleFont {    return [_titleView titleFont];}
- (void)setTitleFont:(UIFont *)titleFont {    [_titleView setTitleFont:titleFont];}

- (UIColor *)titleColor {    return [_titleView titleColor];}
- (void)setTitleColor:(UIColor *)titleColor {    [_titleView setTitleColor:titleColor];}

- (UITextAlignment)titleAlignment {    return [_titleView titleAlignment];}
- (void)setTitleAlignment:(UITextAlignment)titleAlignment {    [_titleView setTitleAlignment:titleAlignment];}

- (UILineBreakMode)titleLineBreakMode {    return [_titleView titleLineBreakMode];}
- (void)setTitleLineBreakMode:(UILineBreakMode)titleLineBreakMode {    [_titleView setTitleLineBreakMode:titleLineBreakMode];}

- (NSInteger)titleNumberOfLines {    return [_titleView titleNumberOfLines];}
- (void)setTitleNumberOfLines:(NSInteger)titleNumberOfLines {    [_titleView setTitleNumberOfLines:titleNumberOfLines];}


///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for messageView
- (NSString *)messageText {    return _messageView.messageLabel.text;}
- (void)setMessageText:(NSString *)messageText {    _messageView.messageLabel.text = messageText;}

- (UIFont *)messageFont {    return _messageView.messageLabel.font;}
- (void)setMessageFont:(UIFont *)messageFont {    _messageView.messageLabel.font = messageFont;}

- (UIColor *)messageColor {    return _messageView.messageLabel.textColor;}
- (void)setMessageColor:(UIColor *)messageColor {    _messageView.messageLabel.textColor = messageColor;}

- (UITextAlignment)messageAlignment {    return _messageView.messageLabel.textAlignment;}
- (void)setMessageAlignment:(UITextAlignment)messageAlignment {    _messageView.messageLabel.textAlignment = messageAlignment;}

- (UILineBreakMode)messageLineBreakMode {    return _messageView.messageLabel.lineBreakMode;}
- (void)setMessageLineBreakMode:(UILineBreakMode)messageLineBreakMode {    _messageView.messageLabel.lineBreakMode = messageLineBreakMode;}

- (NSInteger)messageNumberOfLines {    return _messageView.messageLabel.numberOfLines;}
- (void)setMessageNumberOfLines:(NSInteger)messageNumberOfLines {    _messageView.messageLabel.numberOfLines = messageNumberOfLines;}

- (UIView *)messageCustomView {    return _messageView.customView;}
- (void)setMessageCustomView:(UIView *)messageCustomView {    _messageView.customView = messageCustomView;}


///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for actionView
- (CGFloat)buttonMinWidth {    return _actionView.buttonMinWidth;}
- (void)setButtonMinWidth:(CGFloat)buttonMinWidth {    _actionView.buttonMinWidth = buttonMinWidth;}

- (void)setButtonTitle:(NSString *)title which:(KLDialogButton)which {    [_actionView setButtonTitle:title which:which];}

- (void)setButtonColor:(UIColor *)color which:(KLDialogButton)which {    [_actionView setButtonColor:color which:which];}

- (void)setButtonImage:(UIImage *)image which:(KLDialogButton)which {    [_actionView setButtonImage:image which:which];}

- (void)resetButtons {    [_actionView resetButtons];}

- (CGFloat)buttonMargin{
    return _actionView.customButtonMargin;
}

- (void)setButtonMargin:(CGFloat)buttonMargin{
    _actionView.customButtonMargin = buttonMargin;
}

///---------------------------------------------------------------------------------------------------------------------
/// KLDialogActionViewDelegate
- (void)dialogActionView:(KLDialogActionView *)actionView tappedButton:(KLDialogButton)which {
    if (_delegate)
        [_delegate dialog:self tappedButton:which];
    else if (_delegateBlock)
        _delegateBlock(self, which);
}


@end
