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
@property (nonatomic,strong)NSMutableArray * imageAry;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIImageView * bgImageView;;
@end
@implementation CinemaHeaderView

- (instancetype)initWithFrame:(CGRect)frame andAry:(NSMutableArray *)moviesAry{
    self = [super initWithFrame:frame];
    if (self) {
        [self requestHeaderData];
        self.movies = moviesAry;
 
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
- (void)setModel:(CinemaHeaderModel *)model{
    _model = model;
    [self setdata];
}

- (void)setdata{
    _cinemaName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0, self.height * 0.2f)];
    _cinemaName.textColor =RGBCOLOR(147, 146, 146, 1);
    _cinemaName.font = [UIFont systemFontOfSize:15];
    _cinemaName.text = self.model.cinema_name;
    CGSize size = [self sizeWithSt:_cinemaName.text font:_cinemaName.font];
    _cinemaName.frame = CGRectMake(10, 0, size.width, self.height * 0.17f);
    self.touchView = [[UIView alloc]initWithFrame:_cinemaName.frame];
    [self addSubview:_touchView];
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToCinemaDetail)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    tapGes.delegate = self;
    [_touchView addGestureRecognizer:tapGes];
    [self addSubview:_cinemaName];
    
    _address = [[UILabel alloc]initWithFrame:CGRectMake(10, self.cinemaName.height, kScreen_Width * 0.6f, self.height * 0.15f)];
    _address.textColor = [UIColor lightGrayColor];
    _address.numberOfLines = 0;
    _address.font = [UIFont systemFontOfSize:12];
    _address.text = self.model.address;

    [self addSubview:_address];
    
    
    _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressBtn.frame = CGRectMake(self.width-45, self.height*0.1, 30, 30);
    [_addressBtn setImage:[UIImage imageNamed:@"导航"] forState:UIControlStateNormal];
    [_addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, -15, 0)];
    
    [_addressBtn addTarget:self action:@selector(locationAddress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addressBtn];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _addressBtn.bottom, 30, 25)];
    titleLabel.text = @"导航";
    titleLabel.textColor = CNaviColor;
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
    _score.text = [NSString stringWithFormat:@"%@分",self.model.score];
    _score.font = [UIFont systemFontOfSize:15];
    [self addSubview:_score];
    
//    _bgImageView.image = [Acceleecet boxblurImage:[UIImage imageNamed:@"baobaoBG0"] withBlurNumber:0.9];
    
    
    
    _BGScrollView = [[UIView alloc]initWithFrame:CGRectMake(0,titleLabel.bottom +10, kScreen_Width, self.height *0.55f)];

    //        _BGScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_BGScrollView];
    
    ViscosityLayout * layout = [[ViscosityLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _movieCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,titleLabel.bottom +20, kScreen_Width, self.height * 0.5f-10) collectionViewLayout:layout];
    
    [_movieCollectView registerClass:[MoviePicCollectionViewCell class] forCellWithReuseIdentifier:MOVIECELL1];
    [_movieCollectView registerNib:[UINib nibWithNibName:MOVIECELL1 bundle:nil] forCellWithReuseIdentifier:MOVIECELL1];
    
    _movieCollectView.dataSource = self;
    _movieCollectView.delegate = self;
    _movieCollectView.backgroundColor = [UIColor clearColor];
    
    
    _movieCollectView.showsVerticalScrollIndicator = NO;
    _movieCollectView.showsHorizontalScrollIndicator = NO;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, titleLabel.bottom +10, kScreen_Width, _BGScrollView.height -10)];
   
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.alpha = 0.8;
    [self addSubview:toolbar];
    [self addSubview:_movieCollectView];

}
#pragma mark - collectViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.flimListAry.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    collectionView.contentOffset = CGPointMake(80*indexPath.item, 0);
    
    //调用请求数据方法刷新数据
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoviePicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MOVIECELL1 forIndexPath:indexPath];

