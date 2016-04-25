//
//  OBRecentCell.m
//  YouKe
//
//  Created by obally on 15/10/27.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import "OBRecentCell.h"

@interface OBRecentCell (){

    __weak IBOutlet UILabel *recentLabel;
}

@end
@implementation OBRecentCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)deleRecent:(id)sender {
    [self removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
