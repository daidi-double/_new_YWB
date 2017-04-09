//
//  ExchangeViewController.m
//  YuWa
//
//  Created by double on 17/3/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *exchangeGradeTextField;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分兑换";
    [self setUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)setUI{
    UIButton * sureExchangeBtn = [self.view viewWithTag:8];
    sureExchangeBtn.layer.masksToBounds = YES;
    sureExchangeBtn.layer.cornerRadius = 5;
    
    UILabel * canUseGrade = [self.view viewWithTag:6];
    canUseGrade.text = self.canUseGrade;
}
//兑换全部
- (IBAction)exchangeAllGrade:(UIButton *)sender {
    self.exchangeGradeTextField.text = self.canUseGrade;
}
//确认兑换
- (IBAction)suerExchangeBtnAction:(UIButton *)sender {
    
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
