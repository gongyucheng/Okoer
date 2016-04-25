//
//  OBCommentViewController.m
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBCommentViewController.h"
#import "HWTextView.h"
#import "NSString+Hash.h"
#import "OBCommentModel.h"
#import "OBCommentFrame.h"
#import "OBSingleColorView.h"
#import "OBCommentTableView.h"
#import "OBReplyView.h"
#import "MBProgressHUD.h"
#import "OBJuBaoViewController.h"
#import "OBOKOerLoginViewController.h"

#define kBottonEditHeight 50
#define kTopBgHeight 60
@interface OBCommentViewController ()<BaseTableViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,OBCommentTableViewDelegate,OBReplyViewDelegate>
{
    CGFloat _messageTotalHeight;
    BOOL isReply;
     MBProgressHUD *_hud;
}
//@property (nonatomic, retain) UIView *commentView;
@property (nonatomic, retain) UIImageView *bottomView;
@property (nonatomic, retain) HWTextView *textField;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) OBCommentTableView *commentTable;
@property (nonatomic, retain) UITapGestureRecognizer *tap;
@property (nonatomic, retain) OBCommentModel *replyCommentModel;
@property (nonatomic, retain) OBReplyView *replyView;
@property(nonatomic,assign)NSInteger currentSelectedIndex;
@property (nonatomic, retain) UIButton *replyButton;
@property(nonatomic,assign)NSInteger page;
@property (nonatomic, retain) NSMutableArray *dataArrays;
@property (nonatomic, copy) NSString *lastComment;
@property (nonatomic, retain) UIView *placeholderView;
@property (nonatomic, retain) UIImageView *userImage;
@end

@implementation OBCommentViewController
- (void)dealloc
{
    [OBNotificationCenter removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.tabBarController.tabBar.hidden = YES;
    if ([OBAccountTool account]) {
        if (self.userImage) {
            [self.userImage sd_setImageWithURL:[NSURL URLWithString:[OBAccountTool account].icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
        }
        
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.dataArrays = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self registNotification];
    [self initViews];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    self.tap = tap;
    
    
}
- (void)initViews
{
    //头部----------------------
    OBSingleColorView *refreshHeaderView = [[OBSingleColorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(60))];
    [self.view addSubview:refreshHeaderView];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView = visualEffect;
    visualEffect.frame = refreshHeaderView.frame;
    visualEffect.alpha = 1.0;
    [self.view addSubview:visualEffect];
    //返回按钮
   UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(25), KViewWidth(24), KViewWidth(24))];
    //    backButton.backgroundColor = HWRandomColor;
    [backButton setBackgroundImage:[UIImage imageNamed:@"u215"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:backButton];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(250))/2, KViewHeight(15), KViewWidth(250), KViewHeight(40))];
    titleLabel.textColor = HWColor(31, 167, 86);
    titleLabel.font = [UIFont boldSystemFontOfSize:KFont(15.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.commentTitle;
    [visualEffect addSubview:titleLabel];
    //tableView
    OBCommentTableView *commentTable = [[OBCommentTableView alloc]initWithFrame:CGRectMake(0, refreshHeaderView.bottom, kScreenWidth, kScreenHeight - KViewHeight(50) - refreshHeaderView.height) style:UITableViewStylePlain];
    self.commentTable = commentTable;
    commentTable.commentTabelViewDelegate = self;
    commentTable.refreshDelegate = self;
//    commentTable.tableFooterView.hidden = NO;
    //    chatMessage.bottom = bottomView.top;
    [self.view addSubview:commentTable];
    
    //回复视图
    UIImageView *bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight - KViewHeight(50), kScreenWidth, KViewHeight(50))];
    bottomView.backgroundColor = HWColor(241, 241, 241);
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    //头像
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(5), KViewWidth(40), KViewHeight(40))];
    userImage.layer.cornerRadius = userImage.width/2;
    userImage.backgroundColor = HWRandomColor;
    userImage.layer.masksToBounds = YES;
    self.userImage = userImage;
    if ([OBAccountTool account].icon.length > 0) {
        [userImage sd_setImageWithURL:[NSURL URLWithString:[OBAccountTool account].icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
    } else
        userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
    [bottomView addSubview:userImage];

    //回复按钮
    UIButton *sendReplybutton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(60), KViewHeight(10), KViewWidth(50), KViewHeight(30))];
    self.replyButton = sendReplybutton;
    [sendReplybutton setTitle:@"发送" forState:UIControlStateNormal];
    sendReplybutton.showsTouchWhenHighlighted = YES;
    [sendReplybutton setTitleColor:HWColor(65, 180, 112) forState:UIControlStateNormal];
    UIImage *sendimage = [UIImage imageNamed:@"tag_green_.1"];
    sendimage = [sendimage stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    [sendReplybutton setBackgroundImage:sendimage forState:UIControlStateNormal];
    [sendReplybutton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
//    sendReplybutton.backgroundColor = HWRandomColor;
//    sendReplybutton.layer.cornerRadius = sendReplybutton.height/2;
    sendReplybutton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [bottomView addSubview:sendReplybutton];
    //回复
    HWTextView *replyField = [[HWTextView alloc]initWithFrame:CGRectMake(KViewWidth(60), KViewHeight(5), kScreenWidth - KViewWidth(130), KViewHeight(40))];
    replyField.placeholder = @"说点什么";
    replyField.font = [UIFont systemFontOfSize:KFont(14.0)];
    replyField.backgroundColor = [UIColor clearColor];
    replyField.tag = 103;
    replyField.keyboardType = UIKeyboardAppearanceDefault;
    replyField.returnKeyType = UIReturnKeyDone;
    replyField.delegate = self;
    self.textField = replyField;
    [bottomView addSubview:replyField];
    // 文字改变的通知
    [OBNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:replyField];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(60), KViewHeight(35), kScreenWidth - KViewWidth(130), KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"line_1"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    [bottomView addSubview:backImage];
    
}

- (void)loadData
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.commentTable animated:YES];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSNumber *pageCount = [NSNumber numberWithInteger:_page];
    [params setObject:pageCount forKey:@"page"];
    [params setObject:@10 forKey:@"page_rows"];
    [params setObject:[NSNumber numberWithInteger:self.pageId] forKey:@"nid"];
    
    [OBDataService requestWithURL:OBCommentListUrl params:params httpMethod:@"GET" completionblock:^(id result) {
        [_hud hide:YES];
        [self praseDataWithResult:result];
    } failedBlock:^(id error) {
        [_hud hide:YES];
        [MBProgressHUD showAlert:error];
//        [KLToast showToast:error];
    }];
}

