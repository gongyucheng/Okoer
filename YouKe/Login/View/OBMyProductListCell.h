//
//  OBMyProductListCell.h
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OBGradeModel;
@protocol OBMyProductListCellDelegate <NSObject>

@optional
- (void)myProductListCellDidSelectedRemoveButtonWithGradeModel:(OBGradeModel *)gradeModel;

@end

@interface OBMyProductListCell : UITableViewCell
@property (nonatomic, retain) OBGradeModel *listModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,assign)id<OBMyProductListCellDelegate> productCellDelegate;
@end
