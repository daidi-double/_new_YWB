//
//  MovieDetailHeaderView.h
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseMovieHeaderView.h"
#import "CinemaAndBuyTicketModel.h"
@interface MovieDetailHeaderView : UIView
@property (nonatomic,strong)ChooseMovieHeaderView* headerView;
@property (nonatomic,strong)UILabel * introduceLabel;
@property (nonatomic,strong) CinemaAndBuyTicketModel * model;
+(CGFloat)getHeaderHeight:(NSString *)introduce;

@end
