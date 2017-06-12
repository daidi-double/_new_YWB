//
//  OtherTicketPayViewController.m
//  YuWa
//
//  Created by double on 17/5/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketPayViewController.h"
#import "OtherTicketPayTableViewCell.h"
#import "PCPayViewController.h"
#import "CouponModel.h"
#import "UseCouponViewController.h"

#define TICKETPAYCELL  @"OtherTicketPayTableViewCell"
@interface OtherTicketPayViewController ()<UITableViewDelegate,UITableViewDataSource,OtherTicketPayTableViewCellDelegate,UseCouponViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *settmentMoneyLabel;
@property (weak, nonatomic) IBOutlet UITableView *payTableView;
@property (nonatomic,strong) UITextField * iPhoneNumberTF;
@property (nonatomic,assign) NSInteger ticketNumber;
@property (nonatomic,assign) BOOL is_coupon;//是否使用优惠券
@property (nonatomic,assign)CGFloat coupon_money;//优惠券金额
@property (nonatomic,copy)NSString * orderID;//订单号
@property (nonatomic,copy)NSString * total_money;//返回的需要支付的金额
@property (nonatomic,copy)NSString * pay_money;//返回的实际支付金额
@property (nonatomic,copy)NSString * coupon_id;
@property (nonatomic,assign)CGFloat shouldPay_money;//需要支付的金额
@end

@implementation OtherTicketPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.title = @"通兑券确认";
    self.ticketNumber = 0;
    self.is_coupon = 0;
    self.coupon_money = 0;
    self.settmentMoneyLabel.text = @"待结算￥0.00";
}

- (void)makeUI{
    [self.payTableView registerNib:[UINib nibWithNibName:TICKETPAYCELL bundle:nil] forCellReuseIdentifier:TICKETPAYCELL];
    self.view.backgroundColor = RGBCOLOR(240, 240, 240, 1);

 }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 135.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherTicketPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TICKETPAYCELL];
    cell.selectionStyle = NO;
    cell.delegate = self;
    self.payTableView.separatorStyle = NO;
    cell.model = self.model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
    UILabel * markLaber = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width -50, 30)];
    markLaber.centerX = kScreen_Width/2;
    markLaber.textColor = RGBCOLOR(110, 112, 113, 1);
    markLaber.font = [UIFont systemFontOfSize:13];
    markLaber.text = @"取票码已发送至如下手机号，请注意查收";
    [footView addSubview:markLaber];
    self.iPhoneNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(25, 60, kScreen_Width - 50, 45)];
    _iPhoneNumberTF.text = [NSString stringWithFormat:@"    手机号:%@",[UserSession instance].account];
    _iPhoneNumberTF.textColor = RGBCOLOR(124, 124, 125, 1);
    _iPhoneNumberTF.enabled = NO;
    _iPhoneNumberTF.font = [UIFont systemFontOfSize:15];
    _iPhoneNumberTF.backgroundColor = [UIColor whiteColor];
    _iPhoneNumberTF.layer.masksToBounds = YES;
    _iPhoneNumberTF.layer.cornerRadius = 5;
    [footView addSubview:_iPhoneNumberTF];

    return footView;
}
//去结算
- (IBAction)toPayAction:(UIButton *)sender {
    //先生成订单号
    [self getOrderID];
}
//使用优惠券
-(void)useCouponActionTouch:(UIButton *)sender{
    UseCouponViewController * useVC = [[UseCouponViewController alloc]init];
    useVC.shop_id = self.cinemaCode;
    useVC.delegate = self;
    useVC.couponType = 1;//标识是电影
    useVC.total_money = [NSString stringWithFormat:@"%@",self.total_money];
    
    [self.navigationController pushViewController:useVC animated:YES];
}

//使用了优惠券
- (void)DelegateGetCouponInfo:(CouponModel *)model{
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
    OtherTicketPayTableViewCell * cell = (OtherTicketPayTableViewCell*)[_payTableView cellForRowAtIndexPath:path];
    self.is_coupon = YES;
    self.coupon_id = model.coupon_id ;
    cell.discountMoneyLabel.text = [NSString stringWithFormat:@"优惠:￥%@",model.discount_fee];
    [cell.couponBtn setTitle:[NSString stringWithFormat:@"满%@抵%@",model.min_fee,model.discount_fee] forState:UIControlStateNormal];
    
    NSString*aa=model.discount_fee;
    self.coupon_money=[aa floatValue];
    [self accountPayMoney];
    [self.payTableView reloadData];
    
    
    
}

//计算所需要支付的金额
-(void)accountPayMoney{
    self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",self.shouldPay_money - self.coupon_money];
    
}
-(void)reduceOrAddTicket:(NSInteger)status{

    [self.payTableView reloadData];
    switch (status) {
        case 1:
        {
            CGFloat settmentMoney = [[self.settmentMoneyLabel.text substringFromIndex:4] floatValue];
            self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",settmentMoney +[self.model.price floatValue]/100];
            self.shouldPay_money = settmentMoney +[self.model.price floatValue]/100;
            self.ticketNumber = self.ticketNumber +1;
        }
            break;
            
        default:
        {
            CGFloat settmentMoney = [[self.settmentMoneyLabel.text substringFromIndex:4] floatValue];
            self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",settmentMoney - [self.model.price floatValue]/100];
            self.shouldPay_money = settmentMoney - [self.model.price floatValue]/100;
            self.ticketNumber = self.ticketNumber -1;
        }
            break;
    }
}

- (void)getOrderID{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_GETORDERID];
    NSString * number = [NSString stringWithFormat:@"%zi",self.ticketNumber];
    NSString * isCoupon = [NSString stringWithFormat:@"%d",self.is_coupon];
    NSString * coupon_moneyStr = [NSString stringWithFormat:@"%.2f",self.coupon_money];
    //有效期转时间戳
   NSString * day = [JWTools dateTimeStrDate:[self.model.validDays integerValue]];
    
    
    NSDictionary * pragrams = @{@"mobile":[UserSession instance].account,@"ticketNo":self.model.ticketNo,@"ticketName":self.model.ticketName,@"devicePos":self.model.devicePos,@"validateMemo":self.model.validateMemo,@"price":self.model.price,@"count":number,@"cinema_code":self.cinemaCode,@"is_coupon":isCoupon,@"coupon_money":coupon_moneyStr,@"show_type":self.model.showType,@"period_validity":day,@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"percentage":self.model.percentage,@"per_price":self.model.per_price};
   
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if (self.is_coupon) {
        [dic setValue:self.coupon_id forKey:@"coupon_id"];
        
    }
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",dic);
        MyLog(@"通兑票订单%@",data);
        if ([data[@"errorCode"] integerValue]== 0) {
            self.orderID = data[@"data"][@"id"];
            self.pay_money = data[@"data"][@"pay_money"];
            self.total_money= data[@"data"][@"total_money"];
            PCPayViewController * pcVC = [PCPayViewController sharedManager];
            pcVC.blanceMoney = [self.total_money floatValue];
            pcVC.status = 2;
            pcVC.order_id = [self.orderID floatValue];
            pcVC.shop_ID = self.cinemaCode;
            pcVC.orderCode = data[@"data"][@"order_code"];
            [self.navigationController pushViewController:pcVC animated:YES];
        }
        
     }];
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
