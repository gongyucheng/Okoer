//
//  OBRecentSearchView.h
//  YouKe
//
//  Created by obally on 15/10/27.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OBRecentSearchViewDelegate <NSObject>

@optional
- (void)recentSearchViewWithSelectedViewTag:(NSInteger)tag;
@end

@interface OBRecentSearchView : UIView
+(instancetype)recentView;
@property (nonatomic, retain) NSMutableArray *dataArrays;
@property(nonatomic,assign)id<OBRecentSearchViewDelegate> recentSearchViewDelegate;
@end
