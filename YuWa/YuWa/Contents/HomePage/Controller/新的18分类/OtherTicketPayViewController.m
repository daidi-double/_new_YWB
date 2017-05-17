//
//  OtherTicketPayViewController.m
//  YuWa
//
//  Created by double on 17/5/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketPayViewController.h"
#import "OtherTicketPayTableViewCell.h"

#define TICKETPAYCELL  @"OtherTicketPayTableViewCell"
@interface OtherTicketPayViewController ()<UITableViewDelegate,UITableViewDataSource,OtherTicketPayTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *settmentMoneyLabel;
@property (weak, nonatomic) IBOutlet UITableView *payTableView;
@property (nonatomic,strong) UITextField * iPhoneNumberTF;
@end

@implementation OtherTicketPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.title = @"通兑券确认";
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
    return 180.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherTicketPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TICKETPAYCELL];
    cell.selectionStyle = NO;
    cell.delegate = self;
    self.payTableView.separatorStyle = NO;
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
}

-(void)reduceOrAddTicket:(NSInteger)status{

    [self.payTableView reloadData];
    switch (status) {
        case 1:
        {
            CGFloat settmentMoney = [[self.settmentMoneyLabel.text substringFromIndex:4] floatValue];
            self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",settmentMoney +30];
        }
            break;
            
        default:
        {
            CGFloat settmentMoney = [[self.settmentMoneyLabel.text substringFromIndex:4] floatValue];
            self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",settmentMoney - 30];
        }
            break;
    }
}

- (void)getOrderID{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_GETORDERID];

    NSDictionary * pragrams = @{@"mobile":[UserSession instance].account,@"ticketNo":self.ticketNo};
    HttpManager * manage = [[HttpManager alloc]init];

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
