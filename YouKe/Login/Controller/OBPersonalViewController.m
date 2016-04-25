//
//  OBPersonalViewController.m
//  YouKe
//
//  Created by obally on 15/7/27.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBPersonalViewController.h"
#import "OBMyCenterViewController.h"
#import "OBMyCityViewController.h"
#import "OBMyCollectionViewController.h"
#import "OBMyListViewController.h"
#import "NSString+Hash.h"
#import "GTMBase64.h"
#import "OBProfileModel.h"
#import "OBMyCountModel.h"
#import "OBLoginViewController.h"
#import "OBAboutViewController.h"

@interface OBPersonalViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate> {
    MBProgressHUD *_hud;
}
@property (nonatomic, assign) BOOL  writeToSavedPhotosAlbum;
@property (nonatomic, retain) UIImagePickerController *pickerController;
@property (nonatomic, weak) UIImageView *userImage;
@property (nonatomic, weak) UIImageView *backuserImage;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak)  UIVisualEffectView *visualEffect;
@property (nonatomic, strong) OBProfileModel *profileModel;
@property (nonatomic, strong) OBMyCountModel *countModel;
@property (nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic, weak) UILabel *nameLabel;
//@property (nonatomic, weak) UILabel *cityLabel;
@property (nonatomic, weak) UILabel *birthdayLabel;
@property (nonatomic, weak) UILabel *mySummaryLabel;
@property (nonatomic, weak) UILabel *summaryLabel;
@property (nonatomic, weak) UILabel *commentCount;
@property (nonatomic, weak) UILabel *collectionCount;
@property (nonatomic, weak)  UIVisualEffectView *maskvisualEffect;
@property (nonatomic, copy) NSString *birthdayString;
@property (nonatomic, weak) UIButton *bottomButton;

@end

@implementation OBPersonalViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
    [MobClick event:@"user"];
//     [self loadData];
    
    
}
- (void)dealloc
{
    [OBNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HWColor(240, 240, 240);
    [OBNotificationCenter addObserver:self selector:@selector(statusChangedNoti:) name:@"LoginNotifiCation" object:nil];
    [OBNotificationCenter addObserver:self selector:@selector(addNewListNoti:) name:@"AddNewListNotification" object:nil];
    [self initViews];
    if ([OBAccountTool account]) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadData];
        
    }
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    CGFloat summaryHeight = KViewHeight(60);
//    CGFloat topHeight = KViewHeight(300);
    CGFloat userImageHeight = KViewHeight(100);
    CGFloat userImageTopedge = KViewHeight(90);
