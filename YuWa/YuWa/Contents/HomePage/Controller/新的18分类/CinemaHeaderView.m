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

        self.movies = moviesAry;
 
    }
    return self;
}
- (void)setModel:(CinemaHeaderModel *)model{
    _model = model;
    [self setdata];
}

- (void)setdata{
    [self requestHeaderData];
    _cinemaName = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 0, self.height * 0.2f)];
    _cinemaName.textColor =[UIColor colorWithHexString:@"#333333"];
    _cinemaName.font = [UIFont systemFontOfSize:15];
    _cinemaName.text = self.model.cinema_name;
    CGSize size = [self sizeWithSt:_cinemaName.text font:_cinemaName.font];
    _cinemaName.frame = CGRectMake(12, 0, size.width, kScreen_Height* 114/1334.f);
    self.touchView = [[UIView alloc]initWithFrame:_cinemaName.frame];
    [self addSubview:_touchView];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(12, _cinemaName.bottom, kScreen_Width-24, 0.5)];
    line1.backgroundColor = RGBCOLOR(234, 235, 236, 1);
    [self addSubview:line1];
    
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToCinemaDetail)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    tapGes.delegate = self;
    [_touchView addGestureRecognizer:tapGes];
    [self addSubview:_cinemaName];
    
    _address = [[UILabel alloc]initWithFrame:CGRectMake(10, line1.bottom+16, kScreen_Width * 0.6f, [self sizeWithSt:self.model.address font:[UIFont systemFontOfSize:13]].height)];
    _address.textColor = [UIColor colorWithHexString:@"#999999"];
    _address.numberOfLines = 0;
    _address.font = [UIFont systemFontOfSize:12];
    _address.text = self.model.address;

    [self addSubview:_address];
    
    
    _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressBtn.frame = CGRectMake(self.width-45, self.cinemaName.y, 30, 30);
    [_addressBtn setImage:[UIImage imageNamed:@"home_locate@2x.png"] forState:UIControlStateNormal];
    [_addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, -15, 0)];
    
    [_addressBtn addTarget:self action:@selector(locationAddress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addressBtn];
    
    _iphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _iphoneBtn.frame = CGRectMake(self.width-45, self.address.y, 30, 30);
    [_iphoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [_iphoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, -15, 0)];
    
    [_iphoneBtn addTarget:self action:@selector(iphoneNumer) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iphoneBtn];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(kScreen_Width-65, line1.bottom+10, 0.5, kScreen_Height*114/1334-20)];
    line2.backgroundColor = RGBCOLOR(234, 235, 236, 1);
    line2.centerY = _addressBtn.centerY;
    [self addSubview:line2];
    
    UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_addressBtn.left-30, self.cinemaName.height - 30, 10, 15)];
    rightImageView.centerY = _addressBtn.centerY;
    rightImageView.image = [UIImage imageNamed:@"common_icon_arrow"];
    [self addSubview:rightImageView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(kScreen_Width-65, 10, 0.5, kScreen_Height*114/1334-20)];
    line.backgroundColor = RGBCOLOR(234, 235, 236, 1);
    line.centerY = _addressBtn.centerY;
    [self addSubview:line];
    

    _BGScrollView = [[UIView alloc]initWithFrame:CGRectMake(0,self.address.bottom +16, kScreen_Width, kScreen_Height*452/1334)];

    [self addSubview:_BGScrollView];
    
    ViscosityLayout * layout = [[ViscosityLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _movieCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,self.address.bottom +16, kScreen_Width, kScreen_Height*452/1334) collectionViewLayout:layout];
    
    [_movieCollectView registerClass:[MoviePicCollectionViewCell class] forCellWithReuseIdentifier:MOVIECELL1];
    [_movieCollectView registerNib:[UINib nibWithNibName:MOVIECELL1 bundle:nil] forCellWithReuseIdentifier:MOVIECELL1];
    
    _movieCollectView.dataSource = self;
    _movieCollectView.delegate = self;
    _movieCollectView.backgroundColor = [UIColor clearColor];
    
    
    _movieCollectView.showsVerticalScrollIndicator = NO;
    _movieCollectView.showsHorizontalScrollIndicator = NO;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.address.bottom +16, kScreen_Width, _BGScrollView.height)];
   
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
    FilmListModel * filmModel = self.flimListAry[indexPath.item];
    [self.delegate filmName:filmModel.name andIndex:_index andfilmCode:filmModel.code];
    self.movieTitle.text = filmModel.name;
    CGSize movieTitleSize = [self sizeWithSt:_movieTitle.text font:_movieTitle.font];
    _movieTitle.frame = CGRectMake(0, _BGScrollView.height, movieTitleSize.width, _BGScrollView.height*0.3f);
    self.movieScore.frame = CGRectMake(_movieTitle.origin.x + _movieTitle.width+10, _BGScrollView.height,40, _BGScrollView.height * 0.2f);
    self.durationLabel.frame = CGRectMake(_movieTitle.origin.x, self.movieTitle.bottom+20,kScreen_Width/2, _BGScrollView.height * 0.3f);
    self.durationLabel.text = [NSString stringWithFormat:@"时长:%@分钟",filmModel.duration];
    //调用请求数据方法刷新数据
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(75, kScreen_Height*312/1334*0.8f);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoviePicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MOVIECELL1 forIndexPath:indexPath];

        FilmListModel * filmModel = self.flimListAry[indexPath.item];
        [cell.movieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",filmModel.image]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self.imageAry addObject:cell.movieImageView.image];

    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height)];
        
        
        [_BGScrollView addSubview:_bgImageView];
        _BGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height)];
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
        offsetX = 115*i;
        if (scrollView.mj_offsetX == offsetX) {
            self.index = i;
        }
    }

    FilmListModel * filmModel = self.flimListAry[_index];
    _movieTitle.text = filmModel.name;
    CGSize movieTitleSize = [self sizeWithSt:_movieTitle.text font:_movieTitle.font];
    _movieTitle.width = movieTitleSize.width;
    self.movieScore.text = [NSString stringWithFormat:@"%@分",filmModel.score];
    self.movieScore.frame = CGRectMake(_movieTitle.origin.x + _movieTitle.width+10, _BGScrollView.height,40, _BGScrollView.height * 0.2f);
    self.durationLabel.frame = CGRectMake(_movieTitle.origin.x, self.movieTitle.bottom+20,kScreen_Width/2, _BGScrollView.height * 0.3f);
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height)];
        
        
        [_BGScrollView addSubview:_bgImageView];
        _BGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _BGScrollView.height)];
        ;
        _BGroundView.image = [UIImage imageNamed:@"横条"];
        [_bgImageView addSubview:_BGroundView];
        
        
    }
    
    _bgImageView.image = self.imageAry[self.index];
    
 
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    FilmListModel * filmModel = self.flimListAry[_index];
    [self.delegate filmName:filmModel.name andIndex:_index andfilmCode:filmModel.code];
    self.movieTitle.text = filmModel.name;
    CGSize movieTitleSize = [self sizeWithSt:_movieTitle.text font:_movieTitle.font];
    _movieTitle.frame = CGRectMake(12, _BGScrollView.height, movieTitleSize.width, _BGScrollView.height*0.3f);
    self.movieScore.frame = CGRectMake(_movieTitle.origin.x + _movieTitle.width+10, _BGScrollView.height,40, _BGScrollView.height * 0.2f);
    self.movieScore.text = [NSString stringWithFormat:@"%@分",filmModel.score];
    self.durationLabel.frame = CGRectMake(_movieTitle.origin.x, self.movieTitle.bottom+20,kScreen_Width/2, _BGScrollView.height * 0.3f);
    self.durationLabel.text = [NSString stringWithFormat:@"时长:%@分钟",filmModel.duration];
}
#pragma mark -- http
//头部视图数据
- (void)requestHeaderData{
    
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
                        _movieTitle.frame = CGRectMake(12, _BGScrollView.height, movieTitleSize.width, _BGScrollView.height*0.3f);
                        self.movieScore.frame = CGRectMake(_movieTitle.origin.x + _movieTitle.width+10, _BGScrollView.height,40, _BGScrollView.height * 0.2f);
                         self.movieScore.text = [NSString stringWithFormat:@"%@分",filmModel.score];
                        self.durationLabel.frame = CGRectMake(_movieTitle.origin.x, self.movieTitle.bottom+20,kScreen_Width/2, _BGScrollView.height * 0.3f);
                        self.durationLabel.text = [NSString stringWithFormat:@"时长:%@分钟",filmModel.duration];
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
    CGRect rect = [string boundingRectWithSize:CGSizeMake(kScreen_Width * 0.6f, kScreen_Height * 114/1334.f)options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font}context:nil];
    
    return rect.size;
}
- (void)locationAddress{
    NSLog(@"定位");
    [self.delegate ToLocation];
}
//拨打电话
-(void)iphoneNumer{
    
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
        _movieTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 0, _BGScrollView.height * 0.3f)];
        _movieTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _movieTitle.font = [UIFont systemFontOfSize:13];
        [_BGScrollView addSubview:_movieTitle];

    }
    return _movieTitle;
}
- (UILabel*)movieScore{
    if (!_movieScore) {
        _movieScore = [[UILabel alloc]initWithFrame:CGRectMake(_movieTitle.origin.x + _movieTitle.width+10, _BGScrollView.height,40, _BGScrollView.height * 0.2f)];
        _movieScore.textColor = [UIColor colorWithHexString:@"#f6c018"];
        _movieScore.font = [UIFont systemFontOfSize:13];
        [_BGScrollView addSubview:_movieScore];
    }
    return _movieScore;
}
- (UILabel*)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(_movieTitle.origin.x, self.movieTitle.bottom+20,kScreen_Width/2, _BGScrollView.height * 0.3f)];
        _durationLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _durationLabel.font = [UIFont systemFontOfSize:13];
        [_BGScrollView addSubview:_durationLabel];
    }
    return _durationLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
