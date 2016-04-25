//
//  KLDialogActionView.m
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import "KLDialogActionView.h"
//#import "PPYUIToolkit.h"
#import "UIColor+PPYToolkit.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_BUTTON_HEIGHT 30.0f
#define DEFAULT_BUTTON_MIN_WIDTH 60.0f

#define DEFAULT_BUTTON_NEGATIVE_COLOR 0xff64c8c8
#define DEFAULT_BUTTON_POSITIVE_COLOR 0xfff57719
#define DEFAULT_BUTTON_NEUTRAL_COLOR DEFAULT_BUTTON_POSITIVE_COLOR


///---------------------------------------------------------------------------------------------------------------------
@interface KLDialogActionView () {
    NSMutableDictionary *_buttonDict;
}

@end



///---------------------------------------------------------------------------------------------------------------------
@implementation KLDialogActionView

@synthesize buttonDict = _buttonDict;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _buttonDict = [[NSMutableDictionary alloc] initWithCapacity:KLDialogButton_MAX];
        _buttonMinWidth = DEFAULT_BUTTON_MIN_WIDTH;
        
        for (int i = 0; i < KLDialogButton_MAX; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self configAndRecordButton:button type:i];
            [self addSubview:button];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    CGFloat margin = _customButtonMargin>0?_customButtonMargin:10;
    NSMutableArray *visibleButtons = [NSMutableArray array];
    
    for (UIButton *button in _buttonDict.allValues) {
        if ([button titleForState:UIControlStateNormal].length > 0) {
            button.hidden = NO;
            [visibleButtons addObject:button];
        }
        else {
            button.hidden = YES;
        }
    }
	
    UIButton *lastBtn = nil;
    CGRect ur = CGRectZero;
    for (UIButton *button in visibleButtons) {
        button.width = MAX([button.titleLabel.text sizeWithFont:button.titleLabel.font].width + DEFAULT_BUTTON_HEIGHT, _buttonMinWidth);
        button.height = rect.size.height;
        button.left = lastBtn != nil ? (lastBtn.right + margin) : 0;
        ur = CGRectUnion(ur, button.frame);
        lastBtn = button;
    }
    CGFloat ox = CGRectGetMidX(rect) - CGRectGetMidX(ur);
    for (UIButton *button in visibleButtons) {
        button.left += ox;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    int count = 0;
    for (UIButton *button in _buttonDict.allValues) {
        if ([button titleForState:UIControlStateNormal].length > 0) {
            count++;
        }
    }
    
    if (count > 0)
        return CGSizeMake(size.width, DEFAULT_BUTTON_HEIGHT);
    else
        return CGSizeMake(size.width, 0);
}

- (void)configAndRecordButton:(UIButton *)button type:(KLDialogButton)type {
    button.layer.cornerRadius = DEFAULT_BUTTON_HEIGHT * 0.5f;
    UIColor *color = nil;
    switch (type) {
        case KLDialogButton_Positive:
            color = [UIColor colorWithARGB:DEFAULT_BUTTON_POSITIVE_COLOR];
            break;
        case KLDialogButton_Negative:
            color = [UIColor colorWithARGB:DEFAULT_BUTTON_NEGATIVE_COLOR];
            break;
        case KLDialogButton_Neutral:
            color = [UIColor colorWithARGB:DEFAULT_BUTTON_NEUTRAL_COLOR];
            break;
            
        default:
            color = [UIColor whiteColor];
            break;
    }
    button.backgroundColor = color;
    button.tag = type;
    button.hidden = YES;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _buttonDict[[NSNumber numberWithInt:type]] = button;
}

- (void)buttonClicked:(id)sender {
    if (_delegate)
        [_delegate dialogActionView:self tappedButton:[sender tag]];
}

- (void)setButtonTitle:(NSString *)title which:(KLDialogButton)which {
    UIButton *button = _buttonDict[[NSNumber numberWithInt:which]];
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)setButtonColor:(UIColor *)color which:(KLDialogButton)which {
    UIButton *button = _buttonDict[[NSNumber numberWithInt:which]];
    button.backgroundColor = color;
}

- (void)setButtonImage:(UIImage *)image which:(KLDialogButton)which {
    UIButton *button = _buttonDict[[NSNumber numberWithInt:which]];
    [button setImage:image forState:UIControlStateNormal];
}

- (void)resetButtons {
    for (UIButton *button in _buttonDict.allValues) {
        [button setTitle:nil forState:UIControlStateNormal];
    }
}

@end
