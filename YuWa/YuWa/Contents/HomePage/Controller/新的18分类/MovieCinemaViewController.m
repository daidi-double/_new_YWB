//
//  MovieCinemaViewController.m
//  YuWa
//
//  Created by double on 2017/2/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieCinemaViewController.h"
#import "CinemaDetaliController.h"
#import "FoodViewController.h"
#import "MoviePScrollView.h"
#import "PlayTimeShowTableViewCell.h"
#import "CinemaHeaderView.h"//影院的头部视图
#import "ChooseSeatController.h"//选座
#import "SeeMovieCell.h"
#import "ShopDetaliViewController.h"
//#import "LocationViewController.h"
#import "MapNavNewViewController.h"
#import "YWLoginViewController.h"

#import "CinemaHeaderModel.h"//头部影院信息
#import "FilmListModel.h"//滑动电影信息
#import "FilmShowTimeModel.h"//影院上映的场次


#define PLAYSHOWCELL  @"PlayTimeShowTableViewCell"
@interface MovieCinemaViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CinemaHeaderViewDelegate>
{
    UIView * lineView;
}

@property (nonatomic,strong)UITableView * movieTableView;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,strong)UIView * btnTimeView;
@property (nonatomic,strong) CinemaHeaderModel * headerModel;
@property (nonatomic,strong) NSMutableArray * filmListAry;//滑动部分电影数据
@property (nonatomic,strong) NSMutableArray * filmShowAry;//播放场次电影

@end

@implementation MovieCinemaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影院";//修改为电影名称
    self.time = [JWTools currentTime2];
    [self requestHeaderData];
    [self requestFootData];
    [self.view addSubview:self.movieTableView];

}

- (UITableView*)movieTableView{
    if (!_movieTableView) {
        _movieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _movieTableView.backgroundColor = [UIColor whiteColor];
        _movieTableView.delegate = self;
        _movieTableView.dataSource = self;
        [_movieTableView registerNib:[UINib nibWithNibName:PLAYSHOWCELL bundle:nil] forCellReuseIdentifier:PLAYSHOWCELL];
    }
    return _movieTableView;
}
- (NSMutableArray*)filmListAry{
    if (!_filmListAry) {
        _filmListAry = [NSMutableArray array];
    }
    return _filmListAry;
}

- (NSMutableArray*)filmShowAry{
    if (!_filmShowAry ) {
        _filmShowAry = [NSMutableArray array];
    }
    return _filmShowAry;
}
#pragma mark - tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.filmShowAry.count;//修改
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height *0.46f;
        
    }else{
        return 100.f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 0.01f;
    }else{
        return 55.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {

        CinemaHeaderView * headerBGview = [[CinemaHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.5f)andAry:self.filmListAry];
        headerBGview.cinema_code = self.cinema_code;
        headerBGview.model = self.headerModel;
        headerBGview.movies = self.filmListAry;
        headerBGview.delegate =self;
        return headerBGview;
    }else{

        return self.btnTimeView;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        
        ChooseSeatController * chooseSeat = [[ChooseSeatController alloc]init];
        [self.navigationController pushViewController:chooseSeat animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"movieTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"movieTableViewCell"];
    }
    if (indexPath.section == 1){
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        
        PlayTimeShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:PLAYSHOWCELL];
        cell.accessoryType = UITableViewCellAccessoryNone;
        FilmShowTimeModel * showModel = self.filmShowAry[indexPath.row];
        cell.model = showModel;
        _buy_ticket = [cell viewWithTag:100];
        _buy_ticket.layer.cornerRadius = 5;
        _buy_ticket.layer.borderColor = CNaviColor.CGColor;
        _buy_ticket.layer.borderWidth = 1;
        _buy_ticket.layer.masksToBounds = YES;
        [_buy_ticket addTarget:self action:@selector(goToBuyTicket) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return cell;
}
- (void)chooseDate:(UIButton*)sender{

    lineView.centerX = sender.centerX;
    switch (sender.tag) {
        case 1:
            self.time = [JWTools currentTime2];
            break;
        case 2:
            self.time = [JWTools tommorowTime];
            break;
            
        default:
            self.time = [JWTools getThreeDayTime];
            break;
    }
    [self requestFootData];
}

- (void)goToBuyTicket{
    if ([self judgeLogin]) {
        ChooseSeatController * chooseVC = [[ChooseSeatController alloc]init];
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
   
}
- (void)ToCinemaDetaliPage{
    CinemaDetaliController * detaliVC = [[CinemaDetaliController alloc]init];
    [self.navigationController pushViewController:detaliVC animated:YES];

}
- (void)ToFoodPage{
    FoodViewController * foodVC = [[FoodViewController alloc]init];
    [self.navigationController pushViewController:foodVC animated:YES];
}
- (void)ToLocation{
   
    MapNavNewViewController * locationVC = [[MapNavNewViewController alloc]init];
    locationVC.coordinatex = self.headerModel.longitude;
    locationVC.coordinatey = self.headerModel.latitude;
    locationVC.shopName = self.headerModel.cinema_name;
    [self.navigationController pushViewController:locationVC animated:YES];
  
}
- (void)ToVipDetaliPage{
    MyLog(@"会员卡详情");
}
- (BOOL)judgeLogin{
    if (![UserSession instance].isLogin) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    return [UserSession instance].isLogin;
}
#pragma mark -- http
//头部视图数据
- (void)requestHeaderData{

    self.cinema_code = @"1002062";
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMAHEADER];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"cinema_code":self.cinema_code};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
        
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"影院头部%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            self.headerModel = [CinemaHeaderModel yy_modelWithDictionary:data[@"data"][@"cinemaInfo"]];
            
//            滑动部分的电影
            [self.filmListAry removeAllObjects];
            NSArray * ary = data[@"data"][@"filmList"];
            for (int i = 0; i <ary.count; i ++ ) {

                    FilmListModel * filmModel = [FilmListModel yy_modelWithDictionary:ary[i]];
                    [self.filmListAry addObject:filmModel];
           
            }
            
            
        }else{
            [JRToast showWithText:@"网络错误，请检查网络" duration:1];
        }
        [self.movieTableView reloadData];
    }];
    
}
- (void)requestFootData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMAFOOT];
    
    self.film_code = @"001X00762017";
    self.cinema_code = @"1002062";
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"cinema_code":self.cinema_code,@"film_code":self.film_code,@"time":self.time};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
        
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"电影场次%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {

            [self.filmShowAry removeAllObjects];
                for (NSDictionary * dict in data[@"data"][@"film_showtime"]) {
                    
                    FilmShowTimeModel * showModel = [FilmShowTimeModel yy_modelWithDictionary:dict];
 
                    [self.filmShowAry addObject:showModel];
            }
            
            
        }else{
            [JRToast showWithText:@"网络错误，请检查网络" duration:1];
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.movieTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
}

