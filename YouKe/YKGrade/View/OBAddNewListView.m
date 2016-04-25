//
//  OBAddNewListView.m
//  YouKe
//
//  Created by obally on 16/1/6.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBAddNewListView.h"
#import "NSString+Hash.h"
#import "HWTextView.h"
#import "OBMyListModel.h"
@interface OBAddNewListView ()
@property (nonatomic, weak) UITextField *nameTextF;
@property(nonatomic,copy)NSString *currentTimeOffset;
@end

@implementation OBAddNewListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewsWithFrame:frame];
        //点击屏幕的任何位置收起键盘
        [self setUpForDismissKeyboard];
        
    }
    return self;
}
-(void)initViewsWithFrame:(CGRect)rect
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    [self addSubview:visualEffect];
    visualEffect.frame = rect;
    //名称UITextField
    UITextField *nameTextF = [[UITextField alloc]initWithFrame:CGRectMake(KViewWidth(15), KViewHeight(80), kScreenWidth - KViewWidth(15) * 2, KViewHeight(30))];
    self.nameTextF = nameTextF;
    nameTextF.textColor = [UIColor whiteColor];
    // 文字改变的通知
    [OBNotificationCenter addObserver:self selector:@selector(searchTextDidChange) name:UITextFieldTextDidChangeNotification object:nameTextF];
//    nameTextF.placeholder = @"请输入清单名称";
    nameTextF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入清单名称" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]}];
    
//    [nameTextF setValue:[UIColor whiteColor] forKey:@"_placeholderLabel.textColor"];
    [visualEffect addSubview:nameTextF];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(nameTextF.left - KViewWidth(4), nameTextF.bottom - KViewHeight(10), nameTextF.width + KViewWidth(8), KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"line_0.3"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    [visualEffect addSubview:backImage];
    
    //确定
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(nameTextF.left, nameTextF.bottom + KViewHeight(20), kScreenWidth - KViewWidth(15) *2, KViewHeight(35))];
    [sureButton setTitle:@"创建" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    sureButton.backgroundColor = HWColor(31, 167, 86);
    sureButton.layer.cornerRadius = 6;
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:sureButton];
    
    //创建清单
    UIButton *createButton = [[UIButton alloc]initWithFrame:CGRectMake(sureButton.left, sureButton.bottom + KViewHeight(10), sureButton.width, KViewHeight(35))];
    [createButton setTitle:@"返回" forState:UIControlStateNormal];
    createButton.backgroundColor = HWColor(51, 51, 51);
    [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [createButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    createButton.layer.cornerRadius = 6;
    createButton.layer.masksToBounds = YES;
    [visualEffect addSubview:createButton];
    
}
- (void)sureButton
{
    if ([self.nameTextF.text trim].length == 0) {
        [MBProgressHUD showAlert:@"请输入清单名称"];
    } else if ([self.nameTextF.text trim].length > 15) {
        [MBProgressHUD showAlert:@"清单名称超过最大字数15"];
    }else {
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
            [params setObject:[self.nameTextF.text trim] forKey:@"name"];
            [params setObject:@"" forKey:@"desc"];
            [OBDataService requestWithURL:OBCreateListUrl(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                
                NSNumber *code = result[@"ret_code"];
                NSString *message = result[@"err_msg"];
                if ([code integerValue] == 0) {
                    [MBProgressHUD showAlert:@"创建成功"];
                    OBMyListModel *model = [OBMyListModel objectWithKeyValues:result[@"data"]];
                    if (self.addSuccessBlock) {
                        self.addSuccessBlock(model);
                    }
                    [OBNotificationCenter postNotificationName:@"AddNewListNotification" object:nil];
                    [self removeFromSuperview];
                }else if ([code integerValue] == -18) {
                    message = result[@"result"];
                    [MBProgressHUD showAlert:message];
                } else if ([code integerValue] == - 9){
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self sureButton];
                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(sureButton)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(sureButton)];
                }else if ([code integerValue] == - 26) {
                    [MBProgressHUD showAlert:@"清单已存在"];
                }else if ([code integerValue] == - 99) {
                    
                    [MBProgressHUD showAlert:@"暂不支持输入表情"];
                }
                
            } failedBlock:^(id error) {
                [MBProgressHUD showAlert:error];
            }];
            
        }
        
    }
}
- (void)backButton
{
    [self removeFromSuperview];
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
                    [self addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
}
#pragma mark - searchField Action
/**
 * 监听文字改变
 */
- (void)searchTextDidChange
{
    if ([self.nameTextF.text trim].length > 15) {
        self.nameTextF.text = [[self.nameTextF.text trim] substringToIndex:15];
        [MBProgressHUD showAlert:@"清单名称超过最大字数15"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([toBeString trim].length > 15 ) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text trim].length > 15) {
        textField.text = [[textField.text trim] substringToIndex:15];
    }
}

@end
