//
//  CinemaHeaderView.m
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinemaHeaderView.h"
#import "Acceleecet.h"
#import "ViscosityLayout.h"
#import "MoviePicCollectionViewCell.h"

#define MOVIECELL1 @"MoviePicCollectionViewCell"
@interface CinemaHeaderView()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation CinemaHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _cinemaName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0, self.height * 0.15f)];
        _cinemaName.textColor = [UIColor blackColor];
        _cinemaName.font = [UIFont systemFontOfSize:15];
        _cinemaName.text = @"横店电影城mmmmmmmm";
        CGSize size = [self sizeWithSt:_cinemaName.text font:_cinemaName.font];
        _cinemaName.frame = CGRectMake(10, 0, size.width, self.height * 0.15f);
        UIView * touchView = [[UIView alloc]initWithFrame:_cinemaName.frame];
        //    touchView.backgroundColor = [UIColor greenColor];
        [self addSubview:touchView];
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToCinemaDetail)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.delegate = self;
        [touchView addGestureRecognizer:tapGes];
        [self addSubview:_cinemaName];
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(10, self.cinemaName.height, kScreen_Width * 0.6f, self.height * 0.05f)];
        _address.textColor = [UIColor lightGrayColor];
        _address.font = [UIFont systemFontOfSize:12];
        _address.text = @"晋江市";
        [self addSubview:_address];
        _isDiscount = 0;
        UIView * foodView;
        UIView * discountView;
        if (_isDiscount) {
            foodView = [[UIView alloc]initWithFrame:CGRectMake(10, self.height *0.22f, kScreen_Width/2-20, self.height* 0.15f)];
            foodView.backgroundColor = [UIColor colorWithRed:196/255.0 green:235/255.0 blue:247/255.0 alpha:1];
            foodView.layer.masksToBounds = YES;
            foodView.layer.cornerRadius = 5;
            UITapGestureRecognizer * tapFood = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToFood)];
            tapGes.numberOfTapsRequired = 1;
            tapGes.numberOfTouchesRequired = 1;
            tapGes.delegate = self;
            [foodView addGestureRecognizer:tapFood];
            [self addSubview:foodView];
            
            discountView = [[UIView alloc]initWithFrame:CGRectMake(20 + kScreen_Width/2, self.height *0.22f, kScreen_Width/2-20, self.height* 0.15f)];
            discountView.backgroundColor = [UIColor colorWithRed:243/255.0 green:235/255.0 blue:203/255.0 alpha:1];
            discountView.layer.masksToBounds = YES;
            discountView.layer.cornerRadius = 5;
            UITapGestureRecognizer * tapdiscount = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToDiscount)];
            tapGes.numberOfTapsRequired = 1;
            tapGes.numberOfTouchesRequired = 1;
            tapGes.delegate = self;
            [foodView addGestureRecognizer:tapdiscount];
            [self addSubview:discountView];


            UILabel * discount = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, discountView.width* 0.5, discountView.height * 0.65f)];
            discount.text = @"折扣卡";
            discount.textColor = RGBCOLOR(255, 213, 39, 1);
            discount.font = [UIFont systemFontOfSize:14];
            [discountView addSubview:discount];
            
            UILabel * first = [[UILabel alloc]initWithFrame:CGRectMake(10, discountView.height *0.65f, discountView.width *0.8f, discountView.height * 0.25)];
            first.textColor = RGBCOLOR(255, 213, 39, 1);
            first.font = [UIFont systemFontOfSize:12];
            first.text = @"首单更优惠";
            [discountView addSubview:first];
            
            UIImageView * vipDiscount = [[UIImageView alloc]initWithFrame:CGRectMake(discountView.width-35, 3, 30, discountView.height-6)];
            vipDiscount.image = [UIImage imageNamed:@"vip.png"];
            [discountView addSubview:vipDiscount];
        }else{
            foodView = [[UIView alloc]initWithFrame:CGRectMake(10, self.height *0.22f, kScreen_Width-20, self.height* 0.15f)];
            foodView.backgroundColor = [UIColor colorWithRed:196/255.0 green:235/255.0 blue:247/255.0 alpha:1];
            foodView.layer.masksToBounds = YES;
            foodView.layer.cornerRadius = 5;
            UITapGestureRecognizer * tapFood = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToFood)];
            tapGes.numberOfTapsRequired = 1;
            tapGes.numberOfTouchesRequired = 1;
            tapGes.delegate = self;
            [foodView addGestureRecognizer:tapFood];
            [self addSubview:foodView];

        }
        _foodName = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, foodView.width, foodView.height * 0.65f)];
        _foodName.text = @"观影套餐";
        _foodName.textColor = [UIColor blueColor];
        _foodName.font = [UIFont systemFontOfSize:14];
        [foodView addSubview:_foodName];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(5, foodView.height *0.65f, foodView.width *0.8f, foodView.height * 0.25)];
        _price.textColor = [UIColor blueColor];
        _price.font = [UIFont systemFontOfSize:12];
        _price.text = @"小吃";
        [foodView addSubview:_price];
        _ice_cream = [[UIImageView alloc]initWithFrame:CGRectMake(foodView.width-35, 3, 30, foodView.height-6)];
        _ice_cream.image = [UIImage imageNamed:@"爆米花.png"];
        [foodView addSubview:_ice_cream];
        
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressBtn.frame = CGRectMake(self.width-45, self.height*0.1, 30, 30);
        [_addressBtn setImage:[UIImage imageNamed:@"home_locate@2x.png"] forState:UIControlStateNormal];
        [_addressBtn addTarget:self action:@selector(locationAddress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addressBtn];
        
        _score = [[UILabel alloc]initWithFrame:CGRectMake(_cinemaName.width +20, _cinemaName.origin.y, 40, _cinemaName.height)];
        _score.textColor = [UIColor orangeColor];
        _score.text = @"4.0分";
        _score.font = [UIFont systemFontOfSize:15];
        [self addSubview:_score];
        
        
        _BGScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height*0.4f, kScreen_Width, self.height *0.45f)];
