//
//  YWShopCarViewController.m
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopCarViewController.h"
#import "ShopCarDetailTableViewCell.h"


#define CARDETAILCELL  @"ShopCarDetailTableViewCell"
@interface YWShopCarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *shopCarTableView;

@end

@implementation YWShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.shopCarTableView registerNib:[UINib nibWithNibName:CARDETAILCELL bundle:nil] forCellReuseIdentifier:CARDETAILCELL];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCarDetailTableViewCell * cell = [[ShopCarDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CARDETAILCELL];
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
