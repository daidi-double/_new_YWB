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
        self.posterImageView.image = [UIImage imageNamed:@"baobaoBG2"];
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
        
        self.daoyanLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x,12+self.bounds.size.height *0.15f, kScreen_Width/2, self.bounds.size.height*0.1f)];
        _daoyanLabel.textColor = [UIColor whiteColor];
        _daoyanLabel.font = [UIFont systemFontOfSize:12];
        _daoyanLabel.text = @"导演:张三";
        [self addSubview:self.daoyanLabel];
        
        self.performerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.daoyanLabel.origin.x, self.daoyanLabel.bottom, (kScreen_Width-30)/2, self.bounds.size.height*0.2f)];
        _performerLabel.textColor = [UIColor whiteColor];
        _performerLabel.numberOfLines = 2;
        _performerLabel.font = [UIFont systemFontOfSize:12];
        _performerLabel.text = @"主演:黄渤 测试参数参数参数参数长春市";
        [self addSubview:self.performerLabel];
        
        self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, self.performerLabel.bottom, kScreen_Width/2, self.bounds.size.height*0.1f)];
        _categoryLabel.textColor = [UIColor whiteColor];
        _categoryLabel.font = [UIFont systemFontOfSize:12];
        _categoryLabel.text = @"类型:历史";
        [self addSubview:self.categoryLabel];
        
        self.countryAndTime = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, self.categoryLabel.bottom, kScreen_Width/2, self.bounds.size.height*0.1)];
        _countryAndTime.textColor = [UIColor whiteColor];
        _countryAndTime.font = [UIFont systemFontOfSize:13];
        _countryAndTime.text = @"地区:美国/100分钟";
        [self addSubview:self.countryAndTime];
        
        
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.posterImageView.right -28, self.posterImageView.bottom +5, 28, self.bounds.size.height*0.1f)];
        _scoreLabel.textColor = [UIColor orangeColor];

        _scoreLabel.font = [UIFont systemFontOfSize:15];
         _scoreLabel.text = @"9.0";
        [self addSubview:self.scoreLabel];
        
        UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 20, 0, 8, 15)];
        rightImageView.centerY = self.height/2 - 15;
        rightImageView.image = [UIImage imageNamed:@"右箭头"];
        [self addSubview:rightImageView];
        CGFloat realZhengshu;
        CGFloat realXiaoshu;
        //    NSString*starNmuber=self.model.grade;
        NSString * starNmuber1 = @"4.2";
        CGFloat totalScroe = [starNmuber1 floatValue]/2;
        NSString *starNmuber = [NSString stringWithFormat:@"%.2f",totalScroe];
        NSString*zhengshu=[starNmuber substringToIndex:1];
        realZhengshu=[zhengshu floatValue];
        NSString*xiaoshu=[starNmuber substringFromIndex:1];
        CGFloat CGxiaoshu=[xiaoshu floatValue];
        
        if (CGxiaoshu>=0.75) {
            realXiaoshu=0;
            realZhengshu= realZhengshu+1;
        }else if (CGxiaoshu>0&&CGxiaoshu<0.25){
            realXiaoshu=0;
        }else{
            realXiaoshu=0.5;
            
        }

        for (int a = 0; a<5; a++) {
            UIImageView * startImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.posterImageView.left +(12+3)*a, self.scoreLabel.origin.y, 15, 15)];
            startImageView.tag = 40 +a;
            if (startImageView.tag-40<realZhengshu) {
                //亮
                startImageView.image=[UIImage imageNamed:@"home_lightStar"];
            }else if (startImageView.tag-40==realZhengshu&&realXiaoshu<0.75 && realXiaoshu >=0.25){
                //半亮
                startImageView.image=[UIImage imageNamed:@"home_halfStar"];
                
            }else{
                //不亮
                startImageView.image=[UIImage imageNamed:@"home_grayStar"];
            }
            

            [self addSubview:startImageView];
        }
        
        self.gradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        self.gradeBtn.frame = CGRectMake(kScreen_Width * 0.65f, self.bounds.size.height*0.8, kScreen_Width*0.3f, self.bounds.size.height*0.15f);
        [_gradeBtn setTitle:@"评分" forState:UIControlStateNormal];
        _gradeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_gradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_gradeBtn addTarget:self action:@selector(gradeBtn:) forControlEvents:UIControlEventTouchUpInside];
        _gradeBtn.layer.borderWidth = 0.5f;
        
        _gradeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _gradeBtn.layer.cornerRadius = 5;
        _gradeBtn.layer.masksToBounds = YES;
        [self addSubview:self.gradeBtn];

    }
    return self;
}
//- (void)wantToSee:(UIButton*)sender{
//    sender.selected = _isselected;
//    _isselected = !_isselected;
//    NSLog(@"想看，传值给服务器");
//}
- (void)gradeBtn:(UIButton*)sender{
    NSLog(@"评分");
    [self.delegate commend];
}
- (void)tapAvatarView{
   
    [self.delegate play];
}



@end
