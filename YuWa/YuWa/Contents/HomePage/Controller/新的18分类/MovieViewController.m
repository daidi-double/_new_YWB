//
//  MovieViewController.m
//  YuWa
//
//  Created by double on 2017/2/15.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieViewController.h"
#import "HotMovieScrollView.h"//轮播scrollview
#import "HotMovieCollectCell.h"
#import "CinemaCell.h"
#import "ChooseMovieController.h"
#import "DetaliViewController.h"
#import "LookAllViewController.h"
#import "MovieCinemaViewController.h"
#import "LookDetaliViewController.h"
#import "NewSearchViewController.h"//需要修改
#import "TableBGView.h"
#import "OtherTicketModel.h"
#import "NewHotMovieCollectCell.h"


#import "HotMovieModel.h"//热映电影model
#import "BannerModel.h"//轮播图模型
#import "MovieHeaderModel.h"


#define newHotCell  @"NewHotMovieCollectCell"

@interface MovieViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,HotMovieScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIButton * markBtn;
    NSInteger  markIndexPath;
    UIPageControl * _page;
    NSIndexPath * markTableIndexPath;
    TableBGView * tableViewBG;
    UIView * menuBG;
    HotMovieScrollView * hotScrollView;
}

@property (nonatomic,strong) UITableView * movieTableView;
@property (nonatomic,strong) NSMutableArray * theaterNameAry;//影城名称数据
@property (nonatomic,strong) NSMutableArray * hotMovieSAry;//轮播热映数组
@property (nonatomic,strong) NSMutableArray * hotCollectDataAry;//热映影片数组
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,copy)NSString * cinema_code;//影院编码
@property (nonatomic,copy)NSString * cityCode;//城市编码
@property (nonatomic,strong) UICollectionView *movieCollectView;
@property (nonatomic,assign)BOOL isselected;
@property (nonatomic,strong)NSMutableArray * otherTicketAry;//通兑票数组
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"电影";


    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * searchBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_homepage_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchMovie)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    
    [self.view addSubview:self.movieTableView];
    [self setRJRefresh];
    [self requestBannerData];
    [self requestHotData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)setRJRefresh {
    
    self.movieTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        self.pages=0;
//        self.tableViewDatasModel=[NSMutableArray array];
//        [self getTableViewAllDatas];
        
    }];
    
    //上拉刷新
    self.movieTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        self.pages++;
