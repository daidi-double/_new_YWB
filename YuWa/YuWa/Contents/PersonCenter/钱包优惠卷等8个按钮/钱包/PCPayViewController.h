//
//  PCPayViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YWPayMViewController.h"
#import "WXApi.h"
@interface PCPayViewController : UIViewController<WXApiDelegate>

@property(nonatomic,assign)CGFloat blanceMoney;  //需要付多少钱
@property(nonatomic,assign)CGFloat order_id;  //订单号
@property(nonatomic,copy)NSString * shop_ID;//店铺id
//微信支付
+(instancetype)sharedManager;
-(void)TowechatPay:(NSDictionary*)dict;
//单利
@end
