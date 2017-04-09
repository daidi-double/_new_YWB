//
//  GetMyMoneyViewController.m
//  YuWa
//
//  Created by double on 17/3/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "GetMyMoneyViewController.h"
#import "YWBankViewController.h"
#import "GetMoneyToBankViewController.h"
@interface GetMyMoneyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputMoneyTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBankCardBtn;
@property (nonatomic,copy)NSString * bankName;
@property (nonatomic,copy)NSString * bankCard;
@property (nonatomic,copy)NSString * bankCardID;
@end

@implementation GetMyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    self.title = @"零钱提现";
    UIView * BGView = [self.view viewWithTag:2];
    BGView.layer.masksToBounds = YES;
    BGView.layer.cornerRadius = 6;
    UILabel * moneyLabel = [self.view viewWithTag:4];
    
    moneyLabel.text = [NSString stringWithFormat:@"零钱金额￥%@,",self.money];
    if ([UserSession instance].bankName == nil || [[UserSession instance].bankCard isEqualToString:@""]) {
        
        [self.chooseBankCardBtn setTitle:@"请选择银行卡" forState:UIControlStateNormal];
    }else{
        NSString * bankStr;
        if ([UserSession instance].bankCard.length <15) {
            bankStr = @"";
        }
        bankStr = [[UserSession instance].bankCard substringFromIndex:15];
        [self.chooseBankCardBtn setTitle:[NSString stringWithFormat:@"%@(%@)",[UserSession instance].bankName ,bankStr] forState:UIControlStateNormal];
    }
    
}
- (IBAction)chooseBank:(UIButton *)sender {
    //选择银行卡
    
    YWBankViewController * bankVC = [[YWBankViewController alloc]init];
    WEAKSELF;
    bankVC.status = 1;
    bankVC.getBankCardBlock = ^(NSString * bankName,NSString * bankCard,NSString * bankCardID){
        weakSelf.bankName = bankName;
        weakSelf.bankCard = bankCard;
        weakSelf.bankCardID = bankCardID;
        NSString * card;
        if (bankCard.length < 15) {
           card = @"";
        }else{
           card = [bankCard substringFromIndex:15];
        }
        [weakSelf.chooseBankCardBtn setTitle:[NSString stringWithFormat:@"%@(%@)",bankName,card] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:bankVC animated:YES];
    
}
- (IBAction)getAllMoney:(UIButton *)sender {
    self.inputMoneyTF.text = [NSString stringWithFormat:@"%@",self.money];
    
}
- (IBAction)nextAction:(UIButton *)sender {
    if (self.bankCardID == nil ||self.bankName == nil) {
        [JRToast showWithText:@"请选择银行卡"];
        return;
    }
    GetMoneyToBankViewController * getVC = [[GetMoneyToBankViewController alloc]init];
    getVC.user_card_id = self.bankCardID;
    getVC.money = self.inputMoneyTF.text;
    [self.navigationController pushViewController:getVC animated:YES];
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
