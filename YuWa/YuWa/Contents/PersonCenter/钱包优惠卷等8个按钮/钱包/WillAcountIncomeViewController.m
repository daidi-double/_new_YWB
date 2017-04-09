//
//  WillAcountIncomeViewController.m
//  YuWa
//
//  Created by double on 17/3/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "WillAcountIncomeViewController.h"
#import "PCDetailMoneyViewController.h"
#import "WillAccountIncomeTableViewCell.h"
#import "AccountIncomeModel.h"
#define ACCOUNTCELL @"WillAccountIncomeTableViewCell"
@interface WillAcountIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *acountIncomeTableView;
@property (weak, nonatomic) IBOutlet UILabel *willAcountIncomeLabel;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)int pages;
@property(nonatomic,assign)int pagen;
@end

@implementation WillAcountIncomeViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"待结算收益";
    [self makeUI];
    [self setUpMJRefresh];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self requestMyAcountIncome];
//    
//}

-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=-1;
    
    self.acountIncomeTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self requestMyAcountIncome];
    }];
    
    //上拉刷新
    self.acountIncomeTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        [self getMoreDatas];
    }];
    
    
    //立即刷新
    [self.acountIncomeTableView.mj_header beginRefreshing];
    
}
- (void)makeUI{
//    self.willAcountIncomeLabel = @"";
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"收支明细" style:UIBarButtonItemStylePlain target:self action:@selector(payList)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self.acountIncomeTableView registerNib:[UINib nibWithNibName:ACCOUNTCELL bundle:nil] forCellReuseIdentifier:ACCOUNTCELL];
    
}

-(void)payList{
    PCDetailMoneyViewController *vc = [[PCDetailMoneyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WillAccountIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ACCOUNTCELL];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AccountIncomeModel * model;
    if (self.dataArray.count > 0) {
        
        model = self.dataArray[indexPath.row];
        cell.acountTimeLabel.text = [JWTools getTime:model.ctime];
    }
    cell.fenhongImageView.image = [UIImage imageNamed:model.type];
    if ([model.type isEqualToString:@"直接介绍分红"]||[model.type isEqualToString:@"间接介绍分红"]) {
        cell.fenhongImageView.image = [UIImage imageNamed:@"介绍分红"];
    }
    if ([model.type isEqualToString:@"直接介绍积分分红"] ||[model.type isEqualToString:@"间接介绍积分分红"]) {
        cell.fenhongImageView.image = [UIImage imageNamed:@"积分分红"];
    }
    cell.fenhongNameLabel.text = model.type;
    cell.getMoneyLabel.text = model.money;
    return cell;
}

- (void)requestMyAcountIncome{
    self.pagen=10;
    self.pages=-1;
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_WILLACOUNTINCOME];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        [self.dataArray removeAllObjects];
        NSInteger errorCode = [data[@"errorCode"] integerValue];
        if (errorCode == 0) {
            if ([data[@"total_settlement"]isKindOfClass:[NSNull class]]) {
                self.willAcountIncomeLabel.text = @"0.00";
            }else{
                self.willAcountIncomeLabel.text = data[@"total_settlement"];
            }
        for (NSDictionary * dict in data[@"data"]) {
            
            AccountIncomeModel * model = [AccountIncomeModel yy_modelWithDictionary:dict];
            [self.dataArray addObject:model];
        }
            [self.acountIncomeTableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
        
        [self.acountIncomeTableView.mj_header endRefreshing];
        [self.acountIncomeTableView.mj_footer endRefreshing];
    }];
}

- (void)requestMoreMyAcountIncome{
    
    self.pages++;
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_WILLACOUNTINCOME];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":@(self.pagen),@"pages":@(self.pages)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSInteger errorCode = [data[@"errorCode"] integerValue];
        if (errorCode == 0) {
            self.willAcountIncomeLabel.text = data[@"total_settlement"];
            for (NSDictionary * dict in data[@"data"]) {
                
                AccountIncomeModel * model = [AccountIncomeModel yy_modelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.acountIncomeTableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
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
