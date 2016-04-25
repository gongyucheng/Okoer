//
//  OBVisualEffectView.m
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBVisualEffectView.h"
#import "OBCommentViewController.h"
#import "OBStatisticModel.h"
#import "NSString+Hash.h"

@interface OBVisualEffectView ()
@property (nonatomic, retain) UILabel *likeCountlabel;
@property (nonatomic, retain) UILabel *commentcountlabel;
@property (nonatomic, retain) OBStatisticModel *statistModel;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) UIButton *likeButton;
@property (nonatomic, retain) UIButton *collectionButton;
@end
@implementation OBVisualEffectView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewsWithFrame:frame];
        
    }
    return self;
}
-(void)initViewsWithFrame:(CGRect)rect
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    visualEffect.frame = rect;
    visualEffect.alpha = 0.9;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 40, KViewHeight(50), KViewWidth(80), KViewHeight(30))];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"分享至";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:KFont(18)];
    [visualEffect addSubview:label];
    NSArray *imageArray = @[@[@"icon_0017_sina48",@"icon_0016_wechat48",@"icon_0015_F_Circle48"],@[@"icon_0012_qq48",@"icon_0013_qzone48",@"icon_0014_mail48"]];
    NSArray *labelArray = @[@[@"微博",@"微信好友",@"微信朋友圈"],@[@"QQ好友",@"QQ空间",@"邮箱"]];
    CGFloat buttonWidth = KViewWidth(48);
    CGFloat buttonEdge = KViewWidth(50);
    CGFloat leftEdge = (kScreenWidth - buttonWidth * 3 - buttonEdge * (3 - 1))/2;
    CGFloat topEdge = 120;
    for (int i = 0; i < imageArray.count; i ++) {
        NSArray *images = imageArray[i];
        NSArray *labels = labelArray[i];
        for (int j = 0; j < images.count; j ++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(leftEdge +j * (buttonWidth + buttonEdge), topEdge + i * (buttonWidth + KViewWidth(50)), buttonWidth, buttonWidth)];
//            button.layer.cornerRadius = buttonWidth/2;
            button.tag = (i * images.count) + j + 200;
            [button addTarget:self action:@selector(didSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
//            [button setTitle:array[i] forState: UIControlStateNormal];
            button.titleLabel.textColor = HWColor(153, 153, 153);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setBackgroundImage:[UIImage imageNamed:images[j]] forState:UIControlStateNormal];
            UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(button.left - 15, button.bottom + 2, button.width + KViewWidth(30),KViewHeight(30))];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.text = labels[j];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:KFont(13)];
            [visualEffect addSubview:button];
            [visualEffect addSubview:label];
        }
        
    }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(315), kScreenWidth - KViewWidth(20), 0.5)];
    line.alpha = 0.3;
    line.backgroundColor = HWColor(255, 255, 255);
    [visualEffect addSubview:line];
    
    //赞
    UIButton *likeButton = [[UIButton alloc]initWithFrame:CGRectMake(leftEdge, line.bottom + KViewHeight(30), buttonWidth, buttonWidth)];