//    CGFloat userLabelwidth = KViewWidth(100);
    
    //整体scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight)];
    scrollView.scrollEnabled = YES;
     scrollView.showsVerticalScrollIndicator = YES;
    [self.view  addSubview:scrollView];
   
    //顶部头像、用户名、简介容器
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    [scrollView addSubview:imageView];
    self.backuserImage = imageView;
    imageView.userInteractionEnabled = YES;
    if ([OBAccountTool account].icon.length > 0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[OBAccountTool account].icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
    } else
        imageView.image = [UIImage imageNamed:@"icon_0013_head80"];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    self.visualEffect = visualEffect;
    visualEffect.frame = imageView.frame;
    visualEffect.alpha = 1.0;
    [scrollView addSubview:visualEffect];
    //头像
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.centerX - userImageHeight/2, userImageTopedge, userImageHeight, userImageHeight)];
    self.userImage = userImage;
    userImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGesture)];
    [userImage addGestureRecognizer:imageTap];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = userImage.width/2;
    userImage.backgroundColor = HWRandomColor;
    if ([OBAccountTool account].icon.length > 0) {
        [userImage sd_setImageWithURL:[NSURL URLWithString:[OBAccountTool account].icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
    } else
        userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
    [visualEffect addSubview:userImage];
    
    //用户名
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(userImage.x - KViewWidth(20), userImage.bottom + KViewHeight(10), KViewWidth(150), KViewHeight(30))];
    self.userNameLabel = userNameLabel;
    userNameLabel.centerX = userImage.centerX;
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont boldSystemFontOfSize:KFont(18.0)];
    userNameLabel.text = @"点击登录优恪";
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    if ([OBAccountTool account].name) {
        userNameLabel.text = [OBAccountTool account].name;
    }
    [visualEffect addSubview:userNameLabel];
    
    //简介
    UILabel *summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.height- summaryHeight - KViewHeight(30), kScreenWidth- 20, summaryHeight)];
    summaryLabel.centerX = userImage.centerX;
    summaryLabel.textColor = [UIColor whiteColor];
    summaryLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    summaryLabel.text = @"优恪，让购物更放心";
    summaryLabel.numberOfLines = 0;
    self.summaryLabel = summaryLabel;
    [visualEffect addSubview:summaryLabel];
    
    //评论View
    UIView *commentView = [self createSingleViewWithViewFrame:CGRectMake(0, imageView.bottom + KViewHeight(20), kScreenWidth, KViewWidth(50)) ViewName:@"我的清单" withTag:100];
    commentView.tag = 100;
    [scrollView addSubview:commentView];
    //收藏
    UIView *collectionView = [self createSingleViewWithViewFrame:CGRectMake(0, commentView.bottom, kScreenWidth, KViewHeight(50)) ViewName:@"收藏" withTag:101];
    collectionView.tag = 101;
    [scrollView addSubview:collectionView];
     OBAccount *account = [OBAccountTool account];
    //用户名
    NSString *nameString;
    if (account) {
        nameString = account.name;
    } else
        nameString = [NSString stringWithFormat:@"未登录"];
    UIView *usernameView = [self createViewWithViewFrame:CGRectMake(commentView.left, collectionView.bottom + KViewHeight(20), kScreenWidth, KViewHeight(90)) ViewName:@"用户名" subName:nameString showArrowImage:NO tag:102];
    usernameView.tag = 102;
    [scrollView addSubview:usernameView];
    //生日
    NSString *birString;
    if (account) {
        birString = [NSString stringWithFormat:@"未填写"];;
    } else
        birString = [NSString stringWithFormat:@"未填写"];
    UIView *cityView = [self createViewWithViewFrame:CGRectMake(commentView.left, usernameView.bottom, kScreenWidth, KViewHeight(90)) ViewName:@"生日" subName:birString showArrowImage:YES tag:103];
    cityView.tag = 103;
    [scrollView addSubview:cityView];
    //个人简介
    UIView *userView = [self createViewWithViewFrame:CGRectMake(commentView.left, cityView.bottom, kScreenWidth, KViewHeight(90)) ViewName:@"个人简介" subName:@"说点什么吧.." showArrowImage:YES tag:104];
    userView.tag = 104;
    [scrollView addSubview:userView];
    
    //设置
    UIButton *setUpButton = [[UIButton alloc]initWithFrame:CGRectMake(0, userView.bottom + KViewHeight(10), kScreenWidth, KViewHeight(50))];
    setUpButton.backgroundColor = [UIColor whiteColor];
    setUpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    setUpButton.contentEdgeInsets = UIEdgeInsetsMake(0,KViewWidth(10), 0, 0);
    [setUpButton setTitle:@"设置" forState:UIControlStateNormal];
    setUpButton.titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [setUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setUpButton addTarget:self action:@selector(setUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:setUpButton];
    //退出登陆
    UIButton *exitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, setUpButton.bottom + KViewHeight(20), kScreenWidth, KViewHeight(50))];
    if ([OBAccountTool account]) {
        [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    } else
         [exitButton setTitle:@"点击登录" forState:UIControlStateNormal];
    exitButton.titleLabel.font = [UIFont boldSystemFontOfSize:KFont(16.0)];
    exitButton.titleLabel.textColor =[UIColor whiteColor];
    if ([OBAccountTool account]) {
         exitButton.backgroundColor = HWColor(255, 102, 51);
    } else
        exitButton.backgroundColor = HWColor(32, 167, 85);
   
    [exitButton addTarget:self action:@selector(exitButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:exitButton];
    [scrollView setContentSize:CGSizeMake(0, exitButton.y + exitButton.height)];
    self.bottomButton = exitButton;
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KbuttonEdgeWidth, kScreenHeight - KbuttonEdgeWidth - KbuttonWidth, KbuttonWidth, KbuttonWidth)];
//    backButton.backgroundColor = HWRandomColor;
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_0001_Return48"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = backButton.width/2;
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
}

