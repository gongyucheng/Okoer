//
//  OBBottomBackView.m
//  YouKe
//
//  Created by obally on 15/8/20.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBBottomBackView.h"
#import "OBStatisticModel.h"

@interface OBBottomBackView ()

@property (nonatomic, retain) UILabel *chatCountlabel;
@property (nonatomic, retain) UILabel *likeCountlabel;
@property (nonatomic, retain) UILabel *commentCountlabel;
@property (nonatomic, retain) UIButton *commentButton;
@property (nonatomic, retain) UIButton *likeCountButton;
@property (nonatomic, retain) UIButton *chatCountButton;
@property (nonatomic, retain) OBStatisticModel *statistModel;
@end

@implementation OBBottomBackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
        self.height = KViewHeight(50);
    }
    return self;
}
- (void)initViews
{
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KbuttonEdgeWidth, 1, KbuttonWidth, KbuttonWidth)];
    //    backButton.backgroundColor = HWRandomColor;
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_0001_Return48"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = backButton.width/2;
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    //聊天室
    UIButton *chatButton = [self createButtonWithFrame:CGRectMake(kScreenWidth - KViewHeight(168), KViewHeight(5), KViewWidth(36) , KViewHeight(36)) WithBackgroundImage:@"icon_0007_chatroom36"];
    //    chatButton.backgroundColor = HWRandomColor;
    [chatButton addTarget:self action:@selector(chatButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *chatCountlabel = [self createLabelWithFrame:CGRectMake(chatButton.centerX, chatButton.top - KViewHeight(4), KViewWidth(30), KViewHeight(20))];
    self.chatCountButton = chatButton;
    self.chatCountlabel = chatCountlabel;
    self.chatCountlabel.hidden = YES;
    self.chatCountButton.hidden = YES;
    
    //评论
    UIButton *commentButton = [self createButtonWithFrame:CGRectMake(chatButton.right + KViewWidth(20), KViewHeight(5), KViewWidth(36) , KViewHeight(36)) WithBackgroundImage:@"icon_0009_reply36"];
    [commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *commentCountlabel = [self createLabelWithFrame:CGRectMake(commentButton.centerX, commentButton.top - KViewHeight(4), KViewWidth(30), KViewHeight(20))];
    commentCountlabel.hidden = YES;
    self.commentCountlabel = commentCountlabel;
    
    //转发
    UIButton *shareButton =  [self createButtonWithFrame:CGRectMake(commentButton.right + KViewWidth(20), KViewHeight(5), KViewWidth(36) , KViewHeight(36)) WithBackgroundImage:@"icon_0000_more36"];
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIButton *)createButtonWithFrame:(CGRect)frame WithBackgroundImage:(NSString *)imageString
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
//    button.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:imageString]];
    [self addSubview:button];
    return button;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    //    label.m
    label.layer.cornerRadius = frame.size.height/2;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = HWColor(254, 172, 132);
    label.font = [UIFont systemFontOfSize:KFont(12.0)];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    return label;
}

#pragma mark - KPDelegate
- (void)backButtonAction
{
    if ([self.backbottomDelegate respondsToSelector:@selector(backViewdidSelectedBackbutton)]) {
        [self.backbottomDelegate backViewdidSelectedBackbutton];
    }
}

- (void)commentButtonAction
{
    if ([self.backbottomDelegate respondsToSelector:@selector(backViewdidSelectedCommentButton)]) {
        [self.backbottomDelegate backViewdidSelectedCommentButton];
    }
}

- (void)chatButtonAction
{
    if ([self.backbottomDelegate respondsToSelector:@selector(backViewdidSelectedChatButton)]) {
        [self.backbottomDelegate backViewdidSelectedChatButton];
    }}

- (void)shareButtonAction
{
    if ([self.backbottomDelegate respondsToSelector:@selector(backViewdidSelectedShareButton)]) {
        [self.backbottomDelegate backViewdidSelectedShareButton];
    }
    
}
- (void)setShowChat:(BOOL)showChat
{
    if (_showChat != showChat) {
        _showChat = showChat;
        if (_showChat) {
//            self.chatCountlabel.hidden = NO;
            self.chatCountButton.hidden = NO;
            self.chatCountlabel.backgroundColor = HWColor(31, 167, 86);
            self.commentCountlabel.backgroundColor = HWColor(31, 167, 86);
        } else {
//            self.chatCountlabel.hidden = YES;
            self.chatCountButton.hidden = YES;
            self.commentCountlabel.backgroundColor = HWColor(254, 172, 132);
        }
        
        
    }
}

- (void)setNid:(NSInteger)nid
{
    if (_nid != nid) {
        _nid = nid;
        [self loadData];
    }
}
- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nid] forKey:@"nids"];
    [OBDataService requestWithURL:OBStatisticUrl params:params httpMethod:@"GET" completionblock:^(id result) {
        NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == 0) {
            NSArray *array = result[@"data"];
            if (array.count > 0) {
                OBStatisticModel *statistModel = [OBStatisticModel objectWithKeyValues:array[0]];
                self.statistModel = statistModel;
                if (statistModel.comment_count == 0) {
                    self.commentCountlabel.hidden = YES;
                    
                }else if (statistModel.comment_count <= 99) {
                    self.commentCountlabel.hidden = NO;
                    self.commentCountlabel.text =[NSString stringWithFormat:@"%ld",(long)statistModel.comment_count];
                }else {
                    self.commentCountlabel.hidden = NO;
                    self.commentCountlabel.text = @"99+";
                }
                CGSize commentlabelSize = [self.commentCountlabel.text sizeWithFont:[UIFont systemFontOfSize:KFont(12.0)]];
                self.commentCountlabel.width = commentlabelSize.width + KViewWidth(10);
                if (self.showChat) {
                    if (statistModel.chat_count == 0) {
                        self.chatCountlabel.hidden = YES;
                        
                    }else if (statistModel.chat_count <= 99) {
                        self.chatCountlabel.hidden = NO;
                        self.chatCountlabel.text =[NSString stringWithFormat:@"%ld",(long)statistModel.chat_count];
                    }else {
                        self.chatCountlabel.hidden = NO;
                        self.chatCountlabel.text = @"99+";
                    }
                    CGSize chatlabelSize = [self.chatCountlabel.text sizeWithFont:[UIFont systemFontOfSize:KFont(12.0)]];
                    self.chatCountlabel.width = chatlabelSize.width + KViewWidth(10);
                }
                
            } else {
                 self.commentCountlabel.hidden = YES;
                self.chatCountlabel.hidden = YES;
            }
            
        }
    } failedBlock:^(id error) {
        
    }];
}

@end
