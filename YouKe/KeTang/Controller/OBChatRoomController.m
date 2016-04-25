//
//  OBChatRoomController.m
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBChatRoomController.h"
#import "YouKe-swift.h"
#import "HWTextView.h"
#import "NSString+Hash.h"
#import "OBCommentModel.h"
#import "OBChatMessageTableView.h"
#import "OBChatMessageModel.h"
#import "OBChatMessageFrame.h"
#import "OBSingleColorView.h"
#import "MBProgressHUD+FTCExtension.h"
#import "OBOKOerLoginViewController.h"
//#import "MBProgressHUD+FTCExtension.h"

//#define kBottonEditHeight 50
//#define kTopBgHeight 60
@interface OBChatRoomController ()<BaseTableViewDelegate,UITextViewDelegate>
{
    SocketIOClient* socket;
    CGFloat _messageTotalHeight;
    MBProgressHUD *_hud;
}
@property (nonatomic, retain) UIImageView *bottomView;
@property (nonatomic, retain) HWTextView *textField;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property(nonatomic,assign)BOOL isFirstComein;
@property (nonatomic, retain) NSMutableArray *messageArrays;
@property (nonatomic, retain) OBChatMessageTableView *messageTableView;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) NSMutableArray *dataArrays;
@property (nonatomic, retain) UIView *loadBackview;
@property(nonatomic,assign)BOOL isFirstGetHistory;
@property(nonatomic,assign)BOOL isNormalQuit;
@property (nonatomic, retain) UIImageView *userImage;

@end

@implementation OBChatRoomController
- (void)dealloc
{
    [OBNotificationCenter removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"okoerba" attributes:@{@"okoerbaId":[NSString stringWithFormat:@"%ld",self.chatId]}];
     self.tabBarController.tabBar.hidden = YES;
    if ([OBAccountTool account] && self.isFirstComein) {
        [self connectChatRoom];
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//     self.tabBarController.tabBar.hidden = NO;
    if (self.chatMessageblock && self.dataArrays.count > 1) {
        self.chatMessageblock([self.dataArrays lastObject]);
    }
     self.isNormalQuit = YES;
    [socket close];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.messageArrays = [NSMutableArray array];
    self.dataArrays = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self registNotification];
    [self initViews];
    [self connectChatRoom];
}
- (void)registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chattapAction)];
    //为imageView添加手势
    [self.view addGestureRecognizer:tap];
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
    titleLabel.text = self.roomtitle;
    [visualEffect addSubview:titleLabel];
    //tableView
    OBChatMessageTableView *chatMessage = [[OBChatMessageTableView alloc]initWithFrame:CGRectMake(0, refreshHeaderView.bottom, kScreenWidth, kScreenHeight - KViewHeight(50) - refreshHeaderView.height) style:UITableViewStylePlain];
    self.messageTableView = chatMessage;
    chatMessage.refreshDelegate = self;
    //    chatMessage.bottom = bottomView.top;
    [self.view addSubview:chatMessage];
    //回复视图
    UIImageView *bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight - KViewHeight(50), kScreenWidth, KViewHeight(50))];
    bottomView.backgroundColor = HWColor(241, 241, 241);
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    //头像
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(5), KViewWidth(40), KViewHeight(40))];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = userImage.width/2;
    userImage.backgroundColor = HWRandomColor;
    self.userImage = userImage;
    if ([OBAccountTool account].icon.length > 0) {
        [userImage sd_setImageWithURL:[NSURL URLWithString:[OBAccountTool account].icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
    } else
        userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
    [bottomView addSubview:userImage];
    
    //回复按钮
    UIButton *sendReplybutton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(70), KViewHeight(10), KViewWidth(60), KViewHeight(30))];
    [sendReplybutton setBackgroundImage:[UIImage imageNamed:@"icon_0001_sent60"] forState:UIControlStateNormal];
    sendReplybutton.showsTouchWhenHighlighted = YES;
    [sendReplybutton addTarget:self action:@selector(sendreplyAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendReplybutton];
    //回复
    HWTextView *replyField = [[HWTextView alloc]initWithFrame:CGRectMake(KViewWidth(60), KViewHeight(5), kScreenWidth - KViewWidth(130), KViewWidth(40))];
    replyField.placeholder = @"说点什么";
    replyField.font = [UIFont systemFontOfSize:KFont(14.0)];
    replyField.backgroundColor = [UIColor clearColor];
    replyField.tag = 103;
    replyField.delegate = self;
    self.textField = replyField;
    [bottomView addSubview:replyField];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(60), KViewHeight(35), kScreenWidth - KViewWidth(130), KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"line_1"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    backImage.userInteractionEnabled = YES;
    [bottomView addSubview:backImage];
}

