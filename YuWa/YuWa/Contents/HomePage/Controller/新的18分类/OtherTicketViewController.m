//
//  OtherTicketViewController.m
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketViewController.h"
#import "OtherTicketTableViewCell.h"
#import "OtherTicketModel.h"
#define otherTicketCell  @"OtherTicketTableViewCell"
@interface OtherTicketViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *otherTableView;
@property (nonatomic,strong)NSMutableArray * otherTicketAry;//通兑票数组


@end

@implementation OtherTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
}
-(void)makeUI{
    [self judgeIsContentOtherTicket];
    [self.otherTableView registerNib:[UINib nibWithNibName:otherTicketCell bundle:nil] forCellReuseIdentifier:otherTicketCell];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.otherTicketAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherTicketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:otherTicketCell];
    OtherTicketModel * model = self.otherTicketAry[indexPath.section];
    cell.model = model;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
//获取通兑票
- (void)judgeIsContentOtherTicket{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_JUDGECONTENTOTHERTICKET];
    
    self.cityCode = @"110100";
    self.cinema_code = @"01010071";
    NSDictionary * pragrams = @{@"cityNo":self.cityCode,@"cinemaNo":self.cinema_code};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"是否有通兑票 %@",data);
        [self.otherTicketAry removeAllObjects];
        if ([data[@"errorCode"] integerValue] == 0) {
            for (NSDictionary * dict in data[@"data"]) {
                OtherTicketModel * model = [OtherTicketModel yy_modelWithDictionary:dict];
                [self.otherTicketAry addObject:model];
                
            }
            [self.otherTableView reloadData];
        }
        }];
    
}
- (NSMutableArray*)otherTicketAry{
    if (!_otherTicketAry) {
        _otherTicketAry = [NSMutableArray array];
    }
    return _otherTicketAry;
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
