//
//  OBJuBaoViewController.m
//  YouKe
//
//  Created by obally on 15/8/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBJuBaoViewController.h"
#import "OBSingleColorView.h"
#import "NSString+Hash.h"
#import "HWTextView.h"
#import "OBOKOerLoginViewController.h"

@interface OBJuBaoViewController ()<UITextViewDelegate>{
    MBProgressHUD *_hud;
}
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) UIImageView *backImage;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) HWTextView *textField;
@end

@implementation OBJuBaoViewController

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
    titleLabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"举报";
    [visualEffect addSubview:titleLabel];
    
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(100), kScreenWidth - KViewWidth(20), KViewHeight(30))];
    //    contentLabel.backgroundColor = HWRandomColor;
    tipLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"举报原因";
    [self.view addSubview:tipLabel];
    
    HWTextView *replyField = [[HWTextView alloc]initWithFrame:CGRectMake(KViewWidth(10), tipLabel.bottom + 20, kScreenWidth - KViewWidth(20), KViewHeight(50))];
    //    replyField.placeholder = [OBAccountTool account].name;
    replyField.font = [UIFont systemFontOfSize:KFont(13.0)];
    replyField.backgroundColor = [UIColor clearColor];
    replyField.keyboardType = UIKeyboardAppearanceDefault;
    replyField.returnKeyType = UIReturnKeyDone;
    self.textField = replyField;
    //    replyField.backgroundColor = HWRandomColor;
    replyField.delegate = self;
    replyField.placeholder = @"请填写举报原因";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = KViewHeight(6);// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:KFont(13.0)],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    replyField.attributedText = [[NSAttributedString alloc] initWithString:self.textField.text attributes:attributes];
    //设置内容的间距
    CGRect origin = replyField.frame;
    CGRect textSize = [replyField.text boundingRectWithSize:CGSizeMake(kScreenWidth - KViewWidth(10) * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(13.0)]} context:nil];
    origin.size.height= textSize.size.height + KViewHeight(15);
    replyField.frame = origin;
    
    [self.view addSubview:replyField];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(replyField.left, replyField.bottom - KViewHeight(5),replyField.width, KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"line_ash"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    backImage.userInteractionEnabled = YES;
    self.backImage = backImage;
    [self.view addSubview:backImage];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(replyField.left,backImage.bottom + KViewHeight(20), kScreenWidth - KViewWidth(10) * 2, KViewHeight(50))];
    [saveButton setTitle:@"发 送" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:KFont(18.0)];
    [saveButton setBackgroundColor:HWColor(30, 167, 86)];
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
    if ([OBManager sessionManager].status == OBSessionStatusLogin) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        
        [params setObject:self.textField.text forKey:@"content"];
        [params setObject:[NSString stringWithFormat:@"%ld",self.cid] forKey:@"cid"];
         [OBDataService requestWithURL:OBJuBaoUrl(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
             [_hud hide:YES];
             NSNumber *code = result[@"ret_code"];
             if ([code integerValue] == 0) {
                 [MBProgressHUD showAlert:@"举报成功"];
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             
         } failedBlock:^(id error) {
             [_hud hide:YES];
             [MBProgressHUD showAlert:error];
         }];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
    } else
    {
        OBOKOerLoginViewController *login = [[OBOKOerLoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
   
    
    
}

-(void)textViewDidChange:(UITextView *)textView

{
    if (textView.text.length > 50) {
        [MBProgressHUD showAlert:@"超过最大字数50"];
        textView.text = [textView.text substringToIndex:50];
        
    }
    CGRect origin = textView.frame;
    //    CGRect textSize = [textView.text boundingRectWithSize:CGSizeMake(kScreenWidth - KViewWidth(10) * 2, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(13.0)]} context:nil];
    CGSize  textSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:KFont(13.0)] constrainedToSize:CGSizeMake(kScreenWidth - KViewWidth(10) * 2, 2000) lineBreakMode:UILineBreakModeWordWrap];
    origin.size.height= textSize.height + KViewHeight(15);
    textView.frame = origin;
    self.backImage.top = textView.bottom - KViewHeight(5);
    self.saveButton.top = self.backImage.bottom + KViewHeight(20);
    
}

- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}


@end