//获取用户信息
- (void)loadData
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

    [OBDataService requestWithURL:OBGetProfile(uid, timeString, sign) params:nil httpMethod:@"GET" completionblock:^(id result) {
        [_hud hide:YES];
         NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == - 9){
            NSDictionary *resultDic = result[@"result"];
            NSString *timestamp_offset = resultDic[@"timestamp_offset"];
            self.currentTimeOffset = timestamp_offset;
            [self loadData];
        }else if ([code integerValue] == - 8) {
            //token 过期
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadData)];
        }else if ([code integerValue] == - 24) {
            //签名错误
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadData)];
        }else if ([code integerValue] == 0) {
            NSArray *array = result[@"result"];
            if (array.count > 0) {
                //个人基本信息
                NSDictionary *profileDic = array[0];
                OBProfileModel *profileModel = [OBProfileModel objectWithKeyValues:profileDic];
                self.profileModel = profileModel;
                self.nameLabel.text = profileModel.name;
                self.mySummaryLabel.text = profileModel.brief;
                //设置内容的间距
                NSMutableAttributedString * attributedString =[NSString attributedStringWithText:self.mySummaryLabel.text WithLineSpace:KViewHeight(3)];
                [self.mySummaryLabel setAttributedText:attributedString];
                self.mySummaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                
                self.summaryLabel.text = profileModel.brief;
                //设置内容的间距
                NSMutableAttributedString * attributedString2 =[NSString attributedStringWithText:self.summaryLabel.text WithLineSpace:KViewHeight(6)];
                [self.summaryLabel setAttributedText:attributedString2];
                self.summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                 profileModel.brief = [profileModel.brief trim];
                if (profileModel.brief.length == 0) {
                    self.mySummaryLabel.text = @"请设置简介";
                    self.summaryLabel.text = @"优恪，更优的选择!";
                }
                self.birthdayLabel.text = profileModel.birthday;
                self.birthdayString = profileModel.birthday;
                if (profileModel.birthday.length == 0) {
                    self.birthdayLabel.text = @"请设置生日";
                }
                
                
                if (array.count > 1) {
                     NSDictionary *dic = array[1];
                    NSDictionary *countDic = dic[@"extend"];
                    OBMyCountModel *countModel = [OBMyCountModel objectWithKeyValues:countDic];
                    self.countModel = countModel;
                    self.commentCount.text = [NSString stringWithFormat:@"%ld",(long)countModel.listing_count];
                    if (countModel.collection_count == 0) {
                        self.collectionCount.text = @"0";
                    } else
                    self.collectionCount.text = [NSString stringWithFormat:@"%ld",(long)countModel.collection_count];
                    
                }
//                self.bottomButton.selected = YES;
            }
        }
    } failedBlock:^(id error) {
        [_hud hide:YES];
        [MBProgressHUD showAlert:error];
    }];
}


//只包括一行的视图
- (UIView *)createSingleViewWithViewFrame:(CGRect)frame ViewName:(NSString *)name withTag:(NSInteger)tag
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(10), KViewWidth(150), KViewHeight(30))];
    titleLabel.text = name;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [view addSubview:titleLabel];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.right - KViewHeight(50), titleLabel.top, KViewWidth(50), KViewHeight(30))];
    countLabel.tag = 1000;
    countLabel.text = @"0";
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = [UIColor blackColor];
    countLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [view addSubview:countLabel];
    if (tag == 100) {
        self.commentCount = countLabel;
    } else if (tag == 101) {
        self.collectionCount = countLabel;
    }
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(view.right - KViewHeight(50) , view.height/2 - KViewWidth(16) , KViewWidth(26), KViewHeight(26))];
    arrowImage.image = [UIImage imageNamed:@"icon_0001_right26_9.png"];