//        _BGScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_BGScrollView];
      
        ViscosityLayout * layout = [[ViscosityLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _movieCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.height * 0.4f+10, kScreen_Width, self.height * 0.3f) collectionViewLayout:layout];

            [_movieCollectView registerClass:[MoviePicCollectionViewCell class] forCellWithReuseIdentifier:MOVIECELL1];
        [_movieCollectView registerNib:[UINib nibWithNibName:MOVIECELL1 bundle:nil] forCellWithReuseIdentifier:MOVIECELL1];

        _movieCollectView.dataSource = self;
        _movieCollectView.delegate = self;
        _movieCollectView.backgroundColor = [UIColor clearColor];

        
        _movieCollectView.showsVerticalScrollIndicator = NO;
        _movieCollectView.showsHorizontalScrollIndicator = NO;
  
        [self addSubview:_movieCollectView];
        
        
    
        _movieTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, _BGScrollView.height * 0.3f)];
        _movieTitle.text = @"乘风破浪";
        CGSize movieTitleSize = [self sizeWithSt:_movieTitle.text font:_movieTitle.font];
        _movieTitle.frame = CGRectMake(0, _BGScrollView.height * 0.9f, movieTitleSize.width, _BGScrollView.height*0.3f);

        _movieTitle.centerX = self.width/2 - 15;
        _movieTitle.textColor = [UIColor blackColor];
        _movieTitle.font = [UIFont systemFontOfSize:15];
        [_BGScrollView addSubview:_movieTitle];
        
        
        _movieScore = [[UILabel alloc]initWithFrame:CGRectMake(_movieTitle.origin.x + _movieTitle.width, _BGScrollView.height * 0.9f,40, _BGScrollView.height * 0.2f)];
        _movieScore.text = @"8.8分";
        
        _movieScore.textColor = [UIColor lightGrayColor];
        _movieScore.font = [UIFont systemFontOfSize:13];
        [_BGScrollView addSubview:_movieScore];
        
        _introduce = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, _BGScrollView.height * 0.3f)];
        _introduce.text = @"乘风破浪|剧情|邓超MMMMMMMMMMM";
        _introduce.font = [UIFont systemFontOfSize:13];
        CGSize introduceSize = [self sizeWithSt:_introduce.text font:_introduce.font];
        _introduce.frame = CGRectMake(0, _movieTitle.bottom-10, introduceSize.width, _BGScrollView.height*0.2f);
        _introduce.centerX = self.width/2;
        _introduce.textAlignment = 1;
        [_BGScrollView addSubview:_introduce];

    }
    return self;
}
#pragma mark - collectViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;//修改
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoviePicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MOVIECELL1 forIndexPath:indexPath];

    cell.movieImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"baobaoBG%ld",indexPath.item]];
    UIImageView * bgImageView;
    if (!bgImageView) {
        bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height -10)];
        
        
        [_BGScrollView addSubview:bgImageView];
        _BGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height -10)];
        ;

        _BGroundView.image = [UIImage imageNamed:@"横条.png"];
        [bgImageView addSubview:_BGroundView];

        
    }
    bgImageView.image = [Acceleecet boxblurImage:cell.movieImageView.image withBlurNumber:0.9];
    
    return cell;
}

- (CGSize)sizeWithSt:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(kScreen_Width * 0.6f, kScreen_Height * 0.05f)options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font}context:nil];
    
    return rect.size;
}
- (void)locationAddress{
    NSLog(@"定位");
    [self.delegate ToLocation];
}
- (void)ToCinemaDetail{
    [self.delegate ToCinemaDetaliPage];
}
- (void)touchToFood{
    [self.delegate ToFoodPage];
}
- (void)touchToDiscount{
    [self.delegate ToVipDetaliPage];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
