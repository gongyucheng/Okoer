//
//  OBLoginViewController.m
//  YouKe
//
//  Created by obally on 15/7/27.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBLoginViewController.h"
#import "OBOKOerLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "NSString+Hash.h"
#import "OBRenameViewController.h"
#import "GTMBase64.h"
//#import "MBProgressHUD+FTCExtension.h"

@interface OBLoginViewController ()
@property (nonatomic, retain) OBOKOerLoginViewController *okoer;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) OBAccount *accountModel;
@end

@implementation OBLoginViewController
- (void)dealloc
{
    [OBNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"backGound.jpg"];
    [self initViews];
    [OBNotificationCenter addObserver:self selector:@selector(backButton) name:@"DismissController" object:nil];
    self.view.backgroundColor = HWRandomColor;
    // Do any additional setup after loading the view.
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
//    NSArray *array = @[@"Weibo",@"QQ",@"OKOer"];
    NSArray *colorArray = @[@"icon_0017_sina48",@"icon_0012_qq48",@"icon_0000_okoer48"];
    CGFloat buttonWidth = KViewWidth(60);
    CGFloat buttonEdge = KViewWidth(30);
    CGFloat leftEdge = (kScreenWidth - buttonWidth * colorArray.count - buttonEdge * (colorArray.count - 1))/2;
    CGFloat topEdge =  kScreenHeight - KViewHeight(260);
    for (int i = 0; i < colorArray.count; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(leftEdge +i * (buttonWidth + buttonEdge), topEdge, buttonWidth, buttonWidth)];
        button.layer.cornerRadius = buttonWidth/2;
        button.tag = i + 200;
        [button addTarget:self action:@selector(didSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitle:array[i] forState: UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:colorArray[i]] forState:UIControlStateNormal];
       [self performSelector:@selector(delayShowButtonWithButton:) withObject:button afterDelay:0.5 + i * 0.3];
    
    }
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KbuttonEdgeWidth, kScreenHeight - KbuttonEdgeWidth - KbuttonWidth, KbuttonWidth, KbuttonWidth)];
    //    backButton.backgroundColor = HWRandomColor;
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_0001_Return48"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = backButton.width/2;
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)delayShowButtonWithButton:(UIButton *)button
{
    CGRect frame = button.frame;
    [UIView animateKeyframesWithDuration:0.5 delay:0.5 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        button.alpha = 0;
        button.frame = CGRectZero;
    } completion:^(BOOL finished) {
        button.alpha = 1;
        button.frame = frame;
        [self.view addSubview:button];
    }];
    
}
- (void)didSelectedButton:(UIButton *)button
{
    if (button.tag == 200) {
        //微博登录
        OBLog(@"微博登录");
        [MobClick event:@"reguser_weibo"];
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                          authOptions:nil
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   if (result) {
                                       [self parseDataAfterLoginWithInfo:userInfo];
                                   }else {
                                       [MBProgressHUD showAlert:@"登录失败"];

//                                       [KLToast showToast:[error debugDescription]];
                                       
                                   }
                                   
                               }];
        
    } else if (button.tag == 201) {
        //QQ登录
         OBLog(@"QQ登录");
        [MobClick event:@"reguser_qq"];
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
        [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                          authOptions:nil
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   if (result) {
                                       [self parseDataAfterLoginWithInfo:userInfo];
                                   }else {
                                       [MBProgressHUD showAlert:@"登录失败"];
                                       
                                   }
                                   
                               }];
    }else if (button.tag == 202) {
        //OKOer登录
         OBLog(@"OKOer登录");
        [MobClick event:@"reguser_okoer"];
        OBOKOerLoginViewController *OKOerVC = [[OBOKOerLoginViewController alloc]init];
        OKOerVC.isNormalLogin = YES;
        [self presentViewController:OKOerVC animated:YES completion:nil];
    }
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
//    NSString *profileUrl = info.profileImage;
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
        NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == 0) {
            NSDictionary *dic = result[@"result"];
            OBAccount *accountModel = [OBAccount objectWithKeyValues:dic];
            if (type == 1) {
                accountModel.isSinaLogin = YES;
                accountModel.isQQLogin = NO;
                accountModel.isOKerLogin = NO;
            } else if (type == 6) {
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
            self.accountModel = accountModel;
//            self.accountModel.name = nickName;
            [OBAccountTool saveAccount:accountModel];
            accountModel.created_time = date;
            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
           
            if ([OBAccountTool account].icon.length == 0) {
                [self updateProfileWithProfileData:imagedata];
            } else
//             [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
            
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self dismissViewControllerAnimated:NO completion:nil];
            }

        } else if ([code integerValue] == -17) {
//            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
//            NSNumber *code = result[@"ret_code"];
            //用户名已存在  去修改用户名
            OBRenameViewController *renameVC = [[OBRenameViewController alloc]init];
            renameVC.info = info;
            [self.navigationController pushViewController:renameVC animated:YES];
//            [self presentViewController:renameVC animated:YES completion:nil];
        }else if ([code integerValue] == - 9){
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
            [MBProgressHUD showAlert:errSting];

//            [KLToast showToast:errSting];
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
//            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
        }else if ([code integerValue] == -18) {
            message = result[@"result"];
           [MBProgressHUD showAlert:message];
//            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
        } else if ([code integerValue] == - 9){
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
        } else
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

- (void)backButton
{
    if (self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
