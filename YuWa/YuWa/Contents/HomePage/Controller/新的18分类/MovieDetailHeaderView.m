//
//  MovieDetailHeaderView.m
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieDetailHeaderView.h"
@interface MovieDetailHeaderView()<ChooseMovieHeaderViewDelegate>

@end
@implementation MovieDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        self.headerView  = [[ChooseMovieHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height* 0.3f)];
        self.headerView.playBtn.hidden = YES;
        self.headerView.delegate = self;
        UIImageView * view = [self.headerView viewWithTag:1011];
        view.hidden = YES;
        self.headerView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.headerView];
        
        self.introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.headerView.bottom + 15, kScreen_Width -30, self.height * 0.3f - 35.f)];
        self.introduceLabel.textColor = RGBCOLOR(160, 160, 160, 1);
        self.introduceLabel.font = [UIFont systemFontOfSize:12];
        self.introduceLabel.numberOfLines = 0;
        [self addSubview:self.introduceLabel];
        [self setData];
    }
    return self;
}

- (void)setModel:(CinemaAndBuyTicketModel *)model{
    _model = model;
//    [self setData];
}
- (void)setData{

    self.headerView.model = self.model;
//    self.introduceLabel.text = self.model.intro;
    self.introduceLabel.text = @"黄发发发卡积分；啊哈；Fiat；副科级案发诶暗访狐恩爱法芙娜； 房间爱偶尔放假啊诶佛教安鹏飞哈皮肤哈佩服";
    CGRect labelHeight = [self.introduceLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _introduceLabel.font} context:nil];

    _introduceLabel.frame= CGRectMake(15, self.headerView.bottom + 15, kScreen_Width -30 , labelHeight.size.height);

}

+(CGFloat)getHeaderHeight:(NSString *)introduce{
    CGRect labelHeight = [introduce boundingRectWithSize:CGSizeMake(kScreen_Width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return labelHeight.size.height+kScreen_Height * 0.3f + 35;

}

-(void)commend{
    [self.delegate toCommentScore];
}
@end
