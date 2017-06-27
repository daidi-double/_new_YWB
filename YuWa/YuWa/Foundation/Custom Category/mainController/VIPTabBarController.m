//
//  VIPTabBarController.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/9/1.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "VIPTabBarController.h"
#import "VIPTabBar.h"
#import "JWTabBar.h"
#import "VIPNavigationController.h"

#import "VIPHomePageViewController.h"
#import "RBHomeViewController.h"
#import "YWSalesroomViewController.h"
#import "YWMessageViewController.h"
#import "VIPPersonCenterViewController.h"


#import "YWLoginViewController.h"

@implementation VIPTabBarController
//-(void)viewDidLoad{
//    [super viewDidLoad];
//    [self createTabBar];
//}
//-(void)createTabBar{
//    NSArray * vcArray = @[@"VIPHomePageViewController",@"RBHomeViewController",@"YWMessageViewController",@"VIPPersonCenterViewController"];
//    NSArray * title = @[@"首页",@"消息",@"发现",@"我的"];
//    NSArray * imageNameArray = @[@"tabbar_home", @"tabbar_message_center",@"tabbar_discover", @"tabbar_profile"];
//    for (int i = 0; i < vcArray.count; i++) {
//        UINavigationController * nav  =[self navWithRootViewController:NSClassFromString(vcArray[i]) WithTitle:title[i]];
//        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title[i] image:[[UIImage imageNamed:imageNameArray[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageNameArray[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [self addChildViewController:nav];
//    }
//    //修改颜色
//    [UITabBar appearance].tintColor = [UIColor orangeColor];
//    VIPTabBar * tabBar = [[VIPTabBar alloc] init];
//    [tabBar.button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//    //kvc  :通过key的形式来访问成员变量
//    [self setValue:tabBar forKey:@"tabBar"];
//    
//}
//-(void)buttonAction{
//    
//}
//-(UINavigationController *)navWithRootViewController:(Class)root WithTitle:(NSString *)title{
//    UIViewController * vc = [[root alloc] init];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    vc.title = title;
//    return nav;
//}

-(void)viewDidLoad{
    [super viewDidLoad];
    // tabBar 必定是灰色的  下面方法 可以改变选中时候的颜色
    [UITabBar appearance].tintColor=CNaviColor;
    [self addChildViewControllers];
    [self delTopLine];
    self.delegate=self;
//    self .selectedIndex =3;
//    self .selectedIndex =0;
}

- (void)delTopLine{
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
}

-(void)addChildViewControllers{
   
    VIPHomePageViewController*vc=[[VIPHomePageViewController alloc]init];
    [self addChildVC:vc withTitle:@"首页" withImage:@"home_0_nomal" withSelectedImage:@"home_0_selected"];
    
    RBHomeViewController*vcDiscover=[[RBHomeViewController alloc]init];
    [self addChildVC:vcDiscover withTitle:@"发现" withImage:@"home_1_nomal" withSelectedImage:@"home_1_selected"];
    
//    YWSalesroomViewController*vcStorm=[[YWSalesroomViewController alloc]init];
//    [self addChildVC:vcStorm withTitle:@"拍卖场" withImage:@"tabBar_publos_salesroom" withSelectedImage:@"tabBar_publos_salesroom"];
    
    YWMessageViewController*vcMessage=[[YWMessageViewController alloc]init];
    [self addChildVC:vcMessage withTitle:@"消息" withImage:@"home_3_nomal" withSelectedImage:@"home_3_selected"];
    
    VIPPersonCenterViewController*vcPerson=[[VIPPersonCenterViewController alloc]init];
    [self addChildVC:vcPerson withTitle:@"个人中心" withImage:@"home_4_nomal" withSelectedImage:@"home_4_selected"];
    VIPTabBar * tabBar = [[VIPTabBar alloc] init];
    [tabBar.button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //kvc  :通过key的形式来访问成员变量
    [self setValue:tabBar forKey:@"tabBar"];
}
- (void)buttonAction{
    MyLog(@"拍卖场");
}

-(void)addChildVC:(UIViewController*)vc withTitle:(NSString*)title withImage:(NSString*)imageName withSelectedImage:(NSString*)selectedImageName{
    vc.tabBarItem.title=title;
    vc.title=title;
    vc.tabBarItem.image=[UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage=[UIImage imageNamed:selectedImageName];
    if ([vc isKindOfClass:[YWSalesroomViewController class]]) {
        vc.tabBarItem.image = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vc.tabBarItem setImageInsets:UIEdgeInsetsMake(-8, 0, 8, 0)];//top = - bottom
    }
    
    VIPNavigationController*navi=[[VIPNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:navi];
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController.tabBarItem.title isEqualToString:@"个人中心"]) {
        if (![UserSession instance].isLogin) {
            YWLoginViewController * vc = [[YWLoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            UINavigationController*navi=[[UINavigationController alloc]initWithRootViewController:vc];
//            LoginController *vc = [LoginController new];
            [self presentViewController:navi animated:YES completion:nil];
            
            return NO;
        }else{
            return YES;
        }
        
    }
    
    return YES;
}




@end
