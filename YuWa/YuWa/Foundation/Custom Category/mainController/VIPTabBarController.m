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
@interface VIPTabBarController()
{
    VIPTabBar * tabBar;
}
@property (nonatomic,strong)UIButton * cancelBtn;
@property (nonatomic,strong)UIButton * foodBtn;//美食按钮
@property (nonatomic,strong)UIButton * entertainmentBtn;//娱乐按钮
@end
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
    [self.view addSubview:self.BGView];
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
    
    YWSalesroomViewController*vcStorm=[[YWSalesroomViewController alloc]init];
    [self addChildVC:vcStorm withTitle:@"拍卖场" withImage:@"tabBar_publos_salesroom" withSelectedImage:@"tabBar_publos_salesroom"];
    
    YWMessageViewController*vcMessage=[[YWMessageViewController alloc]init];
    [self addChildVC:vcMessage withTitle:@"消息" withImage:@"home_3_nomal" withSelectedImage:@"home_3_selected"];
    
    VIPPersonCenterViewController*vcPerson=[[VIPPersonCenterViewController alloc]init];
    [self addChildVC:vcPerson withTitle:@"个人中心" withImage:@"home_4_nomal" withSelectedImage:@"home_4_selected"];
    tabBar = [[VIPTabBar alloc] init];
    [tabBar.button addTarget:self action:@selector(auction:) forControlEvents:UIControlEventTouchUpInside];
    //kvc  :通过key的形式来访问成员变量
    [self setValue:tabBar forKey:@"tabBar"];
}
- (void)auction:(YWCustomButton *)sender{
    MyLog(@"拍卖场");
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.BGView.hidden = NO;
 
    }else{
        self.BGView.hidden = YES;
    }
   
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

- (UIView*)BGView{
    if (!_BGView) {
        _BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.BGView.height)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.alpha = 0.8;
        _BGView.hidden = YES;
        [_BGView addSubview:toolbar];
        
        UITapGestureRecognizer * cancelTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBGView)];
        cancelTouch.numberOfTapsRequired = 1;
        cancelTouch.numberOfTouchesRequired = 1;
        cancelTouch.delegate = self;
        [_BGView addGestureRecognizer:cancelTouch];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, kScreen_Height-55, 35, 35);
        _cancelBtn.centerX = kScreen_Width/2;
        
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"quxiao"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBGView) forControlEvents:UIControlEventTouchUpInside];
        [_BGView addSubview:_cancelBtn];
        
        _foodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _foodBtn.frame = CGRectMake(_cancelBtn.left - 45, _cancelBtn.top - 65, 80, 45);
        [_foodBtn setTitle:@"美食" forState:UIControlStateNormal];
        [_foodBtn setImage:[UIImage imageNamed:@"food"] forState:UIControlStateNormal];
        _foodBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_foodBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_foodBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -25, -30, 25)];
        
//        [_foodBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        [_foodBtn addTarget:self action:@selector(toFoodPage) forControlEvents:UIControlEventTouchUpInside];
        [_BGView addSubview:_foodBtn];
        
    }
    return _BGView;
}
- (void)cancelBGView{
    self.BGView.hidden = YES;
    tabBar.button.selected = NO;
}
- (void)toFoodPage{
    
}
@end
