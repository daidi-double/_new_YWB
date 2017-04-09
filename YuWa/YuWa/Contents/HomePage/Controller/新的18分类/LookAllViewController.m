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
@interface LookAllViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath * markIndexPath;
}
@property (nonatomic,strong)UISegmentedControl * segmentedControl;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong) UITableView * leftTableView;
@property (nonatomic,strong) UITableView * rightTableView;
@property (nonatomic,strong) NSMutableArray * tableViewTitleArr;//表格的区头名字
@property (nonatomic,strong) NSMutableArray * movieArr;//电影数组
@property (nonatomic,strong)NSMutableArray * recommendArr;//预告片推荐数组
@property (nonatomic,strong)NSMutableArray * headerViewAry;//上映影院和购票数组
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
    
    // Do any additional setup after loading the view.
}
- (UISegmentedControl *)makeSegmentedControl{
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"全部热映",@"即将上映"]];
    segmentControl.frame = CGRectMake(0.f, 0.f, ACTUAL_WIDTH(180.f), 30.f);
    segmentControl.tintColor = [UIColor whiteColor];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5.f;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentControl.layer.borderWidth = 2.f;
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [segmentControl addTarget:self action:@selector(HotMovieControlAction:) forControlEvents:UIControlEventValueChanged];
    return segmentControl;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.status == 0) {
        return 1;
    }else{
        return self.tableViewTitleArr.count;//修改
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.status == 0) {
         NSLog(@"self.status =%ld",self.status);
        return 10;//修改
    }else{
         NSLog(@"self.status  right =%ld",self.status);
        if (section == 0) {
            return 1;
        }
        return 3;//修改
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.status != 0) {
        return 30;
    }
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 80;
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.status != 0) {
        UIView * BGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
        BGview.backgroundColor = [UIColor lightGrayColor];
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, kScreen_Width/3, 30)];
        title.text = self.tableViewTitleArr[section];
        title.textAlignment = 0;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:14];
        [BGview addSubview:title];
        return BGview;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ChooseMovieController * chooseMC  = [[ChooseMovieController alloc]initWithAry:self.movieArr];
    chooseMC.markRow = indexPath.row;
    [self.navigationController pushViewController:chooseMC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"allMovieTableView"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"allMovieTableView"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.status == 0) {
        WillPlayMovieCell * cell = [[WillPlayMovieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"willPlayMovieCell" andDataAry:self.movieArr];
        _sellBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _sellBtn.frame = CGRectMake(kScreen_Width*0.85f, 40, kScreen_Width*0.15f, 22);
        [_sellBtn setTitle:@"预售" forState:UIControlStateNormal];
        [_sellBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
        
        [_sellBtn addTarget:self action:@selector(pushToSellPage:) forControlEvents:UIControlEventTouchUpInside];
        [_sellBtn.layer setBorderColor:(__bridge CGColorRef _Nullable)(CNaviColor)];
        
        [cell.contentView addSubview:_sellBtn];
        return cell;
        
    }else{
        cell.backgroundColor = [UIColor redColor];
        if (indexPath.section == 0 && indexPath.row == 0) {
            RecommendScrollView * recommendScrollView = [[RecommendScrollView alloc]initWithFrame:CGRectMake(5, 7, kScreen_Width-10, 56) andWithArray:self.recommendArr];
            recommendScrollView.contentSize = CGSizeMake(5*(kScreen_Width-10), cell.height-14);
            
            [cell.contentView addSubview:recommendScrollView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else {
            WillPlayMovieCell * cell = [[WillPlayMovieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"willPlayMovieCell" andDataAry:self.movieArr];
            
            _sellBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _sellBtn.frame = CGRectMake(kScreen_Width*0.85f, 40, kScreen_Width*0.15f, 22);
            [_sellBtn setTitle:@"预售" forState:UIControlStateNormal];
            [_sellBtn setTitleColor:CNaviColor forState:UIControlStateNormal];

            [_sellBtn addTarget:self action:@selector(pushToSellPage:) forControlEvents:UIControlEventTouchUpInside];
            [_sellBtn.layer setBorderColor:(__bridge CGColorRef _Nullable)(CNaviColor)];
            [cell.contentView addSubview:_sellBtn];

            return cell;
        }
        
    }
    return cell;
}
- (void)HotMovieControlAction:(UISegmentedControl*)segControl{

        if (segControl.selectedSegmentIndex == 0) {
            [self.leftTableView.mj_header beginRefreshing];
            self.leftTableView.hidden = NO;
            self.rightTableView.hidden = YES;
            self.status = segControl.selectedSegmentIndex;
            [_leftTableView reloadData];

        }else{
            [self.rightTableView.mj_header beginRefreshing];
            _leftTableView.hidden = YES;
            _rightTableView.hidden = NO;
            
            self.status = segControl.selectedSegmentIndex;

            [_rightTableView reloadData];
        }
    
}
- (void)initWithTableView{
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NavigationHeight, kScreen_Width, kScreen_Height-NavigationHeight) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight, kScreen_Width, kScreen_Height-NavigationHeight) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
  
    [self.view addSubview:_rightTableView];
    if (self.status == 0) {
        _rightTableView.hidden = YES;
    }
}
- (void)pushToSellPage:(UIButton *)btn{
    ChooseMovieController * chooseVC = [[ChooseMovieController alloc]initWithAry:self.movieArr];
    [self.navigationController pushViewController:chooseVC animated:YES];
    
    
}
#pragma mark - 懒加载
- (NSMutableArray *)tableViewTitleArr{
    if (!_tableViewTitleArr) {
        _tableViewTitleArr = [NSMutableArray arrayWithObjects:@"预告片推荐",@"近期最受期待",@"2月24日 周五", nil];
    }
    return _tableViewTitleArr;
}

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
