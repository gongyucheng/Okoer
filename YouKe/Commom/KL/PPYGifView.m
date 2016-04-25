//
//  PPYGifView.m
//  SuperCal
//
//  Created by Hale Chan on 14-7-18.
//  Copyright (c) 2014年 Beijing PapayaMobile Inc. All rights reserved.
//

#import "PPYGifView.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

@interface PPYGifView(){
    size_t              _index;
    size_t              _frameCount;
    float               _timestamp;
    CGImageSourceRef    _gifSourceRef;
    CADisplayLink *_displayLink;
}
@end

@implementation PPYGifView

- (void)removeFromSuperview
{
    if ([self isAnimating]) {
        [self stopAnimating];
    }
    [super removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame path:(NSString *)path
{
    return [self initWithFrame:frame gifData:[NSData dataWithContentsOfFile:path]];
}

- (instancetype)initWithFrame:(CGRect)frame gifData:(NSData *)gifData
{
    self = [super initWithFrame:frame];
    if (self) {
        _gifData = gifData;
    }
    return self;
}

- (void)setGifData:(NSData *)gifData
{
    if ([self isAnimating]) {
        [self stopAnimating];
    }
    _gifData = gifData;
}

- (void)startAnimating
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if ((self.gifData)) {
            CGImageSourceRef gifSourceRef;
            gifSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)(self.gifData), NULL);
            if (!gifSourceRef) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                _gifSourceRef = gifSourceRef;
                _frameCount = CGImageSourceGetCount(gifSourceRef);
            });
        }
    });
    
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopAnimating
{
    if ([self isAnimating]) {
        CFRelease(_gifSourceRef);
        _gifSourceRef = nil;
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)step
{
    if (!_gifSourceRef) {
        return;
    }
    float nextFrameDuration = [self frameDurationAtIndex:MIN(_index+1, _frameCount-1)];
    if (_timestamp < nextFrameDuration) {
        _timestamp += _displayLink.duration;
        return;
    }
	_index ++;
	_index = _index%_frameCount;
	CGImageRef ref = CGImageSourceCreateImageAtIndex(_gifSourceRef, _index, NULL);
	self.layer.contents = (__bridge id)(ref);
    CGImageRelease(ref);
    _timestamp = 0;
}

- (BOOL)isAnimating
{
    return (_gifSourceRef != nil);
}

- (float)frameDurationAtIndex:(size_t)index
{
    CFDictionaryRef dictRef = CGImageSourceCopyPropertiesAtIndex(_gifSourceRef, index, NULL);
    NSDictionary *dict = (__bridge NSDictionary *)dictRef;
    NSDictionary *gifDict = (dict[(NSString *)kCGImagePropertyGIFDictionary]);
    NSNumber *unclampedDelayTime = gifDict[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    NSNumber *delayTime = gifDict[(NSString *)kCGImagePropertyGIFDelayTime];
    CFRelease(dictRef);
    
    if (unclampedDelayTime.floatValue) {
        return unclampedDelayTime.floatValue;
    }else if (delayTime.floatValue) {
        return delayTime.floatValue;
    }else{
        return 1/24.0;
    }
}

@end
