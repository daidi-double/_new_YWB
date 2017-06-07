//
//  MovieDetailViewController.m
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "ChooseMovieHeaderView.h"
#import "CommentTableViewCell.h"
#import "CinemaCharacteristicTableViewCell.h"
#import "MovieDetailHeaderView.h"
//#import "CommentModel.h"
#import "ChooseMovieHeaderView.h"//第一区头部
#import "CommendViewController.h"
#import "FilmDetailTableViewCell.h"


#define FILMDETAILCELL @"FilmDetailTableViewCell"
//#define COMMENTCELl111 @"CommentTableViewCell"
#define CinemaCell123 @"CinemaCharacteristicTableViewCell"
@interface MovieDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MovieDetailHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic,strong) MovieDetailHeaderView * headerView;
@property (nonatomic,strong) ChooseMovieHeaderView* firstHeaderView;
@property (nonatomic,strong) CommentModel * model;
@property (nonatomic,strong) NSMutableArray * commentAry;
@property (nonatomic,strong)UILabel * textLabel;
@property (nonatomic,strong) UIButton * commentBtn;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self makeUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)makeUI{
    self.title = @"影片详情";
    [self.detailTableView registerNib:[UINib nibWithNibName:CinemaCell123 bundle:nil] forCellReuseIdentifier:CinemaCell123];
    
    [self.detailTableView registerNib:[UINib nibWithNibName:FILMDETAILCELL bundle:nil] forCellReuseIdentifier:FILMDETAILCELL];
}
//- (void)setRJRefresh {
//    
//    self.detailTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        //        self.pages=0;
//        self.commentAry=[NSMutableArray array];
//        [self requestData];
//        
//    }];
//    
//    //上拉刷新
//    self.detailTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        //        self.pages++;
//        [self requestData];
//        
//    }];
//    [self.detailTableView.mj_header beginRefreshing];
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
    return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return [MovieDetailHeaderView getHeaderHeight:self.cinemaDetailModel.intro];
    }
    return kScreen_Height* 0.3f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 0.01f;
    }
    return 40.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        self.firstHeaderView.model = self.cinemaDetailModel;
        self.firstHeaderView.status = 1;
        self.firstHeaderView.backgroundColor = [UIColor whiteColor];
        return self.firstHeaderView;
    }else{
        CGFloat height = [MovieDetailHeaderView getHeaderHeight:self.cinemaDetailModel.intro];
        _headerView = [[MovieDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
        _headerView.delegate =self;
        _headerView.model = self.cinemaDetailModel;
        return _headerView;
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        FilmDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FILMDETAILCELL];
        
        return cell;
    }else{
        CinemaCharacteristicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CinemaCell123];
        
        NSArray * imageAry = [self.cinemaDetailModel.stills componentsSeparatedByString:@","];
        cell.imageAry = imageAry;
        return cell;

    }
    
}

#pragma mark ---http
- (void)requestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_MOVIEDETAIL];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"filmNo":self.filmCode,@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数%@    %@",pragrams,urlStr);
        MyLog(@"影片详情%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            //头部影片数据
            [self.commentAry removeAllObjects];
                self.cinemaDetailModel = [CinemaAndBuyTicketModel yy_modelWithDictionary:data[@"data"][@"filmDetail"]];
        
            //评论部分数据

            
        }
        [self.detailTableView reloadData];
    }];
//    [self.detailTableView.mj_header endRefreshing];
//    [self.detailTableView.mj_footer endRefreshing];
}

- (void)toComment{
    CommendViewController * commendVC = [[CommendViewController alloc]init];
    commendVC.film_code = self.filmCode;
    commendVC.headerModel = self.cinemaDetailModel;
    [self.navigationController pushViewController:commendVC animated:YES];
}
- (MovieDetailHeaderView*)headerView{
    if (!_headerView) {
        CGFloat height = [MovieDetailHeaderView getHeaderHeight:self.cinemaDetailModel.intro];
        _headerView = [[MovieDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
        _headerView.delegate =self;
    }
    return _headerView;
}
- (ChooseMovieHeaderView *)firstHeaderView{
    if (!_firstHeaderView) {
        _firstHeaderView = [[ChooseMovieHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height * 0.3f)];
        
    }
    return _firstHeaderView;
}
- (NSMutableArray *)commentAry{
    if (!_commentAry) {
        _commentAry = [NSMutableArray array];
    }
    return _commentAry;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toCommentScore{
    CommendViewController * commendVC = [[CommendViewController alloc]init];
    commendVC.headerModel = self.cinemaDetailModel;
//    commendVC.order_id = //在我的订单中评价才需要
    [self.navigationController pushViewController:commendVC animated:YES];
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
