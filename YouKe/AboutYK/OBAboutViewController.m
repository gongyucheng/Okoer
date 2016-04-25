//
//  OBAboutViewController.m
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBAboutViewController.h"
#import "OBSingleColorView.h"
#import "NSString+Extension.h"

@interface OBAboutViewController ()
@property (nonatomic, retain) UIVisualEffectView *effectView;
@end

@implementation OBAboutViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    
    // Do any additional setup after loading the view.
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
    titleLabel.text = @"关于优恪";
    [visualEffect addSubview:titleLabel];
    
    UIScrollView *scroll1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KViewHeight(60), kScreenWidth, kScreenHeight - KViewHeight(60))];
    scroll1.bounces = NO;
    scroll1.showsVerticalScrollIndicator = YES;
    scroll1.showsHorizontalScrollIndicator = NO;
    [scroll1 setContentSize:CGSizeMake(0, KViewHeight(20))];
    [self.view addSubview:scroll1];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(10), kScreenWidth - KViewWidth(10) * 2, kScreenHeight - KViewHeight(200))];
    contentLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"优恪，优质人生的恪守者。我们将秉承德国母品牌的优秀传统，恪守中立客观原则，与世界顶尖检测机构合作，为中国消费者提供科学、实用、生态的消费品检测报告和延伸体验，打造一个开放、多元、有担当的消费者社交平台。\n\n我们承诺，所有检测产品都将采取匿名随机的方式购买，不接受任何企业邀请和送检，所有检测实验均在海外自主完成，检测结果的生成和发布都将独立完成。\n\n在优恪网上，你可以——\n通过PC端网站、手机移动端或社交媒体账户访问优恪资讯，随手可及产品测评与消费指引；\n\n查阅食品、母婴、美妆、健康、家居、电子六大领域最新消费资讯和产品安全质量报道；\n看“优恪调查”为你揭示消费真相，全流程监督产品质量；\n\n有任何产品质量安全或健康问题？纵马过来，由各路专家达人答疑解惑；\n\n与众多追求生活、生存质量的消费者互动交流；\n\n甚至……\n说出你最关心的产品，我们来帮你完成检测。\n\n（优恪由北京优恪科技有限公司负责运营）\n";
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:KViewHeight(5)];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contentLabel.text length])];
    [contentLabel setAttributedText:attributedString1];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [scroll1 addSubview:contentLabel];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = contentLabel.font;
    attrs[NSKernAttributeName] =[NSNumber numberWithFloat:KViewHeight(5)];
    CGSize maxSize = CGSizeMake(contentLabel.width, MAXFLOAT);
    CGSize size = [contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attrs context:nil].size;
    contentLabel.height = size.height + KViewHeight(50);
    [scroll1 setContentSize:CGSizeMake(kScreenWidth, contentLabel.height + KViewHeight(30))];

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


@end
