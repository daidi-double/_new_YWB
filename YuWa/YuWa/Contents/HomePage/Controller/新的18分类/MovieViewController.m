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
#import "CinameTableViewCell.h"
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


#import "HomeCinemaListModel.h"//影院模型

#define newHotCell  @"NewHotMovieCollectCell"
#define CINEMASHOWCELL @"CinameTableViewCell"
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
@property (nonatomic,strong) NSMutableArray * theaterNameAry;//影城列表数据
@property (nonatomic,strong) NSMutableArray * hotMovieSAry;//轮播热映数组
@property (nonatomic,strong) NSMutableArray * hotCollectDataAry;//热映影片数组
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,copy)NSString * cinema_code;//影院编码
@property (nonatomic,copy)NSString * cityCode;//城市编码
@property (nonatomic,copy)NSString * type;//地区类型：1单个地区，0是全部地区
@property (nonatomic,copy)NSString * typeList;//0：离我最近 1，价格最低，2好评优先
@property (nonatomic,strong) UICollectionView *movieCollectView;
@property (nonatomic,assign)BOOL isselected;
@property (nonatomic,strong)NSMutableArray * otherTicketAry;//通兑票数组
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger pagen;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"电影";

    self.pagen = 10;
    self.pages = 0;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * searchBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_homepage_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchMovie)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    self.type = @"0";
    self.typeList = @"0";
    [self.view addSubview:self.movieTableView];
    [self.movieTableView registerNib:[UINib nibWithNibName:CINEMASHOWCELL bundle:nil] forCellReuseIdentifier:CINEMASHOWCELL];
    [self setRJRefresh];
    [self requestBannerData];
    [self requestHotData];
    [self getlocatCityCode];
    [self getHomePageCinemaList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)setRJRefresh {
    
    self.movieTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.theaterNameAry=[NSMutableArray array];
        [self getHomePageCinemaList];
        
    }];
    
    //上拉刷新
    self.movieTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getHomePageCinemaList];
        
    }];

}
#pragma mark - tableViewDelete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.theaterNameAry.count;


}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //轮播图
    hotScrollView = [[HotMovieScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.headerView.size.height * 0.4f-15) andDataAry:self.hotMovieSAry];
    hotScrollView.contentSize = CGSizeMake(self.hotMovieSAry.count*kScreen_Width, _headerView.size.height * 0.4f);//容量要根据数据修改
    hotScrollView.delegate = self;
    hotScrollView.pagingEnabled = YES;
    hotScrollView.HotDelegate = self;
    hotScrollView.showsHorizontalScrollIndicator = NO;
    [_headerView addSubview:hotScrollView];
    
    UIPageControl * moviePage = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _headerView.size.height * 0.3f, kScreen_Width, 30)];
    moviePage.numberOfPages = self.hotMovieSAry.count;//修改
    moviePage.currentPage = 0;
    moviePage.currentPageIndicatorTintColor = [UIColor redColor];
    moviePage.pageIndicatorTintColor = [UIColor whiteColor];
    [_headerView addSubview:moviePage];
    [moviePage addTarget:self action:@selector(pageController:) forControlEvents:UIControlEventValueChanged];
    if (self.timer == nil) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    }
    
    _page = moviePage;
    
    
    UIView * hotMovieBGView = [[UIView alloc]initWithFrame:CGRectMake(0, hotScrollView.bottom, kScreen_Width, _headerView.size.height*0.07f)];
    hotMovieBGView.backgroundColor = [UIColor whiteColor];
    
    
    [_headerView addSubview: hotMovieBGView];
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
    self.movieCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, hotMovieBGView.bottom, kScreen_Width, _headerView.size.height*0.57f-35) collectionViewLayout:layout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    [_movieCollectView registerNib:[UINib nibWithNibName:newHotCell bundle:nil] forCellWithReuseIdentifier:newHotCell];
    _movieCollectView.backgroundColor = [UIColor whiteColor];
    _movieCollectView.delegate = self;
    _movieCollectView.dataSource = self;
    [_headerView addSubview:_movieCollectView];
    
    
    return self.headerView;


    
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
    CinemaModel * model = self.theaterNameAry[indexPath.row];
    [self judgeIsContentOtherTicket:model.code];//修改
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CinameTableViewCell * cinemaCell = [tableView dequeueReusableCellWithIdentifier:CINEMASHOWCELL];
    cinemaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CinemaModel * model = self.theaterNameAry[indexPath.row];
    cinemaCell.model = model;
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
    choseVC.filmName = model.name;
    choseVC.coordinatex = self.coordinatex;
    choseVC.coordinatey = self.coordinatey;
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
            if (self.otherTicketAry.count <= 0) {
                MovieCinemaViewController * movieVC = [[MovieCinemaViewController alloc]init];
                
                movieVC.status = 0;
                
                [self.navigationController pushViewController:movieVC animated:YES];

            }else{
                MovieCinemaViewController * movieVC = [[MovieCinemaViewController alloc]init];
                
                movieVC.status = 1;
                
                [self.navigationController pushViewController:movieVC animated:YES];
            }
        }else{
            
        }
        
    }];

}
//获取地区编码
- (void)getlocatCityCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CITYCODE];
    
    self.cityCode = @"110100";
    NSDictionary * pragrams = @{@"area":self.cityCode,@"type":self.type};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"地区编码 %@",data);
        
        
    }];
    
}
//获取首页影院列表
- (void)getHomePageCinemaList{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_HOME_CINEMALIST];
    
    self.cityCode = @"110100";
    NSDictionary * pragrams = @{@"area":self.cityCode,@"type":self.type,@"device_id":[JWTools getUUID],@"typeList":self.typeList,@"pages":@(self.pages),@"pagen":@(self.pagen),@"coordinatex":self.coordinatex,@"coordinatey":self.coordinatey};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([UserSession instance].isLogin) {
        [dic setValue:[UserSession instance].token forKey:@"toke"];
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
    }
    
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"首页影院列表 %@",data);
        MyLog(@"参数%@",dic);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.theaterNameAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                CinemaModel * model = [CinemaModel yy_modelWithDictionary:dict];
                [self.theaterNameAry addObject:model];
            }
            [self.movieTableView reloadData];
        }else{
            [JRToast showWithText:@"网络异常,请检查网络" duration:1];
        }
        [self.movieTableView.mj_header endRefreshing];
        [self.movieTableView.mj_footer endRefreshing];
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
//    if (btn.selected == YES) {
//        return;
//    }
    btn.selected = YES;
    markBtn.selected = NO;
    markBtn = btn;
    if (self.theaterNameAry.count>0) {
        
        [_movieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
   
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
    
    __weak typeof(btn)weakBtn = btn;
    __weak typeof(menuBG)weakMenuBG = menuBG;
    WEAKSELF;
    tableViewBG.titleBlock = ^(NSString *titleStr,NSString * cityCode){
        weakBtn.selected = NO;
        [weakBtn setTitle:titleStr forState:UIControlStateNormal];
        [weakMenuBG removeFromSuperview];
        if ([titleStr isEqualToString:@"全部地区"]) {
            weakSelf.type = @"0";
        }else{
            weakSelf.type = @"1";
        }
        [weakSelf getHomePageCinemaList];
    };
    [menuBG addSubview:tableViewBG];
    
    


}
//取消手势冲突
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
        _movieTableView.backgroundColor = [UIColor whiteColor];

    }
    return _movieTableView;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height * 0.7f)];
        _headerView.backgroundColor = RGBCOLOR(240, 244, 240, 1);
        
        UIView * btnBGView = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.height -30, kScreen_Width, 30)];
        btnBGView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:btnBGView];
        
        NSArray * titleAry = @[@"全部地区",@"离我最近"];
        CGFloat btnWidth = (kScreen_Width-6)/2;
        for (int i = 0; i<2; i++) {
            UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame = CGRectMake((btnWidth+3)*i, 0 ,btnWidth , 30);
            selectBtn.tag = 1111 + i;
            selectBtn.backgroundColor = [UIColor whiteColor];
            [selectBtn setTitle:titleAry[i] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_normal.png"] forState:UIControlStateNormal];
            [selectBtn setTitleColor:CNaviColor forState:UIControlStateSelected];
            [selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [selectBtn addTarget:self action:@selector(menuBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
            
            
            if (_isselected == 0) {
                selectBtn.selected = NO;
            }
            [btnBGView addSubview:selectBtn];
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(selectBtn.right+1, 10, 1, 10)];
            line.centerY = btnBGView.height/2;
            line.backgroundColor = RGBCOLOR(234, 234, 234, 1);
            [btnBGView addSubview:line];
            if (i == 1) {
                line.hidden = YES;
            }
        }

    }
    return _headerView;
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
