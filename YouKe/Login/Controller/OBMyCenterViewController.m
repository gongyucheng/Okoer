//
//  OBMyCenterViewController.m
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBMyCenterViewController.h"
#import "OBSingleColorView.h"
#import "HWTextView.h"
#import "NSString+Hash.h"

@interface OBMyCenterViewController ()<UITextViewDelegate>
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) HWTextView *textField;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) UIImageView *backImage;
@property (nonatomic, retain) UIButton *saveButton;
@end

@implementation OBMyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chattapAction)];
    //为imageView添加手势
    [self.view addGestureRecognizer:tap];
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
    titleLabel.font = [UIFont systemFontOfSize:KFont(17.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"个人简介";
    [visualEffect addSubview:titleLabel];
    
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(100), kScreenWidth - KViewWidth(20), KViewHeight(30))];
    //    contentLabel.backgroundColor = HWRandomColor;
    tipLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"个人简介";
    [self.view addSubview:tipLabel];
    
    HWTextView *replyField = [[HWTextView alloc]initWithFrame:CGRectMake(KViewWidth(10), tipLabel.bottom + 20, kScreenWidth - KViewWidth(20), KViewHeight(50))];
//    replyField.placeholder = [OBAccountTool account].name;
    replyField.font = [UIFont systemFontOfSize:KFont(13.0)];
    replyField.backgroundColor = [UIColor clearColor];
    replyField.keyboardType = UIKeyboardAppearanceDefault;
    replyField.returnKeyType = UIReturnKeyDone;
    self.textField = replyField;
    replyField.delegate = self;
//    replyField.backgroundColor = HWRandomColor;
    replyField.delegate = self;
    replyField.text = self.summary;
    NSString *string = self.summary ;
    if (self.summary.length == 0) {
        replyField.placeholder = @"请设置简介";
        string = @"请设置简介";
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = KViewHeight(6);// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:KFont(13.0)],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    if (self.summary.length != 0) {
        replyField.attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    }
    
    //设置内容的间距
    CGRect origin = replyField.frame;
    CGRect textSize = [string boundingRectWithSize:CGSizeMake(kScreenWidth - KViewWidth(10) * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(13.0)]} context:nil];
    origin.size.height= textSize.size.height + KViewHeight(20);
    replyField.frame = origin;
    
    [self.view addSubview:replyField];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(replyField.left, replyField.bottom - KViewHeight(5),replyField.width, KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"line_ash"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    backImage.userInteractionEnabled = YES;
    self.backImage = backImage;
    [self.view addSubview:backImage];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(replyField.left,backImage.bottom + KViewHeight(20), kScreenWidth - KViewWidth(10) * 2, KViewHeight(40))];
    [saveButton setTitle:@"保 存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [saveButton setBackgroundColor:HWColor(30, 167, 86)];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 6;
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton = saveButton;
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
//    self.textField.text = [self.textField.text trim];
    if (self.textField.text.length == 0) {
        self.textField.text = @" ";
    }
    if (self.textField.text.length <= 50) {
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
        [params setObject:self.textField.text forKey:@"brief"];
        [OBDataService requestWithURL:OBUpdateProfile(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
            NSNumber *code = result[@"ret_code"];
            if ([code integerValue] == - 9){
                NSDictionary *resultDic = result[@"result"];
                NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                self.currentTimeOffset = timestamp_offset;
                [self saveButtonAction];
            }else if ([code integerValue] == 0) {
                [self dismissViewControllerAnimated:YES completion:nil];
                self.summaryBlock(self.textField.text);
            }else if ([code integerValue] == - 99) {
                [MBProgressHUD showAlert:@"暂不支持输入表情"];
            }else if ([code integerValue] == - 11) {
                [MBProgressHUD showAlert:@"此用户不存在"];
            }else if ([code integerValue] == - 8) {
                //token 过期
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(saveButtonAction)];
            }else if ([code integerValue] == - 24) {
                //签名错误
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(saveButtonAction)];
            }
            
        } failedBlock:^(id error) {
            [MBProgressHUD showAlert:error];
        }];
        
       
    } else if (self.textField.text.length > 50) {
        [MBProgressHUD showAlert:@"超过最大字数50"];
    }
    
   
}
- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textViewDidChange:(UITextView *)textView

{
    if (textView.text.length > 50) {
        [MBProgressHUD showAlert:@"超过最大字数50"];
        textView.text = [textView.text substringToIndex:50];
        
    }
    CGRect origin = textView.frame;
    CGSize  textSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:KFont(13.0)] constrainedToSize:CGSizeMake(kScreenWidth - KViewWidth(10) * 2, 2000) lineBreakMode:UILineBreakModeWordWrap];
    origin.size.height= textSize.height + KViewHeight(15);
    textView.frame = origin;
    self.backImage.top = textView.bottom - KViewHeight(5);
    self.saveButton.top = self.backImage.bottom + KViewHeight(20);
    
}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
////    UIImage *image1 = [UIImage imageNamed:@"line_1"];
////    image1 = [image1 stretchableImageWithLeftCapWidth:5 topCapHeight:5];
////    self.backImage.image = image1;
////    return YES;
//}
@end