- (void)connectChatRoom
{
    
//    https://github.com/socketio/socket.io-client-swift/blob/master/README.md
    self.isNormalQuit = NO;
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.messageTableView animated:YES];
    }
    //建立长连接
    socket = [[SocketIOClient alloc]initWithSocketURL:OBConnectChatURL opts:nil];
    //连接成功后加入聊天室
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        [_hud hide:YES];
        NSLog(@"socket connected");
        [self joinChat];
        
        
    }];
    //重新连接
    [socket on:@"reconnect" callback:^(NSArray* data, SocketAckEmitter* ack){
        NSLog(@"reconnect");
        
    }];
    //未连接
    [socket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack){
        NSLog(@"disconnect");
        
        [_hud hide:YES];
        if ( !self.isNormalQuit )
            [MBProgressHUD showAlert:@"网络连接失败"];
        
    }];
    //连接出错
    [socket on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack){
        NSLog(@"error");
        [MBProgressHUD showAlert:@"网络连接失败"];
        if (_hud) {
            [_hud hide:YES];
        }
        
        
    }];
    //接收服务器返回的消息
    [socket on:@"new_message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        [_hud hide:YES];
        NSDictionary *dic  =data[0];
        OBChatMessageModel *model = [OBChatMessageModel objectWithKeyValues:dic[@"v1"]];
//        [self.messageArrays addObject:model];
        OBChatMessageFrame *frame = [self messageFramesWithMessage:model];
        for (int i = 1; i < self.dataArrays.count; i ++) {
            if ([self.dataArrays[i] isKindOfClass:[OBChatMessageFrame class]]) {
                OBChatMessageFrame *messageframe =  self.dataArrays[i];
                if (messageframe.chatModel.msg._id != model.msg._id && i== self.dataArrays.count - 1) {
                     [self.dataArrays addObject:frame];
                }
            } else
                [self.dataArrays addObject:frame];
            
        }
        
        if(self.dataArrays.count == 1){
            [self.dataArrays addObject:frame];
        }
        self.messageTableView.dataList = self.dataArrays;
//        self.dataArrays = dataArrays;
        [self.messageTableView reloadData];
        if(_messageTotalHeight + self.bottomView.height > kScreenHeight) {
            [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArrays.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    }];
    //接收服务器返回的历史消息
    [socket on:@"put_history" callback:^(NSArray* data, SocketAckEmitter* ack) {

        NSMutableArray *messageModels = [NSMutableArray array];
        NSDictionary *dic  =data[0];
        NSDictionary *v1 = dic[@"v1"];
        NSArray *arrays = v1[@"res"];
        if (arrays.count > 0) {
            [_hud hide:YES];
            for (int i = 0; i < arrays.count; i++) {
                NSDictionary *dic= arrays[i];
                OBChatMessageModel *model = [OBChatMessageModel objectWithKeyValues:dic];
                OBChatMessageFrame *frame = [self messageFramesWithMessage:model];
                [messageModels addObject:frame];
                if (self.dataArrays.count > 0) {
                    [self.dataArrays insertObject:frame atIndex:i + 1];
                }
                
            }
            self.messageTableView.dataList = self.dataArrays;
            [self.messageTableView reloadData];
            if (!self.isFirstGetHistory) {
                self.isFirstGetHistory = YES;
                if (self.dataArrays.count > 1) {
                    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArrays.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }

            }
        }
        
    }];

    //接收系统消息消息
    [socket on:@"sys_message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [_hud hide:YES];
        if (data.count > 0) {
            NSDictionary *dic = data[0];
            NSDictionary *resultDic = dic[@"v1"];
            NSDictionary *resultDic1 = resultDic[@"result"];
            NSNumber *code =  resultDic[@"code"];
            NSString *message = resultDic1[@"msg"];
            if ([code integerValue] == - 22) {
                
                if (!self.loadBackview) {
                    
                    self.loadBackview = [[UIView alloc]initWithFrame:CGRectMake(0, KViewHeight(80), kScreenWidth, kScreenHeight - KViewHeight(80))];
                    self.loadBackview.backgroundColor = [UIColor whiteColor];
                    //                    view.backgroundColor = HWRandomColor;
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.messageTableView.width - KViewWidth(220))/2, (self.messageTableView.height - KViewWidth(220))/2, KViewWidth(220), KViewWidth(220))];
                    imageView.userInteractionEnabled = YES;
                    imageView.image = [UIImage imageNamed:@"pagefailed_bg"];
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.left, imageView.bottom + KViewHeight(20), imageView.width, KViewHeight(60))];
                    label.textColor = [UIColor grayColor];
                    label.text = message;
                    label.textAlignment = NSTextAlignmentCenter;
                    [self.loadBackview addSubview:label];
                    [self.loadBackview addSubview:imageView];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
                    [self.loadBackview addGestureRecognizer:tap];
                    [self.view addSubview:self.loadBackview];
                }
                
            } else if ([code integerValue] == - 24) {
                
                //签名错误
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(joinChat)];
            }else if ([code integerValue] == - 8) {
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(joinChat)];
            }else if ([code integerValue] == 0){
                if (self.loadBackview) {
                    [self.loadBackview removeFromSuperview];
                    self.loadBackview = nil;
                }
                if (!self.isFirstComein) {
                    self.isFirstComein = YES;
                    self.dataArrays = [NSMutableArray arrayWithArray:@[message]];
                    self.messageTableView.dataList = self.dataArrays;
                    [self.messageTableView reloadData];
                     [self getHistory];
                }
               
            }
            
            
        }
        

    }];
    [socket connect];
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self joinChat];
    if (self.loadBackview) {
        _hud = [MBProgressHUD showHUDAddedTo:self.loadBackview animated:YES];
    }
    self.isFirstComein = NO;
    
}
- (void)joinChat
{
    
    _hud = [MBProgressHUD showHUDAddedTo:self.messageTableView animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"version"];
    if (self.chatId) {
        [dic setObject:[NSNumber numberWithInteger:self.chatId] forKey:@"chat_id"];
    }
    if (self.roomtitle) {
         [dic setObject:self.roomtitle forKey:@"title"];
    }
    [dic setObject:@1 forKey:@"req_id"];
   
    if ([OBManager sessionManager].status == OBSessionStatusLogin && [OBAccountTool account]) {
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
        NSLog(@"timeString %@",timeString);
        NSString *sign = [[NSString stringWithFormat:@"%@%@%@",uid,timeString,token]md5String];
        OBAccount *accout = [OBAccountTool account];
        [userDic setObject:accout.name forKey:@"name"];
        [userDic setObject:accout.uid forKey:@"uid"];
        [userDic setObject:sign forKey:@"sign"];
        [userDic setObject:timeString forKey:@"timestamp"];
    } else {
        [userDic setObject:@"anonymous" forKey:@"name"];
        [userDic setObject:@0 forKey:@"uid"];
    }
    [dic setObject:userDic forKey:@"user"];
    NSArray *params = [NSArray arrayWithObject:dic];

    [socket emit:@"user_join" withItems:params];
}