//    [view addSubview:arrowImage];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.height - 1, kScreenWidth, 1)];
    line.image = [UIImage imageNamed:@"u19_line"];
    line.backgroundColor = HWColor(242, 242, 242);
    [view addSubview:line];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:tap];
    return view;
}
//有多行的视图
- (UIView *)createViewWithViewFrame:(CGRect)frame ViewName:(NSString *)name subName:(NSString *)subName showArrowImage:(BOOL)show tag:(NSInteger)tag
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(10), KViewWidth(100), KViewHeight(30))];
    titleLabel.text = name;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [view addSubview:titleLabel];
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.x, titleLabel.bottom + KViewHeight(5), kScreenWidth - KViewWidth(100), view.height - KViewHeight(50))];
    subLabel.text = subName;
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.tag = 2000;
//    subLabel.backgroundColor = HWRandomColor;
    subLabel.textColor =HWColor(171, 160, 145);
    subLabel.font = [UIFont systemFontOfSize:KFont(12.0)];
    [view addSubview:subLabel];
    if (tag == 102) {
        self.nameLabel = subLabel;
    } else if (tag == 103) {
        self.birthdayLabel = subLabel;
    } else if (tag == 104) {
        self.mySummaryLabel = subLabel;
    }
    if (show) {
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(view.right - KViewWidth(50) , view.height/2 - KViewHeight(16) , KViewWidth(26), KViewHeight(26))];
        arrowImage.image = [UIImage imageNamed:@"icon_0001_right26_9.png"];
        [view addSubview:arrowImage];

    }
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.height - 1, kScreenWidth, 1)];
    line.backgroundColor = HWColor(242, 242, 242);
    [view addSubview:line];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)exitButton:(UIButton *)button
{
    if ([OBAccountTool account]) {
        //退出登录
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定退出" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    } else {
        //登录
        OBLoginViewController *loginVc = [[OBLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
    
    
}
//修改头像
- (void)imageTapGesture
{
    OBAccount *account = [OBAccountTool account];
    if (account) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"打开相机" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开相册" otherButtonTitles:@"打开相机", nil];
        [sheet showInView:self.view];
    } else {
        //去登录
        OBLoginViewController *loginVc = [[OBLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
    
}
- (void)setUpButton:(UIButton *)button
{
    OBAccount *account = [OBAccountTool account];
    if (account) {
        OBAboutViewController *aboutVC = [[OBAboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    } else {
        //去登录
        OBLoginViewController *loginVc = [[OBLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}
//返回
- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

//修改个人信息
- (void)tapGesture:(UITapGestureRecognizer *)reg
{
    NSLog(@"%ld",reg.view.tag);
    if ([OBAccountTool account]) {
        if (reg.view.tag == 100) {
            //清单
            OBMyListViewController *commentVC = [[OBMyListViewController alloc]init];
            [self.navigationController pushViewController:commentVC animated:YES];
            //        [self presentViewController:commentVC animated:YES completion:nil];
            
        } else if (reg.view.tag == 101) {
            //收藏
            OBMyCollectionViewController *commentVC = [[OBMyCollectionViewController alloc]init];
            [self.navigationController pushViewController:commentVC animated:YES];
            //        [self presentViewController:commentVC animated:YES completion:nil];
            
        }else if (reg.view.tag == 103) {
            CGPoint point = [reg locationInView:self.view];
            UIView *maskView = [[UIView alloc]initWithFrame:self.view.frame];
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
            self.visualEffect = visualEffect;
            visualEffect.frame = maskView.frame;
            visualEffect.alpha = 0.7;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(visualEffectTapAction)];
            [visualEffect addGestureRecognizer:tap];
            //生日
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(KViewWidth(20), point.y - KViewHeight(100), kScreenWidth - KViewWidth(40), KViewHeight(250))];
            datePicker.datePickerMode = UIDatePickerModeDate;
            //定义最小日期
            NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
            [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
            NSDate *minDate = [formatter_minDate dateFromString:@"1900-01-01"];
            
            //最大日期是今天
            NSDate *maxDate = [NSDate date];
            [datePicker setMinimumDate:minDate];
            [datePicker setMaximumDate:maxDate];
            [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
            // [self.birthdayString stringByReplacingOccurrencesOfString:@"-" withString:@""]
            NSString* string =[self.birthdayString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            //        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [inputFormatter setDateFormat:@"yyyyMdd"];
            if (string.length> 7) {
                [inputFormatter setDateFormat:@"yyyyMMdd"];
            }
            
            NSDate* inputDate = [inputFormatter dateFromString:string];
            if (inputDate) {
                [datePicker setDate:inputDate];
            }
            
            [self.view addSubview:datePicker];
            [visualEffect addSubview:datePicker];
            [self.view addSubview:visualEffect];
            self.maskvisualEffect = visualEffect;
            
            
        }else if (reg.view.tag == 104) {
            //个人简介
            OBMyCenterViewController *commentVC = [[OBMyCenterViewController alloc]init];
            self.profileModel.brief = [self.profileModel.brief trim];
            if (self.profileModel.brief.length > 0) {
                commentVC.summary = self.mySummaryLabel.text;
            }
            
            
            commentVC.summaryBlock =  ^(NSString *summary){
                summary = [summary trim];
                self.profileModel.brief = summary;
                self.summaryLabel.text = summary;
                self.mySummaryLabel.text =summary;
                if (summary.length == 0) {
                    self.summaryLabel.text = @"优恪，更优的选择!";
                    self.mySummaryLabel.text = @"请设置简介";
                }
                
                
            };
            [self.navigationController pushViewController:commentVC animated:YES];
            //        [self presentViewController:commentVC animated:YES completion:nil];
        }

    } else if(reg.view.tag != 102 && ![OBAccountTool account]) {
        //去登录
        OBLoginViewController *loginVc = [[OBLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
    
}
- (void)visualEffectTapAction
{
    if (self.birthdayString) {
        [self saveBirthdayWithDate:self.birthdayString];
    }
    
    [self.maskvisualEffect removeFromSuperview];
}

- (void) dataValueChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:date_one];
    self.birthdayLabel.text = time;
//    self.profileModel.birthday = time;
    self.birthdayString = time;
    
}
- (void)saveBirthdayWithDate:(NSString *)date
{
    NSString *token = nil;
    NSString *uid = nil;
    if ([OBAccountTool account]) {
        OBAccount *model = [OBAccountTool account];
        token = model.token;
        uid = model.uid;
    }
//    NSTimeInterval birthdayInterval =[date timeIntervalSince1970] ;
//    NSString *birthdayString = [NSString stringWithFormat:@"%d",(int)birthdayInterval];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval =[currentDate timeIntervalSince1970] ;
    NSString *timeString = [NSString stringWithFormat:@"%d",(int)timeInterval];
    if (self.currentTimeOffset) {
        NSInteger timeoffset = [self.currentTimeOffset intValue];
        NSInteger current = timeInterval + timeoffset;
        timeString = [NSString stringWithFormat:@"%ld",current];
    }
    NSString *sign = [[NSString stringWithFormat:@"%@%@%@",uid,timeString,token]md5String];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"birthday"];
    [OBDataService requestWithURL:OBUpdateProfile(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
        NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == - 9){
            NSDictionary *resultDic = result[@"result"];
            NSString *timestamp_offset = resultDic[@"timestamp_offset"];
            self.currentTimeOffset = timestamp_offset;
            [self saveBirthdayWithDate:date];
        }else if ([code integerValue] == 0) {
            
        }else if ([code integerValue] == - 8) {
            //token 过期
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(saveBirthdayWithDate:)];
        }else if ([code integerValue] == - 24) {
            //签名错误
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(saveBirthdayWithDate:)];
        }
    } failedBlock:^(id error) {
        [MBProgressHUD showAlert:error];
    }];

    
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    OBLog(@"buttonIndex = %ld",(long)buttonIndex);
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex != 2) {
        if (buttonIndex == 0) {
            //打开相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if (buttonIndex == 1) {
            //打开相机
            sourceType = UIImagePickerControllerSourceTypeCamera;
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            self.writeToSavedPhotosAlbum = YES;
            if (!isCamera) {
                //提示无摄像头
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
        }
        self.pickerController = [[UIImagePickerController alloc]init];
        self.pickerController.delegate = self;
        self.pickerController.sourceType = sourceType;
//        [self.navigationController pushViewController:self.pickerController animated:YES];
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }else {
        return;
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    self.changeUserPic = YES;
    OBLog(@"info:%@",info);
    picker.allowsEditing = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.writeToSavedPhotosAlbum) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    self.userImage.image = image;
    self.backuserImage.image = image;
    self.visualEffect.frame = self.backuserImage.frame;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = self.userImage.bounds;
    [indicatorView startAnimating];
    self.indicatorView = indicatorView;
    [self.userImage addSubview:indicatorView];
    
    NSData *data;
//    float big = 0.3;
    UIImage *compressimage =  [self scaleToSize:image size:CGSizeMake(300, 300)];

    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(compressimage, 1.0);
    }else {
        data = UIImageJPEGRepresentation(compressimage,0.1);
    }
//    NSData *data = [NSData]
    [self updateProfileWithProfileData:data];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        if ([result[@"err_msg"] isEqualToString:@"ok"] && [code integerValue] == 0) {
            [self.indicatorView stopAnimating];
            [self.indicatorView removeFromSuperview];
            OBAccount *accountModel = [OBAccountTool account];
            [OBAccountTool deleteAccount];
            NSString *urlString = result[@"result"][@"icon"];
            accountModel.icon = urlString;
            [OBAccountTool saveAccount:accountModel];
//            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
        } else if ([code integerValue] == - 18) {
            [self.indicatorView stopAnimating];
            [self.indicatorView removeFromSuperview];
            [MBProgressHUD showAlert:@"头像过大"];
//            [KLToast showToast:@"头像过大"];
        } else if ([code integerValue] == - 9) {
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
        }
        
    } failedBlock:^(id error) {
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
//        [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
    }];
}

- (NSString*)encodeBase64String:(NSData * )data {
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:input]];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //
    }else if (buttonIndex == 1) {
        //  确定退出
        [[OBManager sessionManager]logout];
        self.backuserImage.image = [UIImage imageNamed:@"icon_0013_head80"];
        self.userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
        self.userNameLabel.text = @"点击登录忧恪";
        self.summaryLabel.text = @"优恪，让购物更放心";
        self.commentCount.text = @"0";
        self.collectionCount.text = @"0";
        self.nameLabel.text = @"未登录";
        self.birthdayLabel.text = @"未填写";
        self.mySummaryLabel.text = @"说点什么吧..";
        [self.bottomButton setTitle:@"点击登录" forState:UIControlStateNormal];
         self.bottomButton.backgroundColor = HWColor(32, 167, 85);
//        [OBNotificationCenter postNotificationName:@"LogoutNotifiCation" object:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)statusChangedNoti:(NSNotification *)noti
{
    if ([noti.name isEqualToString:@"LogoutNotifiCation"]) {
        self.backuserImage.image = [UIImage imageNamed:@"icon_0013_head80"];
        self.userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
        self.userNameLabel.text = @"点击登录忧恪";
        self.summaryLabel.text = @"优恪，让购物更放心";
        self.commentCount.text = @"0";
        self.collectionCount.text = @"0";
        self.nameLabel.text = @"未登录";
        self.birthdayLabel.text = @"未填写";
        self.mySummaryLabel.text = @"说点什么吧..";
        [self.bottomButton setTitle:@"点击登录" forState:UIControlStateNormal];
        self.bottomButton.backgroundColor = HWColor(32, 167, 85);
    } else if ([noti.name isEqualToString:@"LoginNotifiCation"]) {
        OBAccount *account = [OBAccountTool account];
        if (account) {
            [self.backuserImage sd_setImageWithURL:[NSURL URLWithString:account.icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
            [self.userImage sd_setImageWithURL:[NSURL URLWithString:account.icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
//            self.userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
            self.userNameLabel.text = account.name;
            self.summaryLabel.text = @"优恪，让购物更放心";
            self.commentCount.text = @"0";
            self.collectionCount.text = @"0";
            self.nameLabel.text = account.name;
            self.birthdayLabel.text = @"未填写";
            self.mySummaryLabel.text = @"说点什么吧..";
            [self.bottomButton setTitle:@"退出登录" forState:UIControlStateNormal];
            self.bottomButton.backgroundColor = HWColor(255, 102, 51);
            //加载个人信息
            [self loadData];
            
        }
        
    }

}
- (void)addNewListNoti:(NSNotification *)noti
{
    if (self.commentCount) {
        self.commentCount.text = [NSString stringWithFormat:@"%ld",[self.commentCount.text integerValue] + 1];
    }
}
@end
