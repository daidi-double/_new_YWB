//
//  YWSalesroomViewController.m
//  YuWa
//
//  Created by double on 17/6/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWSalesroomViewController.h"

@interface YWSalesroomViewController ()

@end

@implementation YWSalesroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"拍卖场";
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 100, 40)];
    [self.view addSubview:btn];
    [btn setTitle:@"美食" forState:0];
    [btn addTarget:self action:@selector(BFood:) forControlEvents:UIControlEventTouchDown];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"selectedIndex" object:nil];
}
//美食按钮
- (IBAction)BFood:(id)sender {
    YWSalesroomViewController*vc=[[YWSalesroomViewController alloc]init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