- (void)praseDataWithResult:(id)result
{
    
    NSArray *dataArray = result[@"data"];
    if (dataArray.count > 0) {
        self.commentTable.refreshFooterButton.hidden = NO;
        NSMutableArray *dataArrays = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            OBCommentModel *commentModel = [OBCommentModel objectWithKeyValues:dic];
            OBCommentFrame *frame = [self messageFramesWithMessage:commentModel];
            [dataArrays addObject:frame];
        }
        [self.dataArrays addObjectsFromArray:dataArrays];
        if (dataArrays.count >= 10) {
            self.commentTable.refreshFooter = YES;
        } else {
            self.commentTable.refreshFooter = NO;
        }

//        self.dataArrays = dataArrays;
        self.commentTable.dataList = self.dataArrays;
        [self.commentTable reloadData];
        if (self.placeholderView) {
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
        }
    } else if(self.dataArrays.count ==0){
        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.commentTable.top, kScreenWidth, KViewHeight(100))];
        [self.view addSubview:view2];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(50), KViewWidth(200), KViewHeight(50))];
        label.text = @"暂无评论";
        label.textAlignment = NSTextAlignmentCenter;
        self.placeholderView = view2;
        [view2 addSubview:label];
    } else if (dataArray.count == 0) {
        self.commentTable.refreshFooter = NO;
    }
   _page ++;
    
}
- (void)praseCommentDataWithResult:(id)result
{
   
    if ([result[@"err_msg"] isEqualToString:@"ok"]) {
        OBCommentModel *commentModel = [OBCommentModel objectWithKeyValues:result];
        
        if (isReply && self.replyCommentModel) {
            commentModel.pname = self.replyCommentModel.name;
            OBCommentFrame *frame = [self messageFramesWithMessage:commentModel];
            [self.dataArrays insertObject:frame atIndex:self.currentSelectedIndex + 1];
        } else {
            OBCommentFrame *frame = [self messageFramesWithMessage:commentModel];
            [self.dataArrays insertObject:frame atIndex:0];
            if (self.commentTable.dataList.count > 0) {
                [self.commentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
        }
        self.commentTable.dataList = self.dataArrays;
        isReply = NO;
        self.replyCommentModel = nil;
        self.textField.text = nil;
        self.textField.placeholder = @"说点什么";
        [self.commentTable reloadData];
        if (self.placeholderView) {
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
        }

    }
}

/**
 *  将OBChatMessageModel模型转为OBChatMessageFrame模型
 */
- (OBCommentFrame *)messageFramesWithMessage:(OBCommentModel *)model
{
    OBCommentFrame *f = [[OBCommentFrame alloc] init];
    if (model.pid != 0) {
        f.isReply = YES;
        self.textField.text = nil;
        [self.textField resignFirstResponder];
    } else
        f.isReply = NO;
    f.commentModel = model;
    _messageTotalHeight += f.originalViewF.size.height;
    return f;
}

- (void)sendAction:(UIButton *)button
{
    
    self.textField.text = [self.textField.text trim];
    button.enabled = NO;
    if (self.textField.text.length > 140) {
        [MBProgressHUD showAlert:@"请用1 ~ 140字表达你的态度"];
//        [KLToast showToast:@"请用少于140字表达你的态度" autoDismiss:YES];
    } else if (self.textField.text.length < 1) {
        [MBProgressHUD showAlert:@"请用1 ~ 140字表达你的态度"];
//        [KLToast showToast:@"评论内容不能为空" autoDismiss:YES];
    } else if (self.textField.text.length != 0) {
        _hud = [MBProgressHUD showHUDAddedTo:self.commentTable animated:YES];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[NSNumber numberWithInteger:self.pageId] forKey:@"nid"];
        [params setObject:[NSNumber numberWithInteger:0] forKey:@"pid"];
        [params setObject:self.textField.text forKey:@"subject"];
        [params setObject:self.textField.text forKey:@"content"];
        if (isReply && self.replyCommentModel) {
            [params setObject:[NSNumber numberWithInteger:self.replyCommentModel.cid] forKey:@"pid"];
        }
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
        [OBDataService requestWithURL:OBCreateCommentUrl(uid,timeString,sign) params:params httpMethod:@"POST" completionblock:^(id result) {
            [_hud hide:YES];
            NSNumber *code = result[@"ret_code"];
            if ([code integerValue] == 0) {
                self.textField.text = nil;
                button.enabled = YES;
                [self praseCommentDataWithResult:result];
            }else if ([code integerValue] == - 9) {
                NSDictionary *resultDic = result[@"result"];
                NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                self.currentTimeOffset = timestamp_offset;
                [self sendAction:button];
            }else if ([code integerValue] == - 99) {
                
                [MBProgressHUD showAlert:@"暂不支持输入表情"];
            }else if ([code integerValue] == - 8) {
                //token 过期
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(sendAction:)];
            }else if ([code integerValue] == - 24) {
                //签名错误
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(sendAction:)];
            }
            
            
        } failedBlock:^(id error) {
            [_hud hide:YES];
           [MBProgressHUD showAlert:error];
        }];
        
    }
    
}
/**
 * 监听文字改变
 */
