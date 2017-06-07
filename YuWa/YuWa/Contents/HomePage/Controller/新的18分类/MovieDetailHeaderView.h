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

@protocol MovieDetailHeaderViewDelegate <NSObject>

- (void)toCommentScore;

@end
@interface MovieDetailHeaderView : UIView

@property (nonatomic,strong)UILabel * introduceLabel;
@property (nonatomic,strong) CinemaAndBuyTicketModel * model;
@property (nonatomic,assign)id<MovieDetailHeaderViewDelegate>delegate;
+(CGFloat)getHeaderHeight:(NSString *)introduce;

@end
