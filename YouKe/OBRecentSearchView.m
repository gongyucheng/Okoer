//
//  OBRecentSearchView.m
//  YouKe
//
//  Created by obally on 15/10/27.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import "OBRecentSearchView.h"
#define RHeight KViewHeight(50)
#import "OBRecentDataTool.h"

@implementation OBRecentSearchView

+ (instancetype)recentView
{
    return [[self alloc] init];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HWColor(238, 238, 238);
       
        
    }
    return self;
}

- (UIView *)rencentViewWithString:(NSString *)string withTag:(NSInteger)tag
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, RHeight)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(15), KViewHeight(15), KViewWidth(20), KViewHeight(20))];
    imageView.image = [UIImage imageNamed:@"app_0002_seaechtime20_9"];
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + KViewWidth(5), imageView.top, KViewWidth(250), KViewHeight(20))];
    label.text = string;
    label.textColor = HWColor(151, 151, 151);
    label.font = [UIFont systemFontOfSize:KFont(13.0)];
    label.centerX = view.centerX;
    [view addSubview:label];
    UIButton *deleButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(50), 0, KViewWidth(50), KViewWidth(50))];
    deleButton.tag = tag;
    [deleButton setImage:[UIImage imageNamed:@"app_0001_close20_9"] forState:UIControlStateNormal];
    [deleButton addTarget:self action:@selector(deleAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleButton];
//    deleButton.backgroundColor = [UIColor redColor];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.height- 0.5, kScreenWidth, 0.5)];
    lineLabel.backgroundColor = HWColor(232, 232, 232);
    lineLabel.alpha = 0.7;
    [view addSubview:lineLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapAction:)];
    [view addGestureRecognizer:tap];
    view.tag = tag;

    return view;
}

- (void)viewTapAction:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    if (self.recentSearchViewDelegate && [self.recentSearchViewDelegate respondsToSelector:@selector(recentSearchViewWithSelectedViewTag:)]) {
        [self.recentSearchViewDelegate recentSearchViewWithSelectedViewTag:tag - 100];
    }

}

- (void)setDataArrays:(NSMutableArray *)dataArrays
{
    _dataArrays = dataArrays;
    
    if (self.subviews.count > 1) {
        do {
            [self.subviews[0] removeFromSuperview];
        } while (self.subviews.count > 0);
    }
    if (_dataArrays.count >0 ) {
        self.backgroundColor = HWColor(238, 238, 238);
        
        UILabel *recentLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(15), KViewHeight(20), KViewWidth(100), KViewHeight(30))];
        recentLabel.text = @"搜索记录";
        [self addSubview:recentLabel];
        recentLabel.font = [UIFont systemFontOfSize:KFont(13.0)];
        CGFloat height = KViewHeight(60);
        for (int i= 0; i < dataArrays.count; i++) {
            if (i >= 5) {
                return;
            }
            height += RHeight;
            self.height = height;
            UIView *view = [self rencentViewWithString:_dataArrays[i] withTag:i + 100];
            view.bottom = self.height;
            [self addSubview:view];
        }
    }
    if (_dataArrays.count == 0) {
        self.backgroundColor = [UIColor whiteColor];
    }
}
- (void)deleAction:(UIButton *)button
{
    NSInteger i = button.tag - 100;
//    UIView *recentView = self.subviews[i + 1];
//    [recentView removeFromSuperview];
    [_dataArrays removeObjectAtIndex:i];
    self.dataArrays = _dataArrays;
    [OBRecentDataTool saveRecentData:self.dataArrays];
    
}
@end
