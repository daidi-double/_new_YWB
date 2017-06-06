//
//  ChooseMovieHeaderView.h
//  YuWa
//
//  Created by double on 2017/2/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaAndBuyTicketModel.h"
@protocol ChooseMovieHeaderViewDelegate <NSObject>
-(void)commend;
@optional
-(void)play;

@end
@interface ChooseMovieHeaderView : UIView
@property (nonatomic,strong) CinemaAndBuyTicketModel * model;
@property (nonatomic,strong) UIImageView * posterImageView;//电影图片
@property (nonatomic,strong) UILabel * title;//电影名称
//@property (nonatomic,strong) UILabel * daoyanLabel;//导演
@property (nonatomic,strong) UILabel * scoreLabel ;//分数
//@property (nonatomic,strong) UILabel * performerLabel;//主演
@property (nonatomic,strong) UILabel * countryLabel;//国家
@property (nonatomic,strong) UILabel * timeLabel;//时长
@property (nonatomic,strong) UILabel * categoryLabel;//类型
@property (nonatomic,strong) UILabel * publishDateLabel;//上映时间
@property (nonatomic,strong) UIImageView * rightImageView;

@property (nonatomic,strong) UIButton * wantSeeBtn;//想看按钮
@property (nonatomic,strong) UIButton * gradeBtn;//评分按钮

@property (nonatomic,assign) BOOL isselected;
@property (nonatomic,strong) UITapGestureRecognizer * PrivateLetterTap;
@property (nonatomic,strong)id<ChooseMovieHeaderViewDelegate>delegate;



@end



