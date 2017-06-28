//
//  YWHotProjectTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHotProjectTableViewCell.h"

@implementation YWHotProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopIconImageView.layer.cornerRadius = 7;
    self.shopNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.currentPriceLaber.textColor = [UIColor colorWithHexString:@"#333333"];
    self.currentNumber.textColor = [UIColor colorWithHexString:@"#333333"];
    self.endTimeLabel.textColor = [UIColor colorWithHexString:@"#ffb155"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
