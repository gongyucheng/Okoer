//
//  OBKPRelatedCardView.h
//  YouKe
//
//  Created by obally on 15/8/20.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OBKPListModel;
@protocol OBKPRelatedCardViewDelegate <NSObject>
@optional
- (void)didTapRelatedView;
- (void)didSelectedKPRelatedChatButtonWithListModel:(OBKPListModel *)listModel;
- (void)didSelectedKPRelatedCommentButtonWithListModel:(OBKPListModel *)listModel;
- (void)didSelectedKPRelatedMoreButtonWithListModel:(OBKPListModel *)listModel;
@end
@interface OBKPRelatedCardView : UIView
@property (nonatomic, retain) OBKPListModel *listModel;
@property(nonatomic,assign)id<OBKPRelatedCardViewDelegate> relatedCardDelegate;
@end
