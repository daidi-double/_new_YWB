//
//  YWdetailViewController.m
//  YuWa
//
//  Created by L灰灰Y on 2017/4/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWdetailViewController.h"
#import "JWTools.h"

@interface YWdetailViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *shopName1;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollw;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *customer_phone;
@property (weak, nonatomic) IBOutlet UILabel *num;

@property (weak, nonatomic) IBOutlet UILabel *suggestions;

@end

@implementation YWdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"订单详情";
    self.shopName1.text = self.model.shop_name;
    self.time.text = [JWTools dateWithOutYearStr:self.model.ctime];;
    self.message.text = self.model.seller_message;
    if ([self.model.customer_sex isEqualToString:@"1"]) {
        //表明是男士
        self.Name.text = [NSString stringWithFormat:@"%@先生",self.model.customer_name];
    }else{
        self.Name.text = [NSString stringWithFormat:@"%@女士",self.model.customer_name];
    }
    self.customer_phone.text =  self.model.customer_phone;
    self.num.text = [NSString stringWithFormat:@"%@人",self.model.customer_num];
    
    [self.suggestions setUserInteractionEnabled:YES];
    UITapGestureRecognizer * touchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callIphone)];
    touchTap.delegate = self;
    touchTap.numberOfTapsRequired = 1;
    touchTap.numberOfTouchesRequired = 1;
    [self.suggestions addGestureRecognizer:touchTap];
}
- (void)callIphone{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * call = [UIAlertAction actionWithTitle:@"客服电话:4001505599" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIWebView* callWebview =[[UIWebView alloc] init];
        NSURL * telURL =[NSURL URLWithString:@"tel:4001505599"];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }];
    [alertVC addAction:call];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

@end
