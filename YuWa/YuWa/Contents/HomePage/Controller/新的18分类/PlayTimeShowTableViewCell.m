//
//  PlayTimeShowTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PlayTimeShowTableViewCell.h"

@implementation PlayTimeShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(FilmShowTimeModel *)model{
    _model = model;
    [self setData];
}

- (void)setData{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(8, 0, kScreen_Width-16, 0.5)];
    line.backgroundColor = RGBCOLOR(240, 240, 240, 1);
    [self.contentView addSubview:line];
    self.showTimeLabel.text = self.model.showTime;
    self.languageLabel.text = self.model.language;
    //    _price.text = @"影院价:￥70";
    self.seller_priceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.settlePrice];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@散场",self.model.endTime];
    self.hallNumber.text = [NSString stringWithFormat:@"%@号厅",self.model.hallname];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
