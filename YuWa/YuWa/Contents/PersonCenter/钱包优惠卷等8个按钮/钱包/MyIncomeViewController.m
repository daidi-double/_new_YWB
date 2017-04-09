//
//  MyIncomeViewController.m
//  YuWa
//
//  Created by double on 17/3/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "PCDetailMoneyViewController.h"
#import "MyIncomeTableViewCell.h"
#import "MyIncomeModel.h"

#define IncomeCell @"MyIncomeTableViewCell"
@interface MyIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *myIncome;
@property (weak, nonatomic) IBOutlet UITableView *incomeTableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)int pages;
@property(nonatomic,assign)int pagen;

@end

@implementation MyIncomeViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self setUpMJRefresh];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self getDatas];
//}

-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=-1;
    
    self.incomeTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self getDatas];
    }];
    
    //上拉刷新
    self.incomeTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self getMoreDatas];
    }];
    
    
    //立即刷新
    [self.incomeTableView.mj_header beginRefreshing];
  
}

- (void)makeUI{
    self.title = @"我的收益";
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"收支明细" style:UIBarButtonItemStylePlain target:self action:@selector(payList)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self.incomeTableView registerNib:[UINib nibWithNibName:IncomeCell bundle:nil] forCellReuseIdentifier:IncomeCell];
    
    _myIncome = [self.view viewWithTag:1];
    
}
-(void)payList{
    PCDetailMoneyViewController *vc = [[PCDetailMoneyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IncomeCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count >0) {
        
        MyIncomeModel * model = self.dataArray[indexPath.row];
        cell.dateLabel.text = model.week;
        cell.timeLabel.text = model.time;
        cell.dateTimeLabel.text = model.dateTime;
        cell.fenhongNameLabel.text = model.type;
        cell.fenhongImageView.image = [UIImage imageNamed:model.type];
        
        cell.payMoney.text = model.money;
    }
    return cell;
}

#pragma mark  --getDatas
-(void)getDatas{
    self.pagen=10;
    self.pages=-1;
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYINCOME];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                
                MyIncomeModel * model = [MyIncomeModel yy_modelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            if ([data[@"total_money"] isKindOfClass:[NSNull class]]) {
               _myIncome.text = @"0.00";
            }else{
            _myIncome.text = data[@"total_money"];//我的收益
              }
            [self.incomeTableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.incomeTableView.mj_header endRefreshing];
        [self.incomeTableView.mj_footer endRefreshing];
        
    }];
    
    
    
    
    
}

-(void)getMoreDatas{
      self.pages++;
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYINCOME];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":@(self.pagen),@"pages":@(self.pages)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
           
            for (NSDictionary * dict in data[@"data"]) {
                
                MyIncomeModel * model = [MyIncomeModel yy_modelWithDictionary:dict];
                [self.dataArray addObject:model];
            }

            [self.incomeTableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }

            [self.incomeTableView.mj_header endRefreshing];
            [self.incomeTableView.mj_footer endRefreshing];

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
