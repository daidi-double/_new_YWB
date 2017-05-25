//
//  CinameTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinameTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"
@implementation CinameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(CinemaModel *)model{
    _model = model;
    [self setData];
}

- (void)setData{
    
    self.cinemaNameLabel.text = self.model.cinema_name;
    if (self.model.settle_price == nil) {
       self.priceLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"￥%@",self.model.minprice] withFont:self.priceLabel.font withColor:RGBCOLOR(253, 202, 75, 1) withSecondtStr:@"起" withFont:[UIFont systemFontOfSize:13] withColor:RGBCOLOR(123, 124, 125, 1)];
    }else{
      self.priceLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"￥%@",self.model.settle_price] withFont:self.priceLabel.font withColor:RGBCOLOR(253, 202, 75, 1) withSecondtStr:@"起" withFont:[UIFont systemFontOfSize:13] withColor:RGBCOLOR(123, 124, 125, 1)];
    }

    self.otherTicketLabel.layer.cornerRadius = 5;
    self.otherTicketLabel.layer.masksToBounds = YES;
    
    self.seatLabel.layer.cornerRadius = 5;
    self.seatLabel.layer.masksToBounds = YES;
    CGFloat distanceNo = [self.model.distance floatValue]/1000;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",distanceNo];
    switch ([self.model.goodstype integerValue]) {
        case 0:
            self.otherTicketLabel.text = @"兑";
            self.seatLabel.text = @"座";
            break;
        case 1:
             self.seatLabel.text = @"座";
            self.otherTicketLabel.hidden = YES;
            break;
        
        default:
            self.seatLabel.hidden = YES;
             self.otherTicketLabel.text = @"兑";
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
