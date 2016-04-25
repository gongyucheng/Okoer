//
//  OBNewListViewController.m
//  YouKe
//
//  Created by obally on 16/1/6.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBNewListViewController.h"
#import "OBSingleColorView.h"
#import "NSString+Hash.h"
#import "OBMyListModel.h"
#import "HWTextView.h"
@interface OBNewListViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property(nonatomic,copy)NSString *currentTimeOffset;
//@property (nonatomic, weak) UITextField *nameTextF;
@property (nonatomic, weak) HWTextView *detailTextF;
@property (nonatomic, weak) HWTextView *nameTextF;
@property (nonatomic, weak) UILabel *grayLabel1;
@property (nonatomic, weak) UIButton *saveButton;
@end

@implementation OBNewListViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    //收起键盘
    [self setUpForDismissKeyboard];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
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
    [backButton setBackgroundImage:[UIImage imageNamed:@"u215"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:backButton];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(15), KViewWidth(200), KViewHeight(40))];
    titleLabel.textColor = HWColor(31, 167, 86);
    titleLabel.font = [UIFont systemFontOfSize:KFont(17.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新建清单";
    [self.view addSubview:titleLabel];
    //名称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(20), KViewHeight(65), KViewWidth(40), KViewHeight(60))];
    nameLabel.textColor = HWColor(130, 130, 130);
    nameLabel.font = [UIFont systemFontOfSize:KFont(17.0)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"名称";
    [self.view addSubview:nameLabel];
  
    //必填
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, KViewWidth(60), nameLabel.height)];
    nameLabel1.textColor = HWColor(167, 167, 167);
    nameLabel1.font = [UIFont systemFontOfSize:KFont(13.0)];
    nameLabel1.textAlignment = NSTextAlignmentLeft;
    nameLabel1.text = @"(必填):";
    [self.view addSubview:nameLabel1];
    //名称UITextField
    HWTextView *nameTextF = [[HWTextView alloc]initWithFrame:CGRectMake(nameLabel1.right, nameLabel.top + KViewHeight(12), kScreenWidth - nameLabel1.right, KViewHeight(40))];
    self.nameTextF = nameTextF;
    nameTextF.font = [UIFont systemFontOfSize:KFont(13.0)];
    nameTextF.placeholder = @"请输入清单名称";
    nameTextF.placeholderColor = HWColor(212, 212, 212);
    [self.view addSubview:nameTextF];
    nameTextF.tag = 200;
    nameTextF.delegate = self;
    UILabel *grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,nameLabel.bottom, kScreenWidth, KViewHeight(1))];
    grayLabel.backgroundColor = HWColor(240, 240, 240);
    [self.view addSubview:grayLabel];
    //备注
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, KViewWidth(40), nameLabel.height)];
    detailLabel.textColor = HWColor(130, 130, 130);
    detailLabel.font = [UIFont systemFontOfSize:KFont(17.0)];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text = @"备注";
    [self.view addSubview:detailLabel];
    //选填
    UILabel *detailLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(detailLabel.right, detailLabel.top, KViewWidth(60), nameLabel.height)];
    detailLabel1.textColor = HWColor(167, 167, 167);
    detailLabel1.font = [UIFont systemFontOfSize:KFont(13.0)];
    detailLabel1.textAlignment = NSTextAlignmentLeft;
    detailLabel1.text = @"(选填):";
//    detailLabel1.backgroundColor = HWRandomColor;
    [self.view addSubview:detailLabel1];
    //备注UITextField
    HWTextView *detailTextF = [[HWTextView alloc]initWithFrame:CGRectMake(detailLabel1.right, detailLabel.top + KViewHeight(12), kScreenWidth - detailLabel1.right, KViewHeight(40))];
//     detailTextF.backgroundColor = HWRandomColor;
    self.detailTextF = detailTextF;
    detailTextF.tag = 201;
    detailTextF.font = [UIFont systemFontOfSize:KFont(13.0)];
    detailTextF.placeholder = @"请输入清单备注";
    detailTextF.placeholderColor = HWColor(212, 212, 212);
    [self.view addSubview:detailTextF];
    detailTextF.delegate = self;
    UILabel *grayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0,detailLabel.bottom, kScreenWidth, KViewHeight(1))];
    grayLabel1.backgroundColor = HWColor(240, 240, 240);
    [self.view addSubview:grayLabel1];
    self.grayLabel1 = grayLabel1;
    //创建按钮
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(10),detailLabel.bottom + KViewHeight(30), kScreenWidth - KViewWidth(10) * 2, KViewHeight(40))];
    [saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [saveButton setBackgroundColor:HWColor(30, 167, 86)];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 6;
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton = saveButton;
    [self.view addSubview:saveButton];
    
}
- (void)saveButtonAction
{
    if ([self.nameTextF.text trim].length == 0) {
        [MBProgressHUD showAlert:@"请输入清单名称"];
    }else if ([self.nameTextF.text trim].length > 18) {
        [MBProgressHUD showAlert:@"清单名称超过最大字数15"];
    }else if ([self.detailTextF.text trim].length > 128) {
        [MBProgressHUD showAlert:@"清单描述超过最大字数128"];
    } else {
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
            [params setObject:self.nameTextF.text forKey:@"name"];
            if ([self.detailTextF.text trim].length == 0) {
                self.detailTextF.text = @"";
            }
            [params setObject:[self.detailTextF.text trim] forKey:@"desc"];
            [OBDataService requestWithURL:OBCreateListUrl(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                
                NSNumber *code = result[@"ret_code"];
                NSString *message = result[@"err_msg"];
                if ([code integerValue] == 0) {
                    [MBProgressHUD showAlert:@"创建成功"];
                    OBMyListModel *model = [OBMyListModel objectWithKeyValues:result[@"data"]];
                    if (self.successAddBlock) {
                        self.successAddBlock(model);
                    }
                    [OBNotificationCenter postNotificationName:@"AddNewListNotification" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([code integerValue] == -18) {
                    message = result[@"result"];
                    [MBProgressHUD showAlert:message];
                } else if ([code integerValue] == - 9){
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self saveButtonAction];
                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(saveButtonAction)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(saveButtonAction)];
                }else if ([code integerValue] == - 26) {
                    //签名错误
                    [MBProgressHUD showAlert:@"该清单已存在"];
                }else if ([code integerValue] == - 99) {
                    
                    [MBProgressHUD showAlert:@"暂不支持输入表情"];
                }
                
            } failedBlock:^(id error) {
                [MBProgressHUD showAlert:error];
            }];
            
        }

    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 200) {
        if ([textView.text trim].length >15) {
            [MBProgressHUD showAlert:@"清单名称超过最大字数15"];
            textView.text = [[textView.text trim] substringToIndex:15];
            
        }
    } else if (textView.tag == 201) {
        if ([textView.text trim].length >128) {
            [MBProgressHUD showAlert:@"清单描述超过最大字数128"];
            textView.text = [[textView.text trim] substringToIndex:128];
            
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = KViewHeight(6);// 字体的行间距
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:KFont(13.0)],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        CGRect origin = textView.frame;
        CGSize  textSize = [textView.text boundingRectWithSize:CGSizeMake(self.detailTextF.width, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        origin.size.height= textSize.height + KViewHeight(15);
        textView.frame = origin;
//        textView.backgroundColor = HWRandomColor;
        self.grayLabel1.top = textView.bottom + KViewHeight(5);
        self.saveButton.top = self.grayLabel1.bottom + KViewHeight(10);
    }
    
//    self.saveButton.top = self.backImage.bottom + KViewHeight(20);
    
}
#pragma mark - backAction
- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
