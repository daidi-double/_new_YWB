//
//  ChooseMovieHeaderView.m
//  YuWa
//
//  Created by double on 2017/2/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChooseMovieHeaderView.h"
@interface ChooseMovieHeaderView ()<UIGestureRecognizerDelegate>

@end
@implementation ChooseMovieHeaderView


- (instancetype)initWithFrame:(CGRect)frame andDataAry:(NSMutableArray *)ary
{
    self = [super initWithFrame:frame];
    if (self) {
        self.posterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreen_Width/3, self.bounds.size.height*0.7)];
        self.posterImageView.image = [UIImage imageNamed:@"a1004.png"];
        self.posterImageView.userInteractionEnabled = YES;
        _PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView)];
        _PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
        _PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
        _PrivateLetterTap.delegate= self;
        self.posterImageView.contentMode = UIViewContentModeScaleToFill;
        [self.posterImageView addGestureRecognizer:_PrivateLetterTap];
        [self addSubview:self.posterImageView];
        
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(self.posterImageView.width-40, self.posterImageView.height-40, 40, 40);
        _playBtn.layer.cornerRadius = 20;
        _playBtn.layer.masksToBounds = YES;
        
        [_playBtn setImage:[UIImage imageNamed:@"play1.png"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(tapAvatarView) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.backgroundColor = [UIColor clearColor];
        [_posterImageView addSubview:self.playBtn];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width/3+20, 10, kScreen_Width/2, self.bounds.size.height*0.15)];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textColor = [UIColor whiteColor];
        _title.text = @"侏罗纪公园";
        [self addSubview:self.title];
        
        self.subTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x,12+self.bounds.size.height *0.15f, kScreen_Width/2, self.bounds.size.height*0.1f)];
        _subTitle.textColor = [UIColor whiteColor];
        _subTitle.font = [UIFont systemFontOfSize:14];
        _subTitle.text = @"Jurassic Park";
        [self addSubview:self.subTitle];
        
        self.number = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, 13+self.bounds.size.height*0.3, kScreen_Width/2, self.bounds.size.height*0.1f)];
        _number.textColor = [UIColor orangeColor];

        _number.font = [UIFont systemFontOfSize:15];
         _number.text = @"0人想看";
        [self addSubview:self.number];
        
        self.category = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, 15+self.bounds.size.height*0.4f, kScreen_Width/2, self.bounds.size.height*0.1f)];
        _category.textColor = [UIColor whiteColor];
        _category.font = [UIFont systemFontOfSize:12];
        _category.text = @"历史";
        [self addSubview:self.category];
        
        self.countryAndTime = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, 16+self.bounds.size.height*0.5f, kScreen_Width/2, self.bounds.size.height*0.1)];
        _countryAndTime.textColor = [UIColor whiteColor];
        _countryAndTime.font = [UIFont systemFontOfSize:13];
        _countryAndTime.text = @"美国/100分钟";
        [self addSubview:self.countryAndTime];
        
        self.beginTime = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, 17+self.bounds.size.height*0.6f, kScreen_Width/2, self.bounds.size.height*0.1f)];
        _beginTime.textColor = [UIColor whiteColor];
        _beginTime.font = [UIFont systemFontOfSize:12];
        _beginTime.text = @"2017-02-24大陆上映";
        [self addSubview:self.beginTime];
        
        self.wantSeeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.wantSeeBtn.frame = CGRectMake(10, self.bounds.size.height*0.8, (kScreen_Width-30)/2, self.bounds.size.height*0.15f);
        [_wantSeeBtn setTitle:@"想看" forState:UIControlStateNormal];
        _wantSeeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_wantSeeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_wantSeeBtn setImage:[UIImage imageNamed:@"heartgray.png"] forState:UIControlStateNormal];
        [_wantSeeBtn setImage:[UIImage imageNamed:@"heartselected.png"] forState:UIControlStateSelected];
        [_wantSeeBtn addTarget:self action:@selector(wantToSee:) forControlEvents:UIControlEventTouchUpInside];
        _wantSeeBtn.backgroundColor = RGBCOLOR(236, 183, 147, 0.8);
        [self addSubview:self.wantSeeBtn];
        
        self.gradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.gradeBtn.frame = CGRectMake(20+(kScreen_Width-30)/2, self.bounds.size.height*0.8, (kScreen_Width-30)/2, self.bounds.size.height*0.15f);
        [_gradeBtn setTitle:@"评分" forState:UIControlStateNormal];
        _gradeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_gradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_gradeBtn setImage:[UIImage imageNamed:@"home_grayStar@2x.png"] forState:UIControlStateNormal];
        [_gradeBtn setImage:[UIImage imageNamed:@"home_lightStar@2x.png"] forState:UIControlStateSelected];
//        [_gradeBtn setTitle:@"" forState:UIControlStateSelected];
        [_gradeBtn addTarget:self action:@selector(gradeBtn:) forControlEvents:UIControlEventTouchUpInside];
        _gradeBtn.backgroundColor = RGBCOLOR(236, 183, 147, 0.8);
        [self addSubview:self.gradeBtn];
        self.isselected = 1;
    }
    return self;
}
- (void)wantToSee:(UIButton*)sender{
    sender.selected = _isselected;
    _isselected = !_isselected;
    NSLog(@"想看，传值给服务器");
}
- (void)gradeBtn:(UIButton*)sender{
    NSLog(@"评分");
    [self.delegate commend];
}
- (void)tapAvatarView{
   
    [self.delegate play];
}



@end
