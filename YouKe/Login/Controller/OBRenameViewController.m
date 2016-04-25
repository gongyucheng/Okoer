//
//  OBRenameViewController.m
//  YouKe
//
//  Created by obally on 15/8/29.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBRenameViewController.h"
#import "HWTextView.h"
#import "OBSingleColorView.h"
#import "NSString+Hash.h"

@interface OBRenameViewController ()<UITextFieldDelegate>
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) UITextField *textField;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) UIImageView *backImage;

@end

@implementation OBRenameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chattapAction)];
    //为imageView添加手势
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(15), KViewWidth(200), KViewHeight(40))];
    titleLabel.textColor = HWColor(31, 167, 86);
    titleLabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"用户名设置";
    [visualEffect addSubview:titleLabel];
    
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(100), kScreenWidth - KViewWidth(20), KViewHeight(30))];
    //    contentLabel.backgroundColor = HWRandomColor;
    tipLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"用户名已被占用，请重新设置";
    [self.view addSubview:tipLabel];
    
    UITextField *replyField = [[UITextField alloc]initWithFrame:CGRectMake(KViewWidth(10), tipLabel.bottom + 20, kScreenWidth - KViewWidth(20), KViewHeight(30))];
    replyField.placeholder = [OBAccountTool account].name;
    replyField.font = [UIFont systemFontOfSize:14.0];
    replyField.backgroundColor = [UIColor clearColor];
    replyField.keyboardType = UIKeyboardAppearanceDefault;
    replyField.returnKeyType = UIReturnKeyDone;
    self.textField = replyField;
    replyField.delegate = self;
    replyField.placeholder = self.info.nickname;
    [self.view addSubview:replyField];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(replyField.left, replyField.bottom,replyField.width, KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"line_0.3"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    backImage.userInteractionEnabled = YES;
    self.backImage = backImage;
    [self.view addSubview:backImage];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0,kScreenHeight - KViewHeight(60), kScreenWidth, KViewHeight(60))];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [saveButton setBackgroundColor:HWColor(30, 167, 86)];
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
}

- (void)chattapAction
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)saveButtonAction
{
    if (self.textField.text != nil) {
        NSString *uid = self.info.uid;
        //    NSString *nickName = self.info.nickname;
        //    NSString *profileUrl = info.profileImage;
        ShareType type = self.info.type;
        NSString *cpuTType;
        if (type == 1) {
            cpuTType = @"weibo";
        } else if (type == 6 ) {
            cpuTType = @"qq";
        } else
            cpuTType = @"OKoer";
        //    NSString *url = info.url;
        NSString *adId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.textField.text forKey:@"username"];
        [params setObject:cpuTType forKey:@"platform"];
        [params setObject:uid forKey:@"id"];
        [params setObject:adId forKey:@"imei"];
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeInterval =[date timeIntervalSince1970] ;
        NSString *timeString = [NSString stringWithFormat:@"%d",(int)timeInterval];
        if (self.currentTimeOffset) {
            NSInteger timeoffset = [self.currentTimeOffset intValue];
            NSInteger current = timeInterval + timeoffset;
            timeString = [NSString stringWithFormat:@"%ld",(long)current];
        }
        NSString *key = @"yaochizaocan";
        NSString *sign = [[NSString stringWithFormat:@"%@%@%@",key,timeString,adId]md5String];
        [params setObject:sign forKey:@"key"];
        [params setObject:timeString forKey:@"time"];
        [OBDataService requestWithURL:OBOkoerRegisterURL params:params httpMethod:@"POST" completionblock:^(id result) {
//            NSString *err = result[@"err_msg"];
            NSNumber *code = result[@"ret_code"];
            if ([code integerValue] == - 9) {
                //时间戳过期
                NSDictionary *resultDic = result[@"result"];
                NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                self.currentTimeOffset = timestamp_offset;
                [self saveButtonAction];
            } else if ([code integerValue] == 0) {
                NSDictionary *dic = result[@"result"];
                OBAccount *accountModel = [OBAccount objectWithKeyValues:dic];
                if (type == 1) {
                    accountModel.isSinaLogin = YES;
                    accountModel.isQQLogin = NO;
                    accountModel.isOKerLogin = NO;
                } else if (type == 6 ) {
                    accountModel.isSinaLogin = NO;
                    accountModel.isQQLogin = YES;
                    accountModel.isOKerLogin = NO;
                } else {
                    accountModel.isSinaLogin = NO;
                    accountModel.isQQLogin = NO;
                    accountModel.isOKerLogin = YES;
                }
                accountModel.sid = uid;
                
                [OBAccountTool saveAccount:accountModel];
                [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
                if (self.navigationController.viewControllers.count > 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
//                [OBNotificationCenter postNotificationName:@"DismissController" object:nil];
            } else if ([code integerValue] == -17) {
                //用户名已存在  去修改用户名
                [MBProgressHUD showAlert:@"用户名已存在"];
//                [KLToast showToast:@"用户名已存在"];
            }else if ([code integerValue] == - 8) {
                //token 过期
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(saveButtonAction)];
            }else if ([code integerValue] == - 24) {
                //签名错误
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(saveButtonAction)];
            }else{
                NSString *errSting = result[@"err_msg"];
               [MBProgressHUD showAlert:errSting];
            }

        } failedBlock:^(id error) {
            [MBProgressHUD showAlert:error];
        }];

    }
   
}
- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIImage *image1 = [UIImage imageNamed:@"line_1"];
    image1 = [image1 stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    self.backImage.image = image1;
    return YES;
}
@end