-(UIView*)btnTimeView{
    if (!_btnTimeView) {

        _btnTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        line.backgroundColor = RGBCOLOR(240, 240, 240, 1);
        [_btnTimeView addSubview:line];
        
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
                btnAfterTitle = [NSString stringWithFormat:@"明日%ld月%ld日",(long)month,(long)day+2];
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
                btnAfterTitle = [NSString stringWithFormat:@"明日%ld月%ld日",(long)month,(long)day+2];
            }
            
        }else{
            
            btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
            btnAfterTitle = [NSString stringWithFormat:@"明日%ld月%ld日",(long)month,(long)day+2];
        }
        
        NSArray * arr = @[btnTitle,btnTitleT,btnAfterTitle];
        
            lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _btnTimeView.height-2, kScreen_Width/3, 2)];
            lineView.backgroundColor = CNaviColor;
            [_btnTimeView addSubview:lineView];

        
        for (int j = 0; j<3; j++) {
            UIButton * dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            dateBtn.frame = CGRectMake(10 + (kScreen_Width/3-3)*j, 1, kScreen_Width/3-3, _btnTimeView.height - 56);
            dateBtn.tag = j +1;
            [dateBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
            [_btnTimeView addSubview:dateBtn];
            dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [dateBtn setTitle:arr[j] forState:UIControlStateNormal];
            
            UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(dateBtn.right+1, _btnTimeView.height - 56, kScreen_Width, 0.5)];
            line3.backgroundColor = RGBCOLOR(240, 240, 240, 1);
            [_btnTimeView addSubview:line3];
            
            if (j == 2) {
                line3.hidden = YES;
            }
            
        }
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _btnTimeView.height - 56, kScreen_Width, 0.5)];
        line2.backgroundColor = RGBCOLOR(240, 240, 240, 1);
        [_btnTimeView addSubview:line2];
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _btnTimeView.height -55.5, kScreen_Width, 55.5)];
        [_btnTimeView addSubview:bgView];
        
        UIImageView * picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 35.5, 35.5)];
        picImageView.image = [UIImage imageNamed:@""];
        [bgView addSubview:picImageView];
        
        UILabel * otherTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(picImageView.right + 20, 0, kScreen_Width * 0.7f, 30)];
        otherTicketLabel.textColor = RGBCOLOR(110, 112, 113, 1);
        otherTicketLabel.centerY = bgView.height/2;
        otherTicketLabel.font = [UIFont systemFontOfSize:14];
        otherTicketLabel.text = @"可观看2D,3D,免预约,可升级";
        [bgView addSubview:otherTicketLabel];
        
        UIImageView * picImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 30, 15, 8, 20)];
        picImageView.centerY = bgView.height/2;
        picImageView2.image = [UIImage imageNamed:@"imageTypeChoose_right"];
        [bgView addSubview:picImageView2];
        UITapGestureRecognizer * otherTicketTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toOtherTicker)];
        otherTicketTap.delegate = self;
        otherTicketTap.numberOfTapsRequired = 1;
        otherTicketTap.numberOfTouchesRequired = 1;
        [bgView addGestureRecognizer:otherTicketTap];
    }
    return _btnTimeView;
}
-(void)toOtherTicker{
    //通兑票
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