//    if (self.movies.count>0) {
        FilmListModel * filmModel = self.flimListAry[indexPath.item];
        [cell.movieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",filmModel.image]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self.imageAry addObject:cell.movieImageView.image];
        
//    }

    
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height -10)];
        
        
        [_BGScrollView addSubview:_bgImageView];
        _BGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height -10)];
        ;
        
        _BGroundView.image = [UIImage imageNamed:@"横条.png"];
        [_bgImageView addSubview:_BGroundView];
        


    }
    
    _bgImageView.image = self.imageAry[self.index];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX;
    for (int i = 0; i<self.flimListAry.count; i++) {
        offsetX = 80*i;
        if (scrollView.mj_offsetX == offsetX) {
            self.index = i;
        }
    }
   
    FilmListModel * filmModel = self.flimListAry[_index];
    _movieTitle.text = filmModel.name;
    [self.delegate filmName:filmModel.name];
    CGSize movieTitleSize = [self sizeWithSt:_movieTitle.text font:_movieTitle.font];
    _movieTitle.width = movieTitleSize.width;
    self.movieScore.text = [NSString stringWithFormat:@"%@分",filmModel.score];
    self.movieScore.frame = CGRectMake(_movieTitle.origin.x + _movieTitle.width+10, _BGScrollView.height,40, _BGScrollView.height * 0.2f);
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height)];
        
        
        [_BGScrollView addSubview:_bgImageView];
        _BGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height)];
        ;
        NSString * path = [[NSBundle mainBundle]pathForResource:@"横条" ofType:@"png"];
        _BGroundView.image = [UIImage imageWithContentsOfFile:path];
        [_bgImageView addSubview:_BGroundView];
        
        
    }
    
    _bgImageView.image = self.imageAry[self.index];
    
 
}

#pragma mark -- http
//头部视图数据
- (void)requestHeaderData{
    
    
    
    self.cinema_code = @"01010071";
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMAHEADER];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"cinema_code":self.cinema_code};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
        
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"影院头部2%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.flimListAry removeAllObjects];
            NSArray * ary = data[@"data"][@"filmList"];
            if (![ary isKindOfClass:[NSNull class]]) {
            for (int i = 0; i <ary.count; i ++ ) {
                
                    
                    FilmListModel * filmModel = [FilmListModel yy_modelWithDictionary:ary[i]];
                    [self.flimListAry addObject:filmModel];
                    if (i == 0) {
                        self.movieTitle.text = filmModel.name;
                        CGSize movieTitleSize = [self sizeWithSt:_movieTitle.text font:_movieTitle.font];
                        _movieTitle.frame = CGRectMake(0, _BGScrollView.height-10, movieTitleSize.width, _BGScrollView.height*0.3f);
                        _movieTitle.centerX = self.width/2 - 15;
                         self.movieScore.text = [NSString stringWithFormat:@"%@分",filmModel.score];
                    
                }
             }
            }
    
        }else{
            [JRToast showWithText:@"网络错误，请检查网络" duration:1];
        }
        [self.movieCollectView reloadData];
    }];
    
}

- (BOOL)judgeLogin{
   
    return [UserSession instance].isLogin;
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

- (NSMutableArray *)movies{
    if (!_movies) {
        _movies = [NSMutableArray array];
    }
    return _movies;
}
- (NSMutableArray *)imageAry{
    if (!_imageAry) {
        _imageAry = [NSMutableArray array];
    }
    return _imageAry;
}

- (NSMutableArray *)flimListAry{
    if (!_flimListAry) {
        _flimListAry = [NSMutableArray array];
    }
    return _flimListAry;
}

- (UILabel*)movieTitle{
    if (!_movieTitle) {
        _movieTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, _BGScrollView.height * 0.3f)];
        CGSize movieTitleSize = [self sizeWithSt:_movieTitle.text font:_movieTitle.font];
        _movieTitle.frame = CGRectMake(0, _BGScrollView.height-10, movieTitleSize.width, _BGScrollView.height*0.3f);
        _movieTitle.centerX = self.width/2 - 15;
        _movieTitle.textColor = [UIColor blackColor];
        _movieTitle.font = [UIFont systemFontOfSize:15];
        [_BGScrollView addSubview:_movieTitle];

    }
    return _movieTitle;
}
- (UILabel*)movieScore{
    if (!_movieScore) {
        _movieScore = [[UILabel alloc]initWithFrame:CGRectMake(_movieTitle.origin.x + _movieTitle.width+10, _BGScrollView.height,40, _BGScrollView.height * 0.2f)];
        _movieScore.textColor = [UIColor lightGrayColor];
        _movieScore.font = [UIFont systemFontOfSize:13];
        [_BGScrollView addSubview:_movieScore];
    }
    return _movieScore;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