//    likeButton.layer.cornerRadius = buttonWidth/2;
    [likeButton addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
    likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"icon_0018_Thumbsup48"] forState:UIControlStateNormal];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"icon_0010_Thumbsup36_red"] forState:UIControlStateSelected];
    self.likeButton = likeButton;
    UILabel *likeCountlabel= [[UILabel alloc]initWithFrame:CGRectMake(likeButton.centerX + KViewWidth(3), likeButton.top - KViewHeight(4), KViewWidth(40), KViewHeight(20))];
    likeCountlabel.textColor = [UIColor whiteColor];
    likeCountlabel.layer.cornerRadius = likeCountlabel.height/2;
    likeCountlabel.layer.masksToBounds = YES;
    likeCountlabel.text = @"0";
    likeCountlabel.backgroundColor = HWColor(253, 171, 132);
    likeCountlabel.textAlignment = NSTextAlignmentCenter;
    likeCountlabel.font = [UIFont systemFontOfSize:KFont(12.0)];
    likeCountlabel.hidden = YES;
    self.likeCountlabel = likeCountlabel;
    UILabel *likelabel= [[UILabel alloc]initWithFrame:CGRectMake(likeButton.left - KViewWidth(15), likeButton.bottom + 2, likeButton.width + KViewWidth(30), KViewHeight(30))];
    likelabel.textColor = [UIColor whiteColor];
    likelabel.backgroundColor = [UIColor clearColor];
    likelabel.text = @"点赞";
    likelabel.textAlignment = NSTextAlignmentCenter;
    likelabel.font = [UIFont systemFontOfSize:KFont(13)];
    [visualEffect addSubview:likeButton];
    [visualEffect addSubview:likeCountlabel];
    [visualEffect addSubview:likelabel];
    //评论
    UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(likeButton.right + buttonEdge,  line.bottom + KViewHeight(30), buttonWidth, buttonWidth)];
    commentButton.layer.cornerRadius = buttonWidth/2;
    [commentButton addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"icon_0019_reply48"] forState:UIControlStateNormal];
    UILabel *commentcountlabel= [[UILabel alloc]initWithFrame:CGRectMake(commentButton.centerX + KViewWidth(3), commentButton.top - KViewHeight(4), KViewWidth(40), KViewHeight(20))];
    commentcountlabel.layer.cornerRadius = commentcountlabel.height/2;
    commentcountlabel.layer.masksToBounds = YES;
    commentcountlabel.textColor = [UIColor whiteColor];
    commentcountlabel.backgroundColor = HWColor(253, 171, 132);
    commentcountlabel.textAlignment = NSTextAlignmentCenter;
    commentcountlabel.font = [UIFont systemFontOfSize:KFont(12)];
    commentcountlabel.text = @"0";
    commentcountlabel.hidden = YES;
    self.commentcountlabel = commentcountlabel;
    UILabel *commentlabel= [[UILabel alloc]initWithFrame:CGRectMake(commentButton.left - KViewWidth(15), commentButton.bottom + 2, commentButton.width + KViewWidth(30), KViewWidth(30))];
    commentlabel.textColor = [UIColor whiteColor];
    commentlabel.backgroundColor = [UIColor clearColor];
    commentlabel.text = @"评论";
    commentlabel.textAlignment = NSTextAlignmentCenter;
    commentlabel.font = [UIFont systemFontOfSize:KFont(13)];
    [visualEffect addSubview:commentButton];
    [visualEffect addSubview:commentcountlabel];    
    [visualEffect addSubview:commentlabel];
    //收藏
    UIButton *collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(commentButton.right + buttonEdge, line.bottom + KViewHeight(30), buttonWidth, buttonWidth)];
    self.collectionButton = collectionButton;
    collectionButton.layer.cornerRadius = buttonWidth/2;
    [collectionButton addTarget:self action:@selector(collectionButton:) forControlEvents:UIControlEventTouchUpInside];
    collectionButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14)];
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"icon_0020_favorites48"] forState:UIControlStateNormal];
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"icon_0010_favorites48_ye"] forState:UIControlStateSelected];
    UILabel *collectionlabel= [[UILabel alloc]initWithFrame:CGRectMake(collectionButton.left - KViewWidth(15), collectionButton.bottom + 2, collectionButton.width + KViewWidth(30), KViewHeight(30))];
    collectionlabel.textColor = [UIColor whiteColor];
    collectionlabel.backgroundColor = [UIColor clearColor];
    collectionlabel.text = @"收藏";
    collectionlabel.textAlignment = NSTextAlignmentCenter;
    collectionlabel.font = [UIFont systemFontOfSize:KFont(13)];
    [visualEffect addSubview:collectionlabel];
    [visualEffect addSubview:collectionButton];
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [visualEffect addGestureRecognizer:tap];
    [self addSubview:visualEffect];
