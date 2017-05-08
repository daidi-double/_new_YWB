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
#import "PlayTimeCell.h"
#import "CinemaHeaderView.h"//影院的头部视图
#import "ChooseSeatController.h"//选座
#import "SeeMovieCell.h"
#import "ShopDetaliViewController.h"
#import "LocationViewController.h"
#import "YWLoginViewController.h"
@interface MovieCinemaViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CinemaHeaderViewDelegate>
{
    UIView * lineView;
}

@property (nonatomic,strong)UITableView * movieTableView;

@end

@implementation MovieCinemaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影院";//修改为电影名称

    [self.view addSubview:self.movieTableView];
//    UIBarButtonItem * shareBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtn)];
//    UIBarButtonItem * collectBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_grayStar@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(collectBtn)];
//    NSArray * ary = @[collectBtn,shareBtn];
//    self.navigationItem.rightBarButtonItems = ary;
    // Do any additional setup after loading the view from its nib.
}

- (UITableView*)movieTableView{
    if (!_movieTableView) {
        _movieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _movieTableView.delegate = self;
        _movieTableView.dataSource = self;
        
    }
    return _movieTableView;
}
- (void)collectBtn{
    NSLog(@"收藏");
}
- (void)shareBtn{
    NSLog(@"分享");
}
#pragma mark - tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;//修改
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height *0.5f;
        
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row != 0) {
        return 60.f;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        return 25.f;
    }else{
        return 44.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        //需要判断下有无小吃；
        CinemaHeaderView * headerBGview = [[CinemaHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.5f)];
        headerBGview.delegate =self;
        return headerBGview;
    }else{
        return nil;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0 && indexPath.row != 0) {
        
        ChooseSeatController * chooseSeat = [[ChooseSeatController alloc]init];
        [self.navigationController pushViewController:chooseSeat animated:YES];
    }else if (indexPath.section == 1 && indexPath.row != 0){
        ShopDetaliViewController * shopVC = [[ShopDetaliViewController alloc]init];
        [self.navigationController pushViewController:shopVC animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"movieTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"movieTableViewCell"];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
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
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height-2, kScreen_Width/3, 2)];
        lineView.backgroundColor = CNaviColor;
        [cell.contentView addSubview:lineView];
        for (int j = 0; j<3; j++) {
            UIButton * dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            dateBtn.frame = CGRectMake(10 + kScreen_Width/3*j, 0, kScreen_Width/3, cell.height);
            dateBtn.tag = j +1;
            [dateBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:dateBtn];
            dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [dateBtn setTitle:arr[j] forState:UIControlStateNormal];
        
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0){
        PlayTimeCell * cell = [[PlayTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayTimeCell"] ;
        //        cell.backgroundColor = [UIColor greenColor];
        
        _buy_ticket = [UIButton buttonWithType:UIButtonTypeCustom];
        _buy_ticket.frame = CGRectMake(kScreen_Width*0.8f, 20, kScreen_Width/5, cell.height/2);

        [_buy_ticket setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buy_ticket setTitle:@"购票" forState:UIControlStateNormal];
        _buy_ticket.titleLabel.font = [UIFont systemFontOfSize:14];
        [_buy_ticket addTarget:self action:@selector(goToBuyTicket) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_buy_ticket];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 1&&indexPath.row == 0){
        cell.textLabel.text = @"观影套餐";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        SeeMovieCell * cell = [[SeeMovieCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SeeMovieCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)chooseDate:(UIButton*)sender{
    NSLog(@"%ld",(long)sender.tag);
    
    lineView.x = sender.x;
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
   
    LocationViewController * locationVC = [[LocationViewController alloc]init];
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
