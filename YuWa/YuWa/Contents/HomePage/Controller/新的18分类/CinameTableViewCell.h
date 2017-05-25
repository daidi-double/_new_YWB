//
//  CinameTableViewCell.h
//  YuWa
//
//  Created by double on 17/5/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaModel.h"
@interface CinameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cinemaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTicketLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic,strong)CinemaModel * model;
@end
