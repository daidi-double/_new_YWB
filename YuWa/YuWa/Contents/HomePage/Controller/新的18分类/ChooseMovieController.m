//
//  ChooseMovieController.m
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChooseMovieController.h"
#import "ChooseMovieHeaderView.h"//电影详情海报
#import "CinemaTimeCell.h"
#import "MovieCinemaViewController.h"
#import "PlayViewController.h"
#import "CommendViewController.h"
#import "TableBGView.h"
#import "MovieDetailViewController.h"
#import "CinemaAndBuyTicketModel.h"

#import "CinemaModel.h"//影院id

@interface ChooseMovieController ()<UITableViewDelegate,UITableViewDataSource,ChooseMovieHeaderViewDelegate,UIGestureRecognizerDelegate>
{
    UIButton * markTimeBtn;
    UIView * lineView;
    UIButton * markBtn;
    NSIndexPath * markIndexPath;
    TableBGView * tableViewBG;
    UIView * menuBG;
    
}
@property (nonatomic,strong) UITableView * movieTableView;
@property (nonatomic,strong) NSMutableArray * headerViewAry;//海报数据
@property (nonatomic,strong) NSMutableArray * movieDataAry;//电影场次数组
@property (nonatomic,assign) BOOL isselected;
@property (nonatomic,assign) NSInteger pages;//页数
@property (nonatomic,assign) NSInteger pagen;
@property (nonatomic,copy) NSString * time;//日期
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) CinemaAndBuyTicketModel * model;
@property (nonatomic,strong) CinemaModel * cinemaModel;//影院model
@end

@implementation ChooseMovieController


- (UITableView*)movieTableView{
    if (!_movieTableView) {
        _movieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _movieTableView.delegate = self;
        _movieTableView.dataSource = self;
        
    }
    return _movieTableView;
}

- (NSMutableArray*)headerViewAry{
    if (!_headerViewAry) {
        _headerViewAry = [NSMutableArray array];
    }
    return _headerViewAry;
}

