//
//  YWShopPlanViewController.m
//  YuWa
//
//  Created by double on 17/6/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopPlanViewController.h"

@interface YWShopPlanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@property (weak, nonatomic) IBOutlet UIButton *autionBtn;//竞拍按钮
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
//更多按钮
@property (weak, nonatomic) IBOutlet UILabel *cautionMoneyLabel;//保证金
@property (weak, nonatomic) IBOutlet UIButton *payBtn;//缴纳


@end

@implementation YWShopPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeUI];
}

- (void)makeUI{
    self.title = @"商业计划书";
    self.cautionMoneyLabel.layer.borderColor = CNaviColor.CGColor;
    self.cautionMoneyLabel.layer.borderWidth = 0.3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shopPlanCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopPlanCell"];
    }
    return cell;
}
//缴纳
- (IBAction)toPayMoneyAction:(UIButton *)sender {
}
//更多
- (IBAction)moreAction:(UIButton *)sender {
}
//竞拍
- (IBAction)autionAction:(UIButton *)sender {
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
