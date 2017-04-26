//
//  YWdetailViewController.m
//  YuWa
//
//  Created by L灰灰Y on 2017/4/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWdetailViewController.h"

@interface YWdetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollw;

@end

@implementation YWdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"订单详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
