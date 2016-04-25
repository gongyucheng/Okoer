//
//  BaseTableView.m
//  OBNewCar
//
//  Created by Obally on 14-9-23.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import "BaseTableView.h"
#import "OBColorRefresh.h"

@implementation BaseTableView
{
    CGFloat _contentOffsetY;
    //上拉加载的按钮
    UIButton *_refreshFooterButton;
     BOOL _upLoading;  //标示 上拉是否正在加载
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self _initView];
}

- (void)_initView {
    //1.将当前对象设置为代理对象
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    //2.创建下拉刷新控件
    _refreshHeaderView = [[OBColorRefresh alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height + 5, self.frame.size.width, self.bounds.size.height)];
    [self addSubview:_refreshHeaderView];
    
    //3.创建上拉加载更多UI
    _refreshFooterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshFooterButton.hidden = YES;
    _refreshFooterButton.frame = CGRectMake(0, 0, self.width, 44);
//    _refreshFooterButton.backgroundColor = [uiv];
    [_refreshFooterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_refreshFooterButton setTitle:@"上拉加载更多" forState:UIControlStateNormal];
    _refreshFooterButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_refreshFooterButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadView.frame = CGRectMake(90, 10, 20, 20);
    [loadView stopAnimating];
    loadView.tag = 2014;
    [_refreshFooterButton addSubview:loadView];
    
    self.tableFooterView = _refreshFooterButton;
    
}


#pragma mark - UITableView delegate

- (void)setRefreshFooter:(BOOL)refreshFooter {
    _refreshFooter = refreshFooter;
    
    if (_refreshFooter) {
        [_refreshFooterButton setTitle:@"上拉加载更多" forState:UIControlStateNormal];
        _refreshFooterButton.enabled = YES;
    } else {
        [_refreshFooterButton setTitle:@"加载完成" forState:UIControlStateNormal];
        _refreshFooterButton.enabled = NO;
    }
    
    UIActivityIndicatorView *loadView = (UIActivityIndicatorView *)[_refreshFooterButton viewWithTag:2014];
    [loadView stopAnimating];
    
    _upLoading = NO;
    
}

- (void)setData:(NSArray *)data {
    if (_data != data) {
        _data = data;
    }
    if (_data.count > 0) {
        _refreshFooterButton.hidden = NO;
    } else {
        _refreshFooterButton.hidden = YES;
    }
}

//加载更多的按钮点击
- (void)loadMoreAction {
//    _upLoading = YES;
     NSLog(@"--------_upLoading-----------");
    _refreshFooterButton.enabled = NO;
    [_refreshFooterButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    UIActivityIndicatorView *loadView = (UIActivityIndicatorView *)[_refreshFooterButton viewWithTag:2014];
    [loadView startAnimating];
    
    
    
    //2.回调代理对象的协议方法
    if ([self.refreshDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.refreshDelegate pullUp:self];
    }
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView

{
    
    _contentOffsetY = scrollView.contentOffset.y;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat h = scrollView.contentOffset.y + scrollView.height - scrollView.contentSize.height;
    NSLog(@"--------scrollViewDidScroll-----------%f",h);
    NSLog(@"scrollView.contentOffset.y-----------%f",scrollView.contentOffset.y);
    NSLog(@"scrollView.height-----------%f",scrollView.height);
    NSLog(@"scrollView.contentSize.height-----------%f",scrollView.contentSize.height);
    if (scrollView.contentOffset.y < -40.0 &&!_isLoading && self.refreshHeaderView.hidden == NO) {
        if (self.refreshHeaderView.hidden == NO) {
            [_refreshHeaderView start];
        }
        
//        NSLog(@"---------start-------------------");
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(pullDown:)] && !_isLoading) {
//            NSLog(@"----------------------------");
            _isLoading = YES;
            [self.refreshDelegate pullDown:self];
//            self.panGestureRecognizer = NO;
            [_refreshHeaderView stop];
            [self performSelector:@selector(setLoadingState) withObject:nil afterDelay:3];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat height = scrollView.contentSize.height;
    if (height <  scrollView.height) {
        height = scrollView.height;
    }
    CGFloat h = scrollView.contentOffset.y + scrollView.height - height;
    if (h > KViewHeight(30) && !_upLoading) {
         NSLog(@"--------loadMoreAction-----------%f",h);
        [self loadMoreAction];
    }
   
}
- (void)setLoadingState
{
    
//    self.scrollEnabled = YES;
    _isLoading = NO;
     NSLog(@"---------stop-------------------");
}
@end