- (void)sendreplyAction:(UIButton *)button
{
   
    self.textField.text = [self.textField.text trim];
    if (self.textField.text.length == 0) {
        [MBProgressHUD showAlert:@"内容不能为空"];
//        [KLToast showToast:@"内容不能为空"];
    }else if ([OBAccountTool account]) {
        _hud = [MBProgressHUD showHUDAddedTo:self.messageTableView animated:YES];
//        _hud.dimBackground = YES;
        NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
        [messageDic setObject:@1 forKey:@"version"];
        [messageDic setObject:[NSNumber numberWithInteger:self.chatId] forKey:@"chat_id"];
        [messageDic setObject:@1 forKey:@"req_id"];
        [msgDic setObject:@1 forKey:@"type"];
        [msgDic setObject:self.textField.text forKey:@"content"];
        [messageDic setObject:msgDic forKey:@"msg"];
        NSArray *messages = [NSArray arrayWithObject:messageDic];
        [socket emit:@"send_message" withItems:messages];
        self.textField.text = nil;
    } else {

    }
}

- (void)getHistory
{
    if (self.isFirstComein) {
//        _hud = [MBProgressHUD showHUDAddedTo:self.messageTableView animated:YES];
//        _hud.dimBackground = YES;
    }
    NSInteger revision = 0;
    if (self.dataArrays.count > 1) {
        OBChatMessageFrame *chatframe = self.dataArrays[1];
        revision = chatframe.chatModel.msg.revision;
    }
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
    [messageDic setObject:@1 forKey:@"version"];
    [messageDic setObject:[NSNumber numberWithInteger:self.chatId] forKey:@"chat_id"];
    [messageDic setObject:@1 forKey:@"req_id"];
    [msgDic setObject:[NSNumber numberWithInteger:revision] forKey:@"revision"];
//    [msgDic setObject:self.textField.text forKey:@"content"];
    if (revision == 0) {
        [msgDic setObject:@10 forKey:@"pagerows"];

    }else
        [msgDic setObject:@20 forKey:@"pagerows"];
    [messageDic setObject:msgDic forKey:@"param"];
    NSArray *historys = [NSArray arrayWithObject:messageDic];
    [socket emit:@"get_history" withItems:historys];
    
}
- (void)leaveChatRoom
{
    [socket emit:@"user_leave" withItems:@[]];
}