//        [self getTableViewAllDatas];
        
    }];

}
#pragma mark - tableViewDelete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _theaterNameAry.count;

        return 10;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height * 0.7f)];
    headerView.backgroundColor = RGBCOLOR(240, 244, 240, 1);
    
    //轮播图
    hotScrollView = [[HotMovieScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, headerView.size.height * 0.4f-15) andDataAry:self.hotMovieSAry];
    hotScrollView.contentSize = CGSizeMake(self.hotMovieSAry.count*kScreen_Width, headerView.size.height * 0.4f);//容量要根据数据修改
    hotScrollView.delegate = self;
    hotScrollView.pagingEnabled = YES;
    hotScrollView.HotDelegate = self;
    hotScrollView.showsHorizontalScrollIndicator = NO;
    [headerView addSubview:hotScrollView];
    
    UIPageControl * moviePage = [[UIPageControl alloc]initWithFrame:CGRectMake(0, headerView.size.height * 0.3f, kScreen_Width, 30)];
    moviePage.numberOfPages = self.hotMovieSAry.count;//修改
    moviePage.currentPage = 0;
    moviePage.currentPageIndicatorTintColor = [UIColor redColor];
    moviePage.pageIndicatorTintColor = [UIColor whiteColor];
    [headerView addSubview:moviePage];
    [moviePage addTarget:self action:@selector(pageController:) forControlEvents:UIControlEventValueChanged];
    if (self.timer == nil) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    }
    
    _page = moviePage;
    
    
    UIView * hotMovieBGView = [[UIView alloc]initWithFrame:CGRectMake(0, hotScrollView.bottom, kScreen_Width, headerView.size.height*0.07f)];
    hotMovieBGView.backgroundColor = [UIColor whiteColor];
    
    
    [headerView addSubview: hotMovieBGView];
    UILabel * hotLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, kScreen_Width/2, hotMovieBGView.size.height)];
    hotLbl.textAlignment = NSTextAlignmentLeft;
    hotLbl.textColor = RGBCOLOR(123, 124, 125, 1);
    hotLbl.font = [UIFont systemFontOfSize:15];
    hotLbl.text = @"热映影片";
    
    [hotMovieBGView addSubview:hotLbl];
    
    UIButton * lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookBtn.frame = CGRectMake(kScreen_Width*0.75-12, 5, kScreen_Width*0.25, hotMovieBGView.size.height);
    [lookBtn setTitle:@"全部 >" forState:UIControlStateNormal];
    [lookBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [lookBtn addTarget:self action:@selector(lookAll:) forControlEvents:UIControlEventTouchUpInside];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [hotMovieBGView addSubview:lookBtn];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.movieCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, hotMovieBGView.bottom, kScreen_Width, headerView.size.height*0.57f-35) collectionViewLayout:layout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    
    [_movieCollectView registerNib:[UINib nibWithNibName:newHotCell bundle:nil] forCellWithReuseIdentifier:newHotCell];
    _movieCollectView.backgroundColor = [UIColor whiteColor];
    _movieCollectView.delegate = self;
    _movieCollectView.dataSource = self;
    [headerView addSubview:_movieCollectView];
    
    UIView * btnBGView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.height -30, kScreen_Width, 30)];
    btnBGView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:btnBGView];
    
    NSArray * titleAry = @[@"全城",@"离我最近",@"特色"];
    CGFloat btnWidth = (kScreen_Width-6)/3;
    for (int i = 0; i<3; i++) {
        UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake((btnWidth+3)*i, 0 ,btnWidth , 30);
        selectBtn.tag = 1111 + i;
        selectBtn.backgroundColor = [UIColor whiteColor];
        [selectBtn setTitle:titleAry[i] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_normal.png"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_selected"] forState:UIControlStateSelected];
        [selectBtn setTitleColor:RGBCOLOR(32, 184, 230, 1) forState:UIControlStateSelected];
        [selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [selectBtn addTarget:self action:@selector(menuBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i != 1) {
            [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
        }else{
            [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
        }
        
        if (_isselected == 0) {
            selectBtn.selected = NO;
        }
        [btnBGView addSubview:selectBtn];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(selectBtn.right+1, 10, 1, 10)];
        line.centerY = btnBGView.height/2;
        line.backgroundColor = RGBCOLOR(234, 234, 234, 1);
        [btnBGView addSubview:line];
        if (i == 2) {
            line.hidden = YES;
        }
    }
    
    
    return headerView;


    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return kScreen_Height * 0.7f;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 70.f;
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self judgeIsContentOtherTicket:self.cinema_code];//修改
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        CinemaCell * cinemaCell = [[CinemaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cinemaCell"  andDataAry:self.theaterNameAry];
        cinemaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cinemaCell;
    

}
#pragma mark - collectViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hotCollectDataAry.count;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreen_Width-35)/3, kScreen_Height*0.3f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    markIndexPath = indexPath.item;
    HotMovieModel * model = self.hotCollectDataAry[indexPath.item];
    //注意修改
    ChooseMovieController * choseVC = [[ChooseMovieController alloc]init];
    choseVC.filmCode = model.code;
    [self.navigationController pushViewController:choseVC animated:YES];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewHotMovieCollectCell * collectCell = (NewHotMovieCollectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:newHotCell forIndexPath:indexPath];
    HotMovieModel * model = self.hotCollectDataAry[indexPath.item];
    collectCell.model = model;

    return collectCell;
}

#pragma mark - requestData
//轮播图
- (void)requestBannerData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_HOMEPAGE];
//    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:nil compliation:^(id data, NSError *error) {
        MyLog(@"电影轮播图%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            for (NSDictionary * dict in data[@"data"]) {
                
                BannerModel* model = [BannerModel yy_modelWithDictionary:dict];
                [self.hotMovieSAry addObject:model];
            }
        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.movieTableView reloadData];
    }];
    [self.movieTableView.mj_header endRefreshing];
    [self.movieTableView.mj_footer endRefreshing];
    
}
//热映电影
- (void)requestHotData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_HOMEHOTMOVIE];

    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:nil compliation:^(id data, NSError *error) {
        MyLog(@"电影首页热门影片%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.hotCollectDataAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                
                HotMovieModel* model = [HotMovieModel yy_modelWithDictionary:dict];
                [self.hotCollectDataAry addObject:model];
            }
        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.movieCollectView reloadData];
    }];
    [self.movieTableView.mj_header endRefreshing];
    [self.movieTableView.mj_footer endRefreshing];
    
}

