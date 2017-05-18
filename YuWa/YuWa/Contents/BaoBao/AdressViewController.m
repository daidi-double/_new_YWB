//
//  AdressViewController.m
//  YuWa
//
//  Created by double on 17/3/1.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AdressViewController.h"

@interface AdressViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *adressScrollView;

@end

@implementation AdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * image = [UIImage imageNamed:@"adress.png"];
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    scrollView.contentSize=CGSizeMake(kScreen_Width, kScreen_Width * image.size.height/image.size.width);

    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * image.size.height/image.size.width)];
    imageView.image = image;

    [scrollView addSubview:imageView];
    self.adressScrollView=scrollView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
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
