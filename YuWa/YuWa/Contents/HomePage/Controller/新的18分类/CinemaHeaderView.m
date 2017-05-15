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
@property (nonatomic,strong)NSMutableArray * imageAry;//存放背景图
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIImageView * bgImageView;;
@end
@implementation CinemaHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _cinemaName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0, self.height * 0.2f)];
        _cinemaName.textColor =RGBCOLOR(147, 146, 146, 1);
        _cinemaName.font = [UIFont systemFontOfSize:17];
        _cinemaName.text = @"横店电影城mmmmmmmm";
        CGSize size = [self sizeWithSt:_cinemaName.text font:_cinemaName.font];
        _cinemaName.frame = CGRectMake(10, 0, size.width, self.height * 0.17f);
        UIView * touchView = [[UIView alloc]initWithFrame:_cinemaName.frame];
        //    touchView.backgroundColor = [UIColor greenColor];
        [self addSubview:touchView];
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToCinemaDetail)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.delegate = self;
        [touchView addGestureRecognizer:tapGes];
        [self addSubview:_cinemaName];
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(10, self.cinemaName.height, kScreen_Width * 0.6f, self.height * 0.15f)];
        _address.textColor = [UIColor lightGrayColor];
        _address.numberOfLines = 0;
        _address.font = [UIFont systemFontOfSize:12];
        _address.text = @"晋江市";
        [self addSubview:_address];
        

        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressBtn.frame = CGRectMake(self.width-45, self.height*0.1, 30, 30);
        [_addressBtn setImage:[UIImage imageNamed:@"home_locate@2x.png"] forState:UIControlStateNormal];
        [_addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, -15, 0)];
        
        [_addressBtn addTarget:self action:@selector(locationAddress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addressBtn];

        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _addressBtn.bottom, 30, 25)];
        titleLabel.text = @"导航";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.centerX = _addressBtn.centerX;
        titleLabel.userInteractionEnabled = YES;
        [self addSubview:titleLabel];
        
        UITapGestureRecognizer * tapMapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationAddress)];
        tapMapGes.numberOfTapsRequired = 1;
        tapMapGes.numberOfTouchesRequired = 1;
        tapMapGes.delegate = self;
        [titleLabel addGestureRecognizer:tapMapGes];
        
        UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_addressBtn.left-30, self.cinemaName.height - 30, 10, 15)];
        rightImageView.centerY = _addressBtn.centerY;
        rightImageView.image = [UIImage imageNamed:@"common_icon_arrow"];
        [self addSubview:rightImageView];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(rightImageView.right + 5, 30, 1, self.height * 0.15f)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.centerY = _addressBtn.centerY;
        [self addSubview:line];
        
        _score = [[UILabel alloc]initWithFrame:CGRectMake(_cinemaName.width +20, _cinemaName.origin.y, 40, _cinemaName.height)];
        _score.textColor = [UIColor orangeColor];
        _score.text = @"4.0分";
        _score.font = [UIFont systemFontOfSize:15];
        [self addSubview:_score];
        
    _bgImageView.image = [Acceleecet boxblurImage:[UIImage imageNamed:@"baobaoBG0"] withBlurNumber:0.9];
        
        _BGScrollView = [[UIView alloc]initWithFrame:CGRectMake(0,titleLabel.bottom +10, kScreen_Width, self.height *0.55f)];
//        _BGScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_BGScrollView];
      
        ViscosityLayout * layout = [[ViscosityLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _movieCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.height * 0.4f - 5, kScreen_Width, self.height * 0.4f) collectionViewLayout:layout];

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
        _movieTitle.frame = CGRectMake(0, _BGScrollView.height-10, movieTitleSize.width, _BGScrollView.height*0.3f);

        _movieTitle.centerX = self.width/2 - 15;
        _movieTitle.textColor = [UIColor blackColor];
        _movieTitle.font = [UIFont systemFontOfSize:15];
        [_BGScrollView addSubview:_movieTitle];
        
        
        _movieScore = [[UILabel alloc]initWithFrame:CGRectMake(_movieTitle.origin.x + _movieTitle.width, _BGScrollView.height,40, _BGScrollView.height * 0.2f)];
        _movieScore.text = @"8.8分";
        
        _movieScore.textColor = [UIColor lightGrayColor];
        _movieScore.font = [UIFont systemFontOfSize:13];
        [_BGScrollView addSubview:_movieScore];
        
//        _introduce = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, _BGScrollView.height * 0.3f)];
//        _introduce.text = @"乘风破浪|剧情|邓超MMMMMMMMMMM";
//        _introduce.font = [UIFont systemFontOfSize:13];
//        CGSize introduceSize = [self sizeWithSt:_introduce.text font:_introduce.font];
//        _introduce.frame = CGRectMake(0, _movieTitle.bottom-10, introduceSize.width, _BGScrollView.height*0.2f);
//        _introduce.centerX = self.width/2;
//        _introduce.textAlignment = 1;
//        [_BGScrollView addSubview:_introduce];

    }
    return self;
}
#pragma mark - collectViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;//修改
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoviePicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MOVIECELL1 forIndexPath:indexPath];

    cell.movieImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"baobaoBG%ld",indexPath.item]];
    [self.imageAry addObject:cell.movieImageView.image];
    
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height -10)];
        
        
        [_BGScrollView addSubview:_bgImageView];
        _BGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height -10)];
        ;
        
        _BGroundView.image = [UIImage imageNamed:@"横条.png"];
        [_bgImageView addSubview:_BGroundView];
        
        
        _bgImageView.image = [Acceleecet boxblurImage:self.imageAry[0] withBlurNumber:0.9];
    }
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.mj_offsetX == 0 ){
        self.index = 0;
        _movieTitle.text = @"乘风破浪";
    }else if (scrollView.mj_offsetX == kScreen_Width/4){
        self.index = 1;
        _movieTitle.text = @"乘风破浪2";

    }else if (scrollView.mj_offsetX == kScreen_Width/2){
        self.index = 2;
        _movieTitle.text = @"乘风破浪3";
    }else if (scrollView.mj_offsetX == kScreen_Width*0.75){
        self.index = 3;
        _movieTitle.text = @"乘风破浪4";
    }else if (scrollView.mj_offsetX == kScreen_Width){
        self.index = 4;
        _movieTitle.text = @"乘风破浪5";
    }
    
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height)];
        
        
        [_BGScrollView addSubview:_bgImageView];
        _BGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height)];
        ;
        
        _BGroundView.image = [UIImage imageNamed:@"横条.png"];
        [_bgImageView addSubview:_BGroundView];
        
        
    }
    CGSize movieTitleSize = [self sizeWithSt:_movieTitle.text font:_movieTitle.font];
    _movieTitle.width = movieTitleSize.width;
    _bgImageView.image = [Acceleecet boxblurImage:self.imageAry[self.index] withBlurNumber:0.9];
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

- (NSMutableArray *)imageAry{
    if (!_imageAry) {
        _imageAry = [NSMutableArray array];
    }
    return _imageAry;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