//判断是否含有通兑票
- (void)judgeIsContentOtherTicket:(NSString*)cinema_code{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_JUDGECONTENTOTHERTICKET];
    
    self.cityCode = @"110100";
    cinema_code = @"01010071";
    NSDictionary * pragrams = @{@"cityNo":self.cityCode,@"cinemaNo":cinema_code};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"是否有通兑票 %@",data);
        [self.otherTicketAry removeAllObjects];
        if ([data[@"errorCode"] integerValue] == 0) {
            for (NSDictionary * dict in data[@"data"]) {
                OtherTicketModel * model = [OtherTicketModel yy_modelWithDictionary:dict];
                [self.otherTicketAry addObject:model];
                
            }
            //需要重新判断
            
            MovieCinemaViewController * movieVC = [[MovieCinemaViewController alloc]init];

            movieVC.status = 1;

            [self.navigationController pushViewController:movieVC animated:YES];
        }else{
            MovieCinemaViewController * movieVC = [[MovieCinemaViewController alloc]init];
            
            movieVC.status = 0;
            
            [self.navigationController pushViewController:movieVC animated:YES];

        }
        
    }];

}


- (void)lookAll:(UIButton*)btn{
    NSLog(@"查看全部");
    LookAllViewController * lookAllView = [[LookAllViewController alloc]init];
    [self.navigationController pushViewController:lookAllView animated:YES];
}
//- (void)lookDetail:(UIButton*)sender{
//    NSLog(@"查看详情");
//    LookDetaliViewController * lookVC = [[LookDetaliViewController alloc]init];
//    [self.navigationController pushViewController:lookVC animated:YES];
//}

- (void)searchMovie{
    NewSearchViewController*vc=[[NewSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)menuBtn:(UIButton*)btn{
    NSLog(@"%ld",btn.tag);
    if (btn.selected == YES) {
        return;
    }
    btn.selected = YES;
    markBtn.selected = NO;
    markBtn = btn;
    [_movieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
    if (menuBG) {
        [menuBG removeFromSuperview];
    }

    menuBG = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationHeight, kScreen_Width, kScreen_Height)];
    menuBG.backgroundColor = RGBCOLOR(195, 202, 203, 0.3);
    [self.view addSubview:menuBG];
    UITapGestureRecognizer*cancelFirstObject=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelFirstObject:)];
    cancelFirstObject.numberOfTouchesRequired = 1;
    cancelFirstObject.numberOfTapsRequired = 1;
    cancelFirstObject.delegate= self;
    menuBG.contentMode = UIViewContentModeScaleToFill;
    [menuBG addGestureRecognizer:cancelFirstObject];
    
    if (tableViewBG) {
        [tableViewBG removeFromSuperview];
    }
    tableViewBG = [[TableBGView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height * 0.7f) andTag:btn.tag] ;
    tableViewBG.backgroundColor = [UIColor whiteColor];
    
    [menuBG addSubview:tableViewBG];
    
    


}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击的view的类名
    //    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)cancelFirstObject:(UIGestureRecognizer*)tap{
    [tap.view removeFromSuperview];
    _isselected = 0;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    [_movieTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)timer:(NSTimer*)timer{
    static int a = 0;
    
    hotScrollView.contentOffset = CGPointMake((a%self.hotMovieSAry.count)*kScreen_Width, 0);
    _page.currentPage = a%self.hotMovieSAry.count;//修改
    a++;
   
}
- (void)pageController:(UIPageControl*)page{
    hotScrollView.contentOffset = CGPointMake(_page.currentPage * kScreen_Width, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _page.currentPage = scrollView.contentOffset.x/kScreen_Width;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 懒加载
- (UITableView *)movieTableView {
    
    if (!_movieTableView) {
        _movieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight, kScreen_Width, kScreen_Height-NavigationHeight) style:UITableViewStyleGrouped];
        _movieTableView.delegate = self;
        _movieTableView.dataSource = self;
        _movieTableView.backgroundColor = [UIColor lightGrayColor];
//        _movieTableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _movieTableView;
}

- (NSMutableArray *)theaterNameAry{
    
    if (!_theaterNameAry) {
        _theaterNameAry = [NSMutableArray array];
    }
    return _theaterNameAry;
}
- (NSMutableArray*)hotMovieSAry{
    if (!_hotMovieSAry) {
        _hotMovieSAry = [NSMutableArray array];
    }
    return _hotMovieSAry;
}

- (NSMutableArray*)hotCollectDataAry{
    if (!_hotCollectDataAry) {
        _hotCollectDataAry = [NSMutableArray array];
    }
    return _hotCollectDataAry;
}

- (NSMutableArray*)otherTicketAry{
    if (!_otherTicketAry) {
        _otherTicketAry = [NSMutableArray array];
    }
    return _otherTicketAry;
}
- (void)pushToDetailPage:(NSInteger)tag{
    DetaliViewController * detaliVC = [[DetaliViewController alloc]init];
    detaliVC.markTag = tag;
    [self.navigationController pushViewController:detaliVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
