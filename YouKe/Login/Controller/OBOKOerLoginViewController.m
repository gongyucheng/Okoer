//
//  OBOKOerLoginViewController.m
//  YouKe
//
//  Created by obally on 15/7/27.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBOKOerLoginViewController.h"
#import "OBAccount.h"
#import "OBAccountTool.h"
#import "OBContainerViewController.h"
#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import "NSString+Hash.h"
#import "OBRenameViewController.h"
#import "GTMBase64.h"

@interface OBOKOerLoginViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *_hud;
}
@property (nonatomic, retain) UITextField *userNameTextField;
@property (nonatomic, retain) UITextField *passWordTextField;
@property (nonatomic, retain) UILabel *errorLabel;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) OBAccount *accountModel;
@property (nonatomic, retain) UIImageView *userBackImage;
@property (nonatomic, retain) UIImageView *passWordBackImage;
@property (nonatomic, retain) UIButton *backButton;

@end

@implementation OBOKOerLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"backGound.jpg"];
    [self initViews];
    self.view.backgroundColor = HWRandomColor;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)initViews
{
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KbuttonEdgeWidth, kScreenHeight - KbuttonEdgeWidth - KbuttonWidth, KbuttonWidth, KbuttonWidth)];
    //    backButton.backgroundColor = HWRandomColor;
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_0001_Return48"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = backButton.width/2;
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    self.backButton = backButton;
    
    //用户名
    UITextField *userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(KViewWidth(30) ,KViewHeight(170), kScreenWidth -  KViewWidth(30) * 2, KViewHeight(40))];
    if ([OBAccountTool account].name) {
        userNameTextField.text = [OBAccountTool account].name;
    }
    if ([OBAccountTool getLastAccount]) {
        userNameTextField.text = [OBAccountTool getLastAccount].name;
    }
    userNameTextField.placeholder = @"优恪用户名/邮箱";
    [userNameTextField setValue:HWColor(102, 102, 102) forKeyPath:@"_placeholderLabel.textColor"];
    userNameTextField.delegate = self;
    userNameTextField.tag = 100;
    userNameTextField.textColor = [UIColor whiteColor];
    [userNameTextField resignFirstResponder];
    userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTextField.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbghover.png"]];
    [self.view addSubview:userNameTextField];
    self.userNameTextField = userNameTextField;
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(userNameTextField.left - KViewWidth(4), userNameTextField.bottom - KViewHeight(10), userNameTextField.width + KViewWidth(8), KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"line_0.3"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    self.userBackImage = backImage;
    [self.view addSubview:backImage];
    
    //错误提示
    UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(30), userNameTextField.bottom, KViewWidth(300), KViewHeight(40))];
    errorLabel.textColor = [UIColor redColor];
    errorLabel.font = [UIFont systemFontOfSize:KFont(12.0)];
    self.errorLabel = errorLabel;
    
    //密码
    UITextField *passWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(userNameTextField.left, userNameTextField.bottom + KViewHeight(40), kScreenWidth -  KViewWidth(30) * 2, KViewHeight(40))];
    passWordTextField.placeholder = @"密码";
    [passWordTextField setValue:HWColor(102, 102, 102) forKeyPath:@"_placeholderLabel.textColor"];
    passWordTextField.delegate = self;
    passWordTextField.textColor = [UIColor whiteColor];
    passWordTextField.tag = 101;
    passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordTextField.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbghover.png"]];
    passWordTextField.secureTextEntry = YES;
    [self.view addSubview:passWordTextField];
    UIImageView *pbackImage = [[UIImageView alloc]initWithFrame:CGRectMake(backImage.left, passWordTextField.bottom - KViewHeight(10), backImage.width, KViewHeight(10))];
    UIImage *pimage = [UIImage imageNamed:@"line_0.3"];
    pimage = [pimage stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    pbackImage.image = pimage;
    self.passWordBackImage = pbackImage;
    [self.view addSubview:pbackImage];
    UIButton *eyeButton = [[UIButton alloc]initWithFrame:CGRectMake(pbackImage.right - KViewWidth(40), passWordTextField.top, KViewWidth(32), KViewWidth(32))];
    [eyeButton setBackgroundImage:[UIImage imageNamed:@"icon_0012_visible32"] forState:UIControlStateNormal];
    [eyeButton setBackgroundImage:[UIImage imageNamed:@"icon_0011_invisible32"] forState:UIControlStateSelected];
    [eyeButton addTarget:self action:@selector(eyeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eyeButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    //为imageView添加手势
    [self.view addGestureRecognizer:tap];
    self.passWordTextField = passWordTextField;
    //微博登录
    UIButton *wbLoginButton = [[UIButton alloc]initWithFrame:CGRectMake(passWordTextField.left,passWordTextField.bottom + KViewHeight(40), KViewWidth(40), KViewWidth(40))];
    [wbLoginButton setBackgroundImage:[UIImage imageNamed:@"icon_0017_sina48"] forState:UIControlStateNormal];
    [wbLoginButton addTarget:self action:@selector(wbLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wbLoginButton];
    //QQ登录
    UIButton *qqLoginButton = [[UIButton alloc]initWithFrame:CGRectMake(wbLoginButton.right + KViewWidth(20), wbLoginButton.top, KViewWidth(40), KViewWidth(40))];
    [qqLoginButton setBackgroundImage:[UIImage imageNamed:@"icon_0012_qq48"] forState:UIControlStateNormal];
    [qqLoginButton addTarget:self action:@selector(qqLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLoginButton];
    //okoer 登录
    UIButton *okoerLoginButton = [[UIButton alloc]initWithFrame:CGRectMake(passWordTextField.right - KViewWidth(70), qqLoginButton.top, KViewWidth(80), KViewHeight(40))];
    okoerLoginButton.layer.cornerRadius = okoerLoginButton.height/2;
    [okoerLoginButton addTarget:self action:@selector(okoerLoginButton) forControlEvents:UIControlEventTouchUpInside];
    UIImage *okoerimage = [UIImage imageNamed:@"login1"];
    okoerimage = [okoerimage stretchableImageWithLeftCapWidth:35 topCapHeight:30];
    [okoerLoginButton setBackgroundImage:okoerimage forState:UIControlStateNormal];
    [okoerLoginButton setTitle:@"立即登录" forState: UIControlStateNormal];
    okoerLoginButton.titleLabel.textColor = [UIColor whiteColor];
    okoerLoginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    okoerLoginButton.titleLabel.font = [UIFont systemFontOfSize:KFont(12.0)];
    [self.view addSubview:okoerLoginButton];

}
- (void)eyeButton:(UIButton *)eyeButton
{
    eyeButton.selected = !eyeButton.selected;
    if (eyeButton.selected) {
        self.passWordTextField.secureTextEntry = NO;
    } else
        self.passWordTextField.secureTextEntry = YES;
}
#pragma mark - 登录
- (void)wbLoginButton
{
    [MobClick event:@"reguser_weibo"];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result) {
                                   [self parseDataAfterLoginWithInfo:userInfo];
                               }else {
//                                   [KLToast showToast:[error debugDescription]];
                                   [MBProgressHUD showAlert:@"登录失败"];
                               }
                               
                           }];
}
- (void)qqLoginButton
{
    [MobClick event:@"reguser_qq"];
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result) {
                                   [self parseDataAfterLoginWithInfo:userInfo];
                               } else {
//                                   [KLToast showToast:[error debugDescription]];
                                [MBProgressHUD showAlert:@"登录失败"];
                               }
                               
                           }];
}
- (void)okoerLoginButton
{
    [MobClick event:@"reguser_weibo"];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *adId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.userNameTextField.text forKey:@"username"];
    [params setObject:self.passWordTextField.text forKey:@"password"];
    
    [params setObject:adId forKey:@"imei"];
    [[OBManager sessionManager]loginWithUserName:self.userNameTextField.text passWord:self.passWordTextField.text imei:adId callback:^(BOOL success, NSString *msg) {
        [_hud hide:YES];
        if (success) {
            if (self.isNormalLogin) {
               
                if (self.navigationController.viewControllers.count > 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
                 [OBNotificationCenter postNotificationName:@"DismissController" object:nil];
            } else
                if (self.navigationController.viewControllers.count > 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
        } else {
            [_hud hide:YES];
        }
    }];
    
}
#pragma mark - prase Data
- (void)parseDataAfterLoginWithInfo:(id<ISSPlatformUser>)info
{
    NSDictionary *dic = [info sourceData];
    NSString *uid = info.uid;
    if (uid == nil) {
        uid = @"";
    }
    NSString *nickName = info.nickname;
       ShareType type = info.type;
    NSString *cpuTType;
    NSString *profileUrl;
    if (type == 1) {
        cpuTType = @"weibo";
        profileUrl = dic[@"profile_image_url"];
    } else if (type == 6 ) {
        cpuTType = @"qq";
        profileUrl = dic[@"figureurl_qq_2"];
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:profileUrl]];
    UIImage *image = [UIImage imageWithData:data];
    UIImage *compressimage = [self scaleToSize:image size:CGSizeMake(300, 300)];
    NSData *imagedata = UIImageJPEGRepresentation(compressimage,0.1);
    //    NSString *url = info.url;
    
    NSString *adId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (nickName != nil) {
        [params setObject:nickName forKey:@"username"];
    }
    if (cpuTType != nil) {
        [params setObject:cpuTType forKey:@"platform"];
    }
    if (uid != nil) {
        [params setObject:uid forKey:@"id"];
    }
    if (adId != nil) {
        [params setObject:adId forKey:@"imei"];
    }
    
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
//        NSString *err = result[@"err_msg"];
         NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == 0) {
            NSDictionary *dic = result[@"result"];
            OBAccount *accountModel = [OBAccount objectWithKeyValues:dic];
            accountModel.created_time = date;
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
            accountModel.imei = adId;
            [OBAccountTool saveAccount:accountModel];
            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
            if ([OBAccountTool account].icon.length == 0) {
                [self updateProfileWithProfileData:imagedata];
            } else
//                [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
            [OBNotificationCenter postNotificationName:@"DismissController" object:nil];
        } else if ([code integerValue] == -17) {
           
            OBRenameViewController *renameVC = [[OBRenameViewController alloc]init];
            renameVC.info = info;
            [self.navigationController pushViewController:renameVC animated:YES];
//            [self presentViewController:renameVC animated:YES completion:nil];
            
        }else if ([code integerValue] == -9) {
            
            NSDictionary *resultDic = result[@"result"];
            NSString *timestamp_offset = resultDic[@"timestamp_offset"];
            self.currentTimeOffset = timestamp_offset;
            [self parseDataAfterLoginWithInfo:info];
            
        }else if ([code integerValue] == - 8) {
            //token 过期
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(parseDataAfterLoginWithInfo:)];
        }else if ([code integerValue] == - 24) {
            //签名错误
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(parseDataAfterLoginWithInfo:)];
        }else{
            NSString *errSting = result[@"err_msg"];
//            [KLToast showToast:errSting];
             [MBProgressHUD showAlert:errSting];
        }
    } failedBlock:^(id error) {
        [MBProgressHUD showAlert:error];
    }];
    
    
}
- (void)updateProfileWithProfileData:(NSData *)data
{
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
    [params setObject:[self encodeBase64String:data] forKey:@"picdata"];
    [params setObject:[NSString stringWithFormat:@"%u",arc4random_uniform(100)]forKey:@"filename"];
    [OBDataService requestWithURL:OBUpdateUserIcon(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
        NSNumber *code = result[@"ret_code"];
        NSString *message = result[@"err_msg"];
        if ([code integerValue] == 0) {
            [OBAccountTool deleteAccount];
            NSString *urlString = result[@"result"][@"icon"];
            self.accountModel.icon = urlString;
            [OBAccountTool saveAccount:self.accountModel];
            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
        }else if ([code integerValue] == -18) {
            message = result[@"result"];
            [MBProgressHUD showAlert:message];
            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
        }if ([code integerValue] == - 9){
            NSDictionary *resultDic = result[@"result"];
            NSString *timestamp_offset = resultDic[@"timestamp_offset"];
            self.currentTimeOffset = timestamp_offset;
            [self updateProfileWithProfileData:data];
        }else if ([code integerValue] == - 8) {
            //token 过期
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(updateProfileWithProfileData:)];
        }else if ([code integerValue] == - 24) {
            //签名错误
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(updateProfileWithProfileData:)];
        }else
            [MBProgressHUD showAlert:message];
        
    } failedBlock:^(id error) {
//        [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
    }];
}
- (NSString*)encodeBase64String:(NSData * )data{
    //     NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:input]];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)tapAction
{
    if ([self.userNameTextField isFirstResponder]) {
        [self.userNameTextField resignFirstResponder];
    } else if ([self.passWordTextField isFirstResponder]){
        [self.passWordTextField resignFirstResponder];
    }
        
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        UIImage *image = [UIImage imageNamed:@"line_0.3"];
        image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        self.passWordBackImage.image = image;
        UIImage *image1 = [UIImage imageNamed:@"line_1"];
        image1 = [image1 stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        self.userBackImage.image = image1;
        
    } else if (textField.tag == 101) {
        UIImage *image = [UIImage imageNamed:@"line_1"];
        image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        self.passWordBackImage.image = image;
        UIImage *image1 = [UIImage imageNamed:@"line_0.3"];
        image1 = [image1 stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        self.userBackImage.image = image1;
    }
    return YES;
}
- (void)backButton:(UIButton *)button
{
    if (self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
