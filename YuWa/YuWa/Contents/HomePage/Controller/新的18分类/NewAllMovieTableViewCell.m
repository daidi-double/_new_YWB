//
//  NewAllMovieTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "NewAllMovieTableViewCell.h"

@implementation NewAllMovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyBtn.layer.borderColor = CNaviColor.CGColor;
    self.buyBtn.layer.borderWidth = 1;
    self.buyBtn.layer.cornerRadius = 5;
    [self.buyBtn.layer setMasksToBounds:YES];
}
- (IBAction)toBuyTicketAction:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
