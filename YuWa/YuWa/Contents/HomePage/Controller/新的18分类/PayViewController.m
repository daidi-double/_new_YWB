//
//  PayViewController.m
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PayViewController.h"
#import "MoviePayTableViewCell.h"
#import "TotalMoneyTableViewCell.h"
#import "MarkTableViewCell.h"
#import "UseCouponViewController.h"
#import "PCPayViewController.h"

#define MARKCELL00  @"MarkTableViewCell"
#define TOTALCELL @"TotalMoneyTableViewCell"
#define PAYCELL  @"MoviePayTableViewCell"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource,UseCouponViewControllerDelegate,UIGestureRecognizerDelegate>
{
    NSIndexPath * markPath;
}
@property (nonatomic,strong) NSMutableArray * dataAry;
@property (nonatomic,strong) UITableView * payInforTableView;
@property (nonatomic,strong) UILabel * settomLabel;
@property (nonatomic,assign) CGFloat payMoney;//需要支付的金额
@property (nonatomic,assign)BOOL is_useCoupon;
@property (nonatomic,copy)NSString * coupon_id;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger second;
@property (nonatomic,assign)NSInteger minute;
@property (nonatomic,strong)UILabel * timerLabel;
@property (nonatomic,assign) CGFloat couponMoney;//优惠券金额
@property (nonatomic,strong) UILabel * useCouponLabel;
@property (nonatomic,assign) BOOL is_cancel;//取消代理
@end

