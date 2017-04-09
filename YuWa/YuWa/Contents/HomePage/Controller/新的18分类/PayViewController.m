//
//  PayViewController.m
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PayViewController.h"
#import "TimeDownLabel.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource,TimeDownLabelDelegate>
@property (nonatomic,strong) NSMutableArray * dataAry;
@property (nonatomic,strong) UITableView * payInforTableView;
@end

@implementation PayViewController
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
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
    [self timeDown];
    [self showMessage:@"选座票购买后无法退换，请仔细核对购票信息"];
    
}
- (void)popToPage{
    [self quitPayPage];
}
#pragma mark - 倒计时
- (void)timeDown{
    TimeDownLabel *lable = [[TimeDownLabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    lable.minute = 14;
    lable.second = 59;
    self.navigationItem.titleView = lable;
    lable.delegate = self;
    
}
- (void)quitPayPage{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您选择场次信息已过期或者支付超时，请重新选座购买" preferredStyle:UIAlertControllerStyleAlert];

      [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          [self.navigationController popViewControllerAnimated:YES];
      }]];
    [self presentViewController:controller animated:YES completion:nil];

}

-(void)showMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];

}
- (void)makeUI{
    _payInforTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
    _payInforTableView.delegate = self;
    _payInforTableView.dataSource = self;
    
    [self.view addSubview:_payInforTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 3;
//    }else if (section == 1){
//        return 5;
//    }else if (<#expression#>)
    return 5;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"payCell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.frame = CGRectMake(cell.textLabel.x, 5, cell.textLabel.width, cell.textLabel.height);
        }else if (indexPath.row == 1){
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
        }else{
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
        }
    }else if (indexPath.section == 1){
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        UILabel * textLbl = [[UILabel alloc]initWithFrame:CGRectMake(cell.width * 0.75f, 0, cell.width * 0.2f, cell.height * 0.9f)];
        textLbl.center = CGPointMake(cell.width * 0.85f, cell.height/2);
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:textLbl];
        
    }
    return cell;
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
