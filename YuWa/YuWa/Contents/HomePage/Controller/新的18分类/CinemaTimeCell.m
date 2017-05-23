//
//  CinemaTimeCell.m
//  YuWa
//
//  Created by double on 2017/2/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinemaTimeCell.h"

@implementation CinemaTimeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDataAry:(NSMutableArray *)dataAry{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
  
    }
    return self;
}
- (UILabel*)cinemaName{
    if (!_cinemaName) {
        _cinemaName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreen_Width*0.8, self.bounds.size.height/2)];
        _cinemaName.textColor = [UIColor blackColor];
        _cinemaName.textAlignment = 0;
        _cinemaName.font = [UIFont systemFontOfSize:18];
         [self.contentView addSubview:_cinemaName];
    }
    return _cinemaName;
}

- (UILabel*)price{
    if (!_price) {
        _price = [[UILabel alloc]initWithFrame:CGRectMake(10, self.cinemaName.height+15, kScreen_Width*0.4f, self.bounds.size.height*0.25f)];
        _price.textAlignment = 0;
        _price.font = [UIFont systemFontOfSize:15];
        _price.textColor = [UIColor greenColor];
         [self.contentView addSubview:_price];
    }
    return _price;
}
//- (UILabel*)screeningTime{
//    if (!_screeningTime) {
//        _screeningTime = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bounds.size.height*0.8+15, kScreen_Width /2, self.bounds.size.height*0.25)];
//        _screeningTime.text = @"近期场次";
//        _screeningTime.textAlignment = 0;
//        _screeningTime.font = [UIFont systemFontOfSize:14];
//        _screeningTime.textColor = [UIColor lightGrayColor];
//        
//    }
//    return _screeningTime;
//}

- (UILabel*)distance{
    if (!_distance) {
        _distance = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width*0.8, 0, kScreen_Width*0.2, self.bounds.size.height/2)];
        _distance.center = CGPointMake(kScreen_Width*0.9, self.bounds.size.height/2);
        _distance.textAlignment = NSTextAlignmentCenter;
        _distance.font = [UIFont systemFontOfSize:15];
        _distance.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_distance];
    }
    return _distance;
}

- (void)setModel:(CinemaModel *)model{
    _model = model;
    [self setData];
}

- (void)setData{
    
    self.cinemaName.text = self.model.cinema_name;
    self.price.text = [NSString stringWithFormat:@"￥%@起",self.model.settlePrice];
    CGFloat distanceNo = [self.model.distance floatValue]/1000;
    self.distance.text = [NSString stringWithFormat:@"%.2fkm",distanceNo];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