@implementation PayViewController
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (UILabel*)useCouponLabel{
    if (!_useCouponLabel) {
        _useCouponLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width * 0.6, 10, kScreen_Width * 0.45f, 30)];
        _useCouponLabel.textColor = RGBCOLOR(143, 144, 145, 1);
        _useCouponLabel.font = [UIFont systemFontOfSize:15];
        _useCouponLabel.text = @"使用优惠券";
    }
    return _useCouponLabel;
}
- (instancetype)initWithDataArray:(NSMutableArray *)ary{
    self = [super init];
    if (self) {
        [self.dataAry addObjectsFromArray:ary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   self.title =@"支付订单";
    self.view.backgroundColor = [UIColor whiteColor];
    MyLog(@"%ld----%@",self.dataAry.count,self.dataAry);
    [self makeUI];
    [self showMessage:@"选座票购买后无法退换，请仔细核对购票信息"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)popToPage{
  
   [self quitPayPage];

}
#pragma mark - 倒计时

- (void)quitPayPage{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您选择场次信息已过期或者支付超时，请重新选座购买" preferredStyle:UIAlertControllerStyleAlert];

      [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          [self.navigationController popViewControllerAnimated:YES];
      }]];
    [self presentViewController:controller animated:YES completion:nil];

}
- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        
    }
    
    self.timerLabel.text = [NSString stringWithFormat:@"电影订单 %ld:%ld",(long)self.minute,(long)self.second];
    if (self.second==0 && self.minute==0 ) {
        [self.timer invalidate];
        self.timer = nil;
        [self quitPayPage];
        
    }
}
-(void)showMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];

}
- (void)makeUI{
    _payInforTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-50) style:UITableViewStyleGrouped];
    _payInforTableView.delegate = self;
    _payInforTableView.dataSource = self;
    
    [_payInforTableView registerNib:[UINib nibWithNibName:PAYCELL bundle:nil] forCellReuseIdentifier:PAYCELL];
    [_payInforTableView registerNib:[UINib nibWithNibName:TOTALCELL bundle:nil] forCellReuseIdentifier:TOTALCELL];
    [_payInforTableView registerNib:[UINib nibWithNibName:MARKCELL00 bundle:nil] forCellReuseIdentifier:MARKCELL00];
    
    [self.view addSubview:_payInforTableView];
    self.timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, kScreen_Width/2, 100)];
    
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    self.second = 59;
    self.minute = 14;
    self.navigationItem.titleView = self.timerLabel;
    
    
    UIView * accountBGView = [[UIView alloc]initWithFrame:CGRectMake(0, _payInforTableView.bottom, kScreen_Width, 50)];
    accountBGView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:accountBGView];
    
    _settomLabel = [[UILabel alloc]initWithFrame:CGRectMake(24,10, kScreen_Width * 0.4f, 30)];
    _settomLabel.textColor = CNaviColor;
    _settomLabel.text = @"待结算 ￥0.00";
    _settomLabel.font = [UIFont systemFontOfSize:15];
    
    [accountBGView addSubview:_settomLabel];
    
    UIButton * accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accountBtn.frame = CGRectMake(accountBGView.width * 0.65f, 0, accountBGView.width * 0.35f, 50);
    accountBtn.backgroundColor = CNaviColor;
    accountBtn.titleLabel.textColor = [UIColor whiteColor];
    [accountBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [accountBtn addTarget:self action:@selector(toAccountAction) forControlEvents:UIControlEventTouchUpInside];
    [accountBGView addSubview:accountBtn];
    
    
}
//去结算，支付
- (void)toAccountAction{
    PCPayViewController * pcVC = [[PCPayViewController alloc]init];
    pcVC.blanceMoney = self.payMoney;
    pcVC.shop_ID = self.shop_id;
    pcVC.order_id = self.order_id;
    [self.navigationController pushViewController:pcVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }else if (section == 1){
        return 1;
    }else{
        return 0;//根据小吃套餐修改
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 100;
        }else if (indexPath.row == 3){
            return 88.f;
        }
        return 50.f;
    }
    return 50.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"payCell"];
    }

    if (indexPath.section == 0) {
        if (indexPath.row !=0 ||indexPath.row !=3||indexPath.row !=5) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 0) {
            MoviePayTableViewCell * payCell = [tableView dequeueReusableCellWithIdentifier:PAYCELL];
             payCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return payCell;
        }else if (indexPath.row == 1){
            cell.textLabel.textColor = RGBCOLOR(142, 143, 144, 1);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = @"优惠券抵用";
            
            [cell.contentView addSubview:self.useCouponLabel];
            markPath = indexPath;
        }else if (indexPath.row == 2){
            cell.textLabel.textColor = RGBCOLOR(142, 143, 144, 1);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text =@"商家优惠";
        }else if (indexPath.row == 3){
            TotalMoneyTableViewCell * totalCell = [tableView dequeueReusableCellWithIdentifier:TOTALCELL];
            NSString * totalMoney = [totalCell.totalMoneyLabel.text substringFromIndex:1];
            totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.payMoney = [totalMoney floatValue];
            return totalCell;
        }else if (indexPath.row == 4){
            cell.textLabel.textColor = CNaviColor;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text =@"办理会员卡本单立减16元";
        }else {
            MarkTableViewCell * markCell1 = [tableView dequeueReusableCellWithIdentifier:MARKCELL00];
            markCell1.otherLabel.hidden = YES;
            UIImageView * otherImageView = [markCell1 viewWithTag:3];
            otherImageView.hidden = YES;
            markCell1.selectionStyle = UITableViewCellSelectionStyleNone;
            return markCell1;
        }
    }else if (indexPath.section == 1){
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = RGBCOLOR(143, 144, 145, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString * threeStr = [[UserSession instance].account substringToIndex:3];
        NSString * fourStr = [[UserSession instance].account substringFromIndex:[UserSession instance].account.length-4];
        cell.textLabel.text = [NSString stringWithFormat:@"%@****%@",threeStr,fourStr];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        UseCouponViewController * useVC = [[UseCouponViewController alloc]init];
        useVC.shop_id = self.shop_id;
        useVC.delegate = self;
            
            useVC.total_money = [NSString stringWithFormat:@"%.2f",self.payMoney];

        [self.navigationController pushViewController:useVC animated:YES];

    }else if (indexPath.row == 2) {
        
    }else if (indexPath.row == 4) {
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10  ;
    }
    return  0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
//计算所需要支付的金额
-(void)accountPayMoney{
    self.settomLabel.text = [NSString stringWithFormat:@"待结算%.2f",self.payMoney - self.couponMoney];
}

//使用了优惠券
- (void)DelegateGetCouponInfo:(CouponModel *)model{
    UITableViewCell * cell = [_payInforTableView cellForRowAtIndexPath:markPath];
    self.is_useCoupon = YES;
    self.coupon_id = model.coupon_id ;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"满%@抵%@",model.min_fee,model.discount_fee];

    NSString*aa=model.discount_fee;
    self.couponMoney=[aa floatValue];
    
    
    
    [self accountPayMoney];
    [self.payInforTableView reloadData];
    

 
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
