//
//  KLSceneDialog.m
//  SuperCal
//
//  Created by Lu Ming on 13-12-18.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import "KLSceneDialog.h"
//#import "PPYUIToolkit.h"
#import "PPYGifView.h"

NSString *const kSceneAttributeKeySceneTitle              = @"kSceneAttributeKeySceneTitle";
NSString *const kSceneAttributeKeySceneTip                = @"kSceneAttributeKeySceneTip";
NSString *const kSceneAttributeKeyAnimationDuration       = @"kSceneAttributeKeyAnimationDuration";
NSString *const kSceneAttributeKeyAnimationRepeatCount    = @"kSceneAttributeKeyAnimationRepeatCount";
NSString *const kSceneAttributeKeySceneSize = @"sceneSize";


@interface KLSceneDialog ()

@property (nonatomic, strong) NSTimer   *timer;

@property (nonatomic, strong) NSMutableDictionary   *imagesDataDict;
@property (nonatomic, strong) NSMutableArray        *orderArray;
@property (nonatomic, strong) NSMutableDictionary   *attributesDict;

@property (nonatomic, assign) NSInteger  currentSceneIndex;

@end



@implementation KLSceneDialog

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        
        _imageView = [[PPYGifView alloc] init];
        
        _tipLabel = [[UILabel alloc] init];
        
        
        _tipLabel.numberOfLines = 0;
        
        _tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        [self addSubview:_titleLabel];
        
        [self addSubview:_imageView];
        
        [self addSubview:_tipLabel];
        
        _imagesDataDict = [[NSMutableDictionary alloc] init];
        _orderArray = [[NSMutableArray alloc] init];
        _attributesDict = [[NSMutableDictionary alloc] init];
        
        _switchDuration = 5;
        _currentSceneIndex = 0;
        
        _iteratorFirstIndex = 0;
        
        _resourceNameSuffix = @"png";
    }
    return self;
}

- (void)startSwitchTimer
{
    [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_switchDuration target:self selector:@selector(switchTimerHanlder:) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stopSwitchTimer {
    
    [_timer invalidate];
}

- (void)switchTimerHanlder:(NSTimer *)timer {
    
    NSInteger nextIndex = (_currentSceneIndex + 1) % _orderArray.count;
    
    [self switchSceneToIndex:nextIndex];
}

- (void)switchSceneImageToIndex:(NSInteger)index
{
    NSString        *name       = _orderArray[index];
    
    [_imageView stopAnimating];
    _imageView.gifData = _imagesDataDict[name];
    [_imageView startAnimating];
}

- (void)switchSceneTitleToIndex:(NSInteger)index
{
    NSString        *name       = _orderArray[index];
    NSDictionary    *attributes = _attributesDict[name];
    NSString        *title      = attributes[kSceneAttributeKeySceneTitle];
    
    _titleLabel.text = title;
}

- (void)switchSceneTipToIndex:(NSInteger)index
{
    NSString        *name       = _orderArray[index];
    NSDictionary    *attributes = _attributesDict[name];
    NSString        *tip        = attributes[kSceneAttributeKeySceneTip];
    
    _tipLabel.text = tip;
}

- (void)switchSceneToIndex:(NSInteger)index {
    
    if (index < 0 || index >= _orderArray.count) {
        return ;
    }
    
    [self switchSceneImageToIndex:index];
    
    [self switchSceneTitleToIndex:index];
    
    [self switchSceneTipToIndex:index];
    
    _currentSceneIndex = index;
    
    [self relayoutSubviews];
}

- (void)addSceneWithName:(NSString *)name attributes:(NSDictionary *)attributes
{
    NSAssert(name, @"addSceneWithName failed : name should not be nil");
    
    NSData *imageData = _imagesDataDict[name];
    if (imageData)
        return ;
    
    [_imagesDataDict setValue:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"gif"]]
                       forKey:name];
    [_orderArray addObject:name];
    
    NSString *sceneTitle    = attributes[kSceneAttributeKeySceneTitle];
    NSNumber *repeatCount   = attributes[kSceneAttributeKeyAnimationRepeatCount];
    NSNumber *duration      = attributes[kSceneAttributeKeyAnimationDuration];
    NSValue *size = attributes[kSceneAttributeKeySceneSize];
    
    sceneTitle  = sceneTitle ?: @"";
    repeatCount = repeatCount ?: @(0);
    duration    = duration ?:@(1.0);//why 1.0?
    size = size ?: [NSValue valueWithCGSize:self.bounds.size];
    
    NSDictionary *dict = @{kSceneAttributeKeySceneTitle : sceneTitle,
                           kSceneAttributeKeyAnimationDuration : duration,
                           kSceneAttributeKeyAnimationRepeatCount : repeatCount,
                           kSceneAttributeKeySceneSize: size};
    
    _attributesDict[name] = dict;
}

- (void)removeSceneWithName:(NSString *)name {
    
    NSAssert(name, @"removeSceneWithName failed : name should not be nil");
    
    [_imagesDataDict removeObjectForKey:name];
    [_orderArray removeObject:name];
    [_attributesDict removeObjectForKey:name];
}

- (void)relayoutSubviews {
    
    CGRect bounds = self.bounds;
    
    NSString *name = _orderArray[_currentSceneIndex];
    CGSize imageSize = [_attributesDict[name][kSceneAttributeKeySceneSize] CGSizeValue];
    CGRect imageRect = CGRectZero;
    imageRect.size.width = CGRectGetWidth(bounds);
    imageRect.size.height = imageRect.size.width * imageSize.height / imageSize.width;

    CGFloat textWidth = CGRectGetWidth(bounds) * 0.8f;
    
    CGRect titleRect = CGRectZero;
    titleRect.size = [_titleLabel sizeThatFits:CGSizeMake(textWidth, CGFLOAT_MAX)];
    CGRectGetCenter(titleRect);
    titleRect.origin.y = CGRectGetMaxY(imageRect) + 75.0;

    CGRect tipRect = CGRectZero;
    tipRect.size = [_tipLabel sizeThatFits:CGSizeMake(textWidth, CGFLOAT_MAX)];
    CGRectGetCenter(tipRect);
    tipRect.origin.y = CGRectGetMaxY(titleRect) + 25.0;
    
    CGFloat offsetY = (CGRectGetMaxY(bounds) - CGRectGetMaxY(tipRect)) * 0.5f;
    imageRect.origin.y += offsetY;
    titleRect.origin.y += offsetY;
    tipRect.origin.y += offsetY;
    
    _imageView.frame = imageRect;
    _titleLabel.frame = titleRect;
    _tipLabel.frame = tipRect;
}


///---------------------------------------------------------------------------------------------------------------------
/// Override

- (void)overlayViewDidAppear:(BOOL)animated {
    
    [self switchSceneToIndex:_currentSceneIndex];
    
    [self startSwitchTimer];
}

- (void)overlayViewWillDisappear:(BOOL)animated {
    
    [self stopSwitchTimer];
}

@end
