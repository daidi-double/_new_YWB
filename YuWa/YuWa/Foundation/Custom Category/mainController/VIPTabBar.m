//
//  VIPTabBar.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/9/1.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "VIPTabBar.h"

@implementation VIPTabBar
-(YWCustomButton *)button{
    if (!_button) {
        _button = [[YWCustomButton alloc]initWithFrame:CGRectMake(0, 0, 36, 80) andTitle:@"拍卖场"];
        
        [_button setImage:[UIImage imageNamed:@"tabBar_publos_salesroom"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"tabBar_publos_salesroom"] forState:UIControlStateHighlighted];

    }
    return _button;
}
//-(UIButton *)button{
//    if (!_button) {
//        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [_button setImage:[UIImage imageNamed:@"tabBar_publos_salesroom"] forState:UIControlStateNormal];
//        [_button setImage:[UIImage imageNamed:@"tabBar_publos_salesroom"] forState:UIControlStateHighlighted];
//        [_button setTitle:@"拍卖场" forState:UIControlStateNormal];
//        [_button setTitle:@"拍卖场" forState:UIControlStateHighlighted];
//        [_button setTitleColor:[UIColor colorWithHexString:@"9f9f9f"] forState:UIControlStateNormal];
//        [_button setTitleColor:CNaviColor forState:UIControlStateHighlighted];
//        [_button setTitleEdgeInsets:UIEdgeInsetsMake(30, -15, -30, 15)];
//        [_button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
//        _button.size = CGSizeMake(45, 80);
//        
//    }
//    return _button;
//}
//初始化方法中添加一个按钮---拍卖场
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.button];

    }
    return self;
}




- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat endgeWidth = ACTUAL_WIDTH(18.f);
    CGFloat tabBarWidth = (self.width - endgeWidth*2)/5;

    CGFloat tabBarY = self.height/2;
    _button.width = tabBarWidth;
    _button.centerY = tabBarY/3.0;
    _button.centerX = self.width/2.0;
    NSInteger index = 0;
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            //这个 宽要先设置。  不然先设置了中心点 再改宽度  会出bug
            [subView setWidth:tabBarWidth];
            if (index<2) {
                
                subView.center = CGPointMake(endgeWidth + tabBarWidth/2 + index * tabBarWidth, tabBarY);
            }else{
               subView.center = CGPointMake(endgeWidth + tabBarWidth/2 + (index+1) * tabBarWidth, tabBarY);
            }
            index++;

        }
    }
    
    
}




@end
