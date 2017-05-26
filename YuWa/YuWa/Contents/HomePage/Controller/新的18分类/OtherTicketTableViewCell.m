//
//  OtherTicketTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketTableViewCell.h"

@implementation OtherTicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(OtherTicketModel *)model{
    _model = model;
    [self setData];
}

-(void)setData{
    self.BGView.layer.cornerRadius = 5;
    self.BGView.layer.masksToBounds = YES;
    
    self.filmTypeLabel.text = [NSString stringWithFormat:@"%@D",self.model.showType];
    self.sellerPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.price];
    self.markLabel.text = [NSString stringWithFormat:@"可以在本电影院兑换%@电影票",self.filmTypeLabel.text];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