//    return visualEffect;
}
- (void)loadData
{
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSArray *array = @[[NSNumber numberWithInteger:self.nid]];
    [params setObject:[NSNumber numberWithInteger:self.nid] forKey:@"nids"];
    [OBDataService requestWithURL:OBStatisticUrl params:params httpMethod:@"GET" completionblock:^(id result) {
        NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == 0) {
            NSArray *array = result[@"data"];
            if (array.count > 0) {
                OBStatisticModel *statistModel = [OBStatisticModel objectWithKeyValues:array[0]];
                self.statistModel = statistModel;
                
                if (statistModel.comment_count == 0) {
                    self.commentcountlabel.hidden = YES;
                }else if (statistModel.comment_count <= 99 && statistModel.comment_count != 0) {
                    self.commentcountlabel.hidden = NO;
                    self.commentcountlabel.text = [NSString stringWithFormat:@"%ld",statistModel.comment_count];
                }else {
                    self.commentcountlabel.hidden = NO;
                    self.commentcountlabel.text = @"99+";
                }
                CGSize commentlabelSize = [self.commentcountlabel.text sizeWithFont:[UIFont systemFontOfSize:KFont(12.0)]];
                self.commentcountlabel.width = commentlabelSize.width + KViewWidth(10);
                if (statistModel.like_count == 0) {
                    self.likeCountlabel.hidden = YES;
                }else if (statistModel.like_count <= 99 && statistModel.like_count != 0) {
                    self.likeCountlabel.hidden = NO;
                    self.likeCountlabel.text = [NSString stringWithFormat:@"%ld",statistModel.like_count];
                }else {
                    self.likeCountlabel.hidden = NO;
                    self.likeCountlabel.text = @"99+";
                }
                CGSize likelabelSize = [self.likeCountlabel.text sizeWithFont:[UIFont systemFontOfSize:KFont(12.0)]];
                self.likeCountlabel.width = likelabelSize.width + KViewWidth(10);
            }
           
        }
    } failedBlock:^(id error) {
        
    }];
}

- (void)loadStatus
{
    if ([OBAccountTool account]) {
        NSString *token = nil;
        NSString *uid = nil;
        if ([OBAccountTool account]) {
            OBAccount *model = [OBAccountTool account];
            token = model.token;
            uid = model.uid;
        }
        NSDate *date = [NSDate date];
        NSTimeInterval timeInterval =[date timeIntervalSince1970] ;
        NSString *timeString = [NSString stringWithFormat:@"%d",(int)timeInterval];
        if (self.currentTimeOffset) {
            NSInteger timeoffset = [self.currentTimeOffset intValue];
            NSInteger current = timeInterval + timeoffset;
            timeString = [NSString stringWithFormat:@"%ld",current];
        }
        NSString *sign = [[NSString stringWithFormat:@"%@%@%@",uid,timeString,token]md5String];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //    NSArray *array = @[[NSNumber numberWithInteger:self.nid]];
        [params setObject:[NSNumber numberWithInteger:self.nid] forKey:@"nids"];
        [OBDataService requestWithURL:OBStatusUrl(uid, timeString, sign) params:params httpMethod:@"GET" completionblock:^(id result) {
            
            NSNumber *code = result[@"ret_code"];
            NSString *message = result[@"err_msg"];
            if ([code integerValue] == 0) {
                NSDictionary *dic;
                if ([result[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *array = result[@"data"];
                    if (array.count > 0) {
                        dic = array[0];
                    }
                } else if ([result[@"data"] isKindOfClass:[NSDictionary class]]){
                    dic = result[@"data"];
                }
                BOOL like = [dic[@"likes"] boolValue];
                BOOL collection = [dic[@"collections"] boolValue];
                if (like) {
                    self.likeButton.selected = YES;
                }
                if (collection) {
                    self.collectionButton.selected = YES;
                }
                
            }else if ([code integerValue] == -18) {
                message = result[@"result"];
                [MBProgressHUD showAlert:message];
            } else if ([code integerValue] == - 9){
                NSDictionary *resultDic = result[@"result"];
                NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                self.currentTimeOffset = timestamp_offset;
                [self loadStatus];
            }else if ([code integerValue] == - 8) {
                //token 过期
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadStatus)];
            }else if ([code integerValue] == - 24) {
                //签名错误
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadStatus)];
            }
            
        } failedBlock:^(id error) {
            [MBProgressHUD showAlert:error];
        }];

    }
   
}