- (NSMutableArray*)movieDataAry{
    if (!_movieDataAry) {
        _movieDataAry = [NSMutableArray array];
    }
    return _movieDataAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"上映影院和购票";
    [self.view addSubview:self.movieTableView];
    _isselected = 0;
    self.pagen = 10;
    self.pages = 0;
    self.time = [self todayDate];
    [self requestMovieData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        return self.bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kScreen_Height *0.3 + 65.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        return 65.f;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MovieCinemaViewController * MCinemaVC = [[MovieCinemaViewController alloc]init];
    MCinemaVC.cinema_id = self.cinemaModel.id;
    [self.navigationController pushViewController:MCinemaVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CinemaTimeCell * cell = [[CinemaTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cinemaTimeCell" andDataAry:self.movieDataAry];
    cell.model = self.cinemaModel;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
   
}
- (void)chooseDate:(UIButton*)btn{

    MyLog(@"%ld",btn.tag);
    btn.selected = YES;
    markTimeBtn.selected =  NO;
    markTimeBtn = btn;
    lineView.x = btn.x;
    self.pages = 0;
    switch (btn.tag) {
        case 100:
            self.time = [self todayDate];
            break;
        case 101:
            self.time = [self tomorrowDate];

            break;
        case 102:
            self.time = [self threeDayDate];

            break;
        default:
            break;
    }
    MyLog(@"%@",self.time);
    [self requestCinemaData];
    
}
//获取今天的日期
- (NSString *)todayDate{
    return [JWTools currentTime2];
}
- (NSString *)tomorrowDate{
    return [JWTools tommorowTime];
}
- (NSString *)threeDayDate{
    return [JWTools getThreeDayTime];
}
- (void)menuBtn:(UIButton*)btn{
    NSLog(@"%ld",btn.tag);
    if (btn.selected == YES) {
        return;
    }
    
    btn.selected = YES;
    markBtn.selected = NO;
    markBtn = btn;
    [_movieTableView scrollToRowAtIndexPath:markIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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
- (void)tapDetali{
    NSLog(@"详细界面");
    MovieDetailViewController * vc = [[MovieDetailViewController alloc]init];
    vc.filmCode = self.filmCode;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)play{
    PlayViewController * playVC = [[PlayViewController alloc]init];
    
    [self.navigationController pushViewController:playVC animated:YES];
}
-(void)commend{
    CommendViewController * commendVC = [[CommendViewController alloc]init];
    [self.navigationController pushViewController:commendVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//判断是否登入
- (BOOL)judgeLogin{

    return [UserSession instance].isLogin;
}
#pragma mark -- http
- (void)requestMovieData{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMAANDBUYTICKET];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"filmCode":self.filmCode};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
       
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"电影影院和购票%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            self.model = [CinemaAndBuyTicketModel yy_modelWithDictionary:data[@"data"]];
//            [self.headerViewAry addObject:self.model];//数据是空的，所以暂时注释掉
        
        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.movieTableView reloadData];
    }];
//    [self.movieTableView.mj_header endRefreshing];
//    [self.movieTableView.mj_footer endRefreshing];
    
}
//获取影院数据
- (void)requestCinemaData{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMANDDATE];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"filmCode":self.filmCode,@"time":self.time,@"pages":@(self.pages),@"pagen":@(self.pagen)};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
        
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"电影影院和购票，影院数据%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            self.cinemaModel = [CinemaModel yy_modelWithDictionary:data[@"data"]];
            //            [self.headerViewAry addObject:self.model];//数据是空的，所以暂时注释掉
            
        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.movieTableView reloadData];
    }];
    //    [self.movieTableView.mj_header endRefreshing];
    //    [self.movieTableView.mj_footer endRefreshing];
    
}
- (UIView*)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.3f+65.5)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        ChooseMovieHeaderView * movieView = [[ChooseMovieHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.3f)];
        movieView.delegate =self;
        movieView.model = self.model;
        [_bgView addSubview:movieView];
        UITapGestureRecognizer*PrivateTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetali)];
        PrivateTap.numberOfTouchesRequired = 1;
        PrivateTap.numberOfTapsRequired = 1;
        PrivateTap.delegate= self;
        movieView.contentMode = UIViewContentModeScaleToFill;
        [movieView addGestureRecognizer:PrivateTap];
        movieView.backgroundColor = [UIColor darkGrayColor];
        
        NSDate *date = [NSDate date];
        
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        
        NSInteger unitFlags =  kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
        comps = [calendar components:unitFlags fromDate:date];
        
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger year = [comps year];
        NSString *btnTitle =[NSString stringWithFormat:@"今天%ld月%ld日",(long)month,(long)day];
        NSString * btnTitleT;
        NSString * btnAfterTitle;
        if (month == 1|month ==3|month ==5|month ==7|month ==8|month ==10|month ==12) {
            if (day == 30) {
                btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
                btnAfterTitle = [NSString stringWithFormat:@"后天%ld月1日",(long)month+1];
                
            }
            if (day == 31) {
                btnTitleT = [NSString stringWithFormat:@"明天%ld月1日",(long)month+1];
                btnAfterTitle = [NSString stringWithFormat:@"后天%ld月2日",(long)month+1];
                if (month == 12) {
                    btnTitleT = @"明天1月1日";
                    btnAfterTitle = @"后天1月2日";
                }
            }else{
                btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
                btnAfterTitle = [NSString stringWithFormat:@"后天%ld月%ld日",(long)month,(long)day+2];
            }
            
        }else if (year%4 ==0 && month == 2 && day == 29){
            btnTitleT = @"明天3月1日";
            btnAfterTitle = @"后天3月2日";
        }else if (year%4 != 0 && month == 2 && day == 28){
            btnTitleT = @"明天3月1日";
            btnAfterTitle = @"后天3月2日";
        }else if (month == 4|month ==6|month ==9|month ==10|month ==11){
            if (day == 29) {
                btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
                btnAfterTitle = [NSString stringWithFormat:@"后天%ld月1日",(long)month+1];
                
            }else if (day == 30) {
                btnTitleT = [NSString stringWithFormat:@"明天%ld月1日",(long)month+1];
                btnAfterTitle = [NSString stringWithFormat:@"后天%ld月2日",(long)month+1];
            }else{
                
                btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
                btnAfterTitle = [NSString stringWithFormat:@"后天%ld月%ld日",(long)month,(long)day+2];
            }
            
        }else{
            
            btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
            btnAfterTitle = [NSString stringWithFormat:@"后天%ld月%ld日",(long)month,(long)day+2];
        }
        NSArray * arr = @[btnTitle,btnTitleT,btnAfterTitle];
        
        for (int i = 0; i<3; i++) {
            UIButton * timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            timeBtn.frame = CGRectMake(kScreen_Width/3*i, _bgView.height - 65.5, kScreen_Width/3, 35);
            NSString * titleTime = [NSString stringWithFormat:arr[i],i];
            [timeBtn setTitle:titleTime forState:UIControlStateNormal];
            [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            timeBtn.tag = 100 +i;
            timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [timeBtn setTitleColor:RGBCOLOR(33, 184, 230, 1) forState:UIControlStateSelected];
            if (i == 0) {
                timeBtn.selected = YES;
                markTimeBtn = timeBtn;
            }
            [timeBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:timeBtn];
            
        }
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _bgView.height -30.5, kScreen_Width, 0.5)];
        line.backgroundColor = RGBCOLOR(240, 240, 240, 1);
        [_bgView addSubview:line];
        
        
        CGFloat btnWidth = (kScreen_Width-6)/3;
        NSArray * titleAry = @[@"全城",@"离我最近",@"特色"];
        
        for (int i = 0; i<3; i++) {
            UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame = CGRectMake((btnWidth+3)*i, _bgView.height - 30,btnWidth , 30);
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
            [_bgView addSubview:selectBtn];
            
        }

    }
    return _bgView;
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
