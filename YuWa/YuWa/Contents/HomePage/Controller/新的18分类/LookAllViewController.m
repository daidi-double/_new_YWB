//
//  LookAllViewController.m
//  YuWa
//
//  Created by double on 2017/2/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "LookAllViewController.h"
#import "NSDictionary+Attributes.h"
#import "RecommendScrollView.h"//预告片推荐
#import "WillPlayMovieCell.h"
#import "ChooseMovieController.h"
#import "NewAllMovieTableViewCell.h"//所有电影
#import "HotMovieModel.h"

#define ALLMOVIECELL  @"NewAllMovieTableViewCell"
@interface LookAllViewController ()<UITableViewDelegate,UITableViewDataSource,NewAllMovieTableViewCellDeletage>
{
    NSIndexPath * markIndexPath;
}
@property (nonatomic,strong)UISegmentedControl * segmentedControl;
@property (nonatomic,assign)NSInteger status;//0正在热映 1即将上映
@property (nonatomic,strong) UITableView * leftTableView;

@property (nonatomic,strong) NSMutableArray * movieArr;//电影数组
@property (nonatomic,strong)NSMutableArray * recommendArr;//预告片推荐数组
@property (nonatomic,strong)NSMutableArray * headerViewAry;//上映影院和购票数组
//@property (nonatomic,assign)NSInteger pages;//页数
//@property (nonatomic,assign)NSInteger pagen;//每页的条数默认10条；
@end

@implementation LookAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentedControl = [self makeSegmentedControl];
    self.navigationItem.titleView = self.segmentedControl;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.status = 0;

    [self initWithTableView];
    [self requesetAllMovieData];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (UISegmentedControl *)makeSegmentedControl{
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"正在热映",@"即将上映"]];
    segmentControl.frame = CGRectMake(0.f, 0.f, ACTUAL_WIDTH(180.f), 30.f);
    segmentControl.tintColor = [UIColor whiteColor];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5.f;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentControl.layer.borderWidth = 2.f;
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    return segmentControl;
}

- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex;
   
    if (sender.selectedSegmentIndex == 0) {
//        self.rightTableView.hidden = YES;
//        self.leftTableView.hidden = NO;
        [self requesetAllMovieData];
    }else{
 
//        self.leftTableView.hidden = YES;
//        self.rightTableView.hidden = NO;
        [self requestWillPlayMovie];
    }
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

        return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return self.movieArr.count;//修改

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 125;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.status == 0) {
        
        ChooseMovieController * chooseMC  = [[ChooseMovieController alloc]init];
        chooseMC.markRow = indexPath.row;
        HotMovieModel * model = self.movieArr[indexPath.row];
        chooseMC.filmCode = model.code;
        chooseMC.filmName = model.name;
        chooseMC.cityCode = @"350500";//先固定为泉州地区，后续若要修改可以修改
        chooseMC.coordinatey = self.coordinatey;
        chooseMC.coordinatex = self.coordinatex;
        [self.navigationController pushViewController:chooseMC animated:YES];
    }else{
        //预售
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewAllMovieTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ALLMOVIECELL];
    HotMovieModel * model = self.movieArr[indexPath.row];
    cell.status = self.status;
    cell.deletage = self;
    cell.model = model;
    return cell;
}
- (void)initWithTableView{
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NavigationHeight, kScreen_Width, kScreen_Height-NavigationHeight) style:UITableViewStyleGrouped];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    [self.view addSubview:_leftTableView];
    [_leftTableView registerNib:[UINib nibWithNibName:ALLMOVIECELL bundle:nil] forCellReuseIdentifier:ALLMOVIECELL];
    
}

//代理
-(void)toBuyTicket:(UIButton *)sender{
    ChooseMovieController * chooseMC  = [[ChooseMovieController alloc]init];
    NewAllMovieTableViewCell * cell = (NewAllMovieTableViewCell*)[[sender superview] superview];
    NSIndexPath * path = [self.leftTableView indexPathForCell:cell];
    chooseMC.markRow = path.row;
    cell.deletage =self;
    HotMovieModel * model = self.movieArr[path.row];
    chooseMC.filmCode = model.code;
    chooseMC.filmName = model.name;
    chooseMC.cityCode = @"350500";//先固定地区
    chooseMC.coordinatey = self.coordinatey;
    chooseMC.coordinatex = self.coordinatex;
    [self.navigationController pushViewController:chooseMC animated:YES];
}

#pragma mark - http
- (void)requesetAllMovieData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_ALLHOTMOVIE];
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:nil compliation:^(id data, NSError *error) {
        MyLog(@"热映电影%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.movieArr removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                HotMovieModel * model = [HotMovieModel yy_modelWithDictionary:dict];
                [self.movieArr addObject:model];
            }
            [self.leftTableView reloadData];
        }else{
            [JRToast showWithText:@"网络超时,请检查网络" duration:1];
        }
    }];
}

//即将上映
- (void)requestWillPlayMovie{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_WILLPLAYMOVIE];
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:nil compliation:^(id data, NSError *error) {
        MyLog(@"即将电影%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.movieArr removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                HotMovieModel * model = [HotMovieModel yy_modelWithDictionary:dict];
                [self.movieArr addObject:model];
            }
            [self.leftTableView reloadData];
        }else{
            [JRToast showWithText:@"网络超时,请检查网络" duration:1];
        }
    }];

}
#pragma mark - 懒加载

- (NSMutableArray*)recommendArr{
    if (!_recommendArr) {
        _recommendArr = [NSMutableArray array];
    }
    return _recommendArr;
}
- (NSMutableArray*)movieArr{
    if (!_movieArr) {
        _movieArr = [NSMutableArray array];
    }
    return _movieArr;
}
- (NSMutableArray*)headerViewAry{
    if (!_headerViewAry) {
        _headerViewAry = [NSMutableArray array];
    }
    return _headerViewAry;
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
