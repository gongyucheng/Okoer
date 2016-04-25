//
//  OBKWRelatedCardView.h
//  YouKe
//
//  Created by obally on 15/8/20.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OBKWListModel;
@protocol OBKWRelatedCardViewDelegate <NSObject>
@optional
- (void)didTapRelatedView;
- (void)didSelectedKWRelatedCommentButtonWithListModel:(OBKWListModel *)listModel;
- (void)didSelectedKWRelatedMoreButtonWithListModel:(OBKWListModel *)listModel;
@end
@interface OBKWRelatedCardView : UIView
@property (nonatomic, retain) OBKWListModel *listModel;
@property(nonatomic,assign)id<OBKWRelatedCardViewDelegate> relatedCardDelegate;
@end