- (void)didSelectedButton:(UIButton *)button
{
    [self removeFromSuperview];
    if (self.visualDelegate && [self.visualDelegate respondsToSelector:@selector(didSelectedShareButtonWithSelectedShareType:)]) {
        [self.visualDelegate didSelectedShareButtonWithSelectedShareType:(button.tag - 200)];
    }

}
- (void)likeButton:(UIButton *)likeButton
{
    
    if ([OBManager sessionManager].status == OBSessionStatusLogin) {
        likeButton.selected = !likeButton.selected;
    } else
        [self removeFromSuperview];
    
    if (self.visualDelegate && [self.visualDelegate respondsToSelector:@selector(didSelectedLoveButtonWithSelected:)] && likeButton.selected) {
        NSInteger count = _statistModel.like_count + 1;
        if (count == 0) {
            self.likeCountlabel.hidden = YES;
        }else if (count <= 99) {
            self.likeCountlabel.hidden = NO;
            self.likeCountlabel.text = [NSString stringWithFormat:@"%ld",count];
        }else {
            self.likeCountlabel.hidden = NO;
            self.likeCountlabel.text = @"99+";
        }
        CGSize likelabelSize = [self.likeCountlabel.text sizeWithFont:[UIFont systemFontOfSize:KFont(12.0)]];
        self.likeCountlabel.width = likelabelSize.width + KViewWidth(10);
        [self.visualDelegate didSelectedLoveButtonWithSelected:YES];
    } else if (self.visualDelegate && [self.visualDelegate respondsToSelector:@selector(didSelectedLoveButtonWithSelected:)] && !likeButton.selected) {
        NSInteger count = _statistModel.like_count;
        if (count == 0) {
            self.likeCountlabel.hidden = YES;
        }else if (count <= 99 && count != 0) {
            self.likeCountlabel.hidden = NO;
            self.likeCountlabel.text = [NSString stringWithFormat:@"%ld",count];
        }else {
            self.likeCountlabel.hidden = NO;
            self.likeCountlabel.text = @"99+";
        }
        CGSize likelabelSize = [self.likeCountlabel.text sizeWithFont:[UIFont systemFontOfSize:KFont(12.0)]];
        self.likeCountlabel.width = likelabelSize.width + KViewWidth(10);
        [self.visualDelegate didSelectedLoveButtonWithSelected:NO];
    }
}
- (void)commentButton:(UIButton *)button
{
    [self removeFromSuperview];
    
    if (self.visualDelegate && [self.visualDelegate respondsToSelector:@selector(didSelectedCommentButton)]) {
        [self.visualDelegate didSelectedCommentButton];
    }
}
- (void)collectionButton:(UIButton *)collectionButton
{
    
    if ([OBManager sessionManager].status == OBSessionStatusLogin) {
        collectionButton.selected = !collectionButton.selected;
    } else
        [self removeFromSuperview];
    if (self.visualDelegate && [self.visualDelegate respondsToSelector:@selector(didSelectedCollectionButtonWithSelected:)] && collectionButton.selected) {
        [self.visualDelegate didSelectedCollectionButtonWithSelected:YES];
    } else if (self.visualDelegate && [self.visualDelegate respondsToSelector:@selector(didSelectedCollectionButtonWithSelected:)] && !collectionButton.selected) {
        [self.visualDelegate didSelectedCollectionButtonWithSelected:NO];
    }

}
- (void)tapAction
{
    [self removeFromSuperview];
}

//赞
- (void)setLikeCount:(NSInteger)likeCount
{
   
    if (_likeCount!= likeCount) {
        _likeCount = likeCount;
    }
    if (_likeCount == 0) {
        self.likeCountlabel.hidden = YES;
    }else if (_likeCount <= 99 && _likeCount != 0) {
        self.likeCountlabel.hidden = NO;
        self.likeCountlabel.text = [NSString stringWithFormat:@"%ld",_likeCount];
    }else {
        self.likeCountlabel.hidden = NO;
        self.likeCountlabel.text = @"99+";
    }
    CGSize likelabelSize = [self.likeCountlabel.text sizeWithFont:[UIFont systemFontOfSize:KFont(12.0)]];
    self.likeCountlabel.width = likelabelSize.width + KViewWidth(10);
}
- (void)setNid:(NSInteger)nid
{
    if (_nid != nid) {
        _nid = nid;
        [self loadData];
        [self loadStatus];
    }
}
- (void)setIsKePing:(BOOL)isKePing
{
    _isKePing = isKePing;
    if (_isKePing) {
        self.likeCountlabel.backgroundColor = HWColor(31, 167, 86);
        self.commentcountlabel.backgroundColor = HWColor(31, 167, 86);
    } else {
        self.likeCountlabel.backgroundColor = HWColor(254, 172, 132);
        self.commentcountlabel.backgroundColor = HWColor(254, 172, 132);
    }
}
@end