- (void)textDidChange
{
    self.replyButton.enabled = self.textField.hasText;
    if (self.textField.text.length == 48) {
        
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    if ([OBManager sessionManager].status == OBSessionStatusLogout) {
        OBOKOerLoginViewController *okoer = [[OBOKOerLoginViewController alloc]init];
        [self.navigationController pushViewController:okoer animated:YES];
//        [self presentViewController:okoer animated:YES completion:nil];
        return NO;
    } else
        return YES;
}
- (void)backButton
{
    if (self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
#pragma mark - keyBoard
- (void)keyBoardWillShow:(NSNotification *)notification
{
    //    UITextView *textView = (UITextView *)[commentView viewWithTag:103];
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        [UIView animateWithDuration:keyboardTransitionDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.bottomView.bottom = kScreenHeight - keyboardEndFrameWindow.size.height;
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        [UIView animateWithDuration:keyboardTransitionDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.bottomView.top = kScreenHeight - KViewHeight(50);

                         }
                         completion:^(BOOL finished){
                         }];
        
    }
}


- (void)tapAction
{
    [self.replyView removeFromSuperview];
    [self.view removeGestureRecognizer:self.tap];
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

#pragma mark -
- (void)pullDown:(BaseTableView *)tableView
{
    _page = 0;
     _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.dimBackground = YES;
    if (self.dataArrays.count > 0) {
        [self.dataArrays removeAllObjects];
    }
    [self.replyView removeFromSuperview];
    [self.view removeGestureRecognizer:self.tap];
    [self loadData];
}
- (void)pullUp:(BaseTableView *)tableView
{
    [self.replyView removeFromSuperview];
    [self.view removeGestureRecognizer:self.tap];
    [self loadData];
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
    
}

#pragma mark - OBCommentTableViewDelegate
- (void)didSelectedCellWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArrays.count > 0) {
        OBCommentFrame *frame = self.dataArrays[indexPath.row];
        if (![frame.commentModel.name isEqualToString:[OBAccountTool account].name]) {
            self.currentSelectedIndex = indexPath.row;
            UITableViewCell *cell = [self.commentTable cellForRowAtIndexPath:indexPath];
            OBReplyView *replyView = [[OBReplyView alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(150), KViewHeight(5), KViewWidth(120), KViewHeight(50))];
            replyView.replyDelegate = self;
            self.replyView = replyView;
            
            replyView.commentModel = frame.commentModel;
            [cell.contentView addSubview:replyView];
            [self.view addGestureRecognizer:self.tap];
        }
    }
    

}
#pragma mark - OBReplyViewDelegate
- (void)didSelectedJuBaoWithCommentModel:(OBCommentModel *)commentModel
{
    [self.replyView removeFromSuperview];
    [self.view removeGestureRecognizer:self.tap];
    OBJuBaoViewController *jubao = [[OBJuBaoViewController  alloc]init];
    jubao.cid = commentModel.cid;
    [self.navigationController pushViewController:jubao animated:YES];
//    [self presentViewController:jubao animated:YES completion:nil];
}
- (void)didSelectedReplyWithCommentModel:(OBCommentModel *)commentModel
{

    [self.textField becomeFirstResponder];
    self.replyCommentModel = commentModel;
    [self.replyView removeFromSuperview];
    [self.view removeGestureRecognizer:self.tap];
    self.textField.placeholder = [NSString stringWithFormat:@"回复%@",commentModel.name];
    isReply = YES;
}
@end