- (void)chattapAction
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


/**
 *  将OBChatMessageModel模型转为OBChatMessageFrame模型
 */
- (OBChatMessageFrame *)messageFramesWithMessage:(OBChatMessageModel *)model
{
    OBChatMessageFrame *f = [[OBChatMessageFrame alloc] init];
    if (self.dataArrays.count > 1 && [[self.dataArrays lastObject] isKindOfClass:[OBChatMessageFrame class]]) {
        OBChatMessageFrame *lastModel = [self.dataArrays lastObject];
        long long expires_in = 2*60;
        // 获得过期时间
        NSInteger lastTime = lastModel.chatModel.msg.revision/1000 + expires_in;
        // 获得当前时间
        NSInteger currentTime = (model.msg.revision)/1000;
        
//        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:lastTime];
//        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentTime];
//        BOOL isSameDay = [self isSameDay:lastDate date2:currentDate];
//        if (!isSameDay) {
//            f.showTimeLabelWithYear = YES;
//            f.showTimeLabel = NO;
//        }
        
       if (currentTime > lastTime) {
            //显示日期加时间
            f.showTimeLabelWithYear = NO;
            f.showTimeLabel = YES;
        } else {
            f.showTimeLabel = NO;
            f.showTimeLabelWithYear = NO;
        }
        
        
    } else if (self.dataArrays.count == 1) {
        f.showTimeLabelWithYear = YES;
        f.showTimeLabel = YES;
    }

        if ([model.user.name isEqualToString:[OBAccountTool account].name]) {
            f.isCurrentUser = YES;
            self.textField.text = nil;
            [self.textField resignFirstResponder];
        }
        f.chatModel = model;
        _messageTotalHeight += f.originalViewF.size.height;
    
    
    return f;
}
/**
 *  是否为同一天
 */
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
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
//                             self.messageTableView.bottom = self.bottomView.top;
                             
                         }
                         completion:^(BOOL finished){
                         }];
        
    }
}
#pragma mark -baseTableView
- (void)pullDown:(BaseTableView *)tableView
{
//    [_hud show:YES];
     [self getHistory];
   
   
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    if (![OBAccountTool account]) {
        OBOKOerLoginViewController *okoer = [[OBOKOerLoginViewController alloc]init];
        [self presentViewController:okoer animated:YES completion:nil];
        return NO;
    } else
        return YES;
}

-(void)didReceiveMemoryWarning
{
    NSLog(@"OBChatRoomController --didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

@end
