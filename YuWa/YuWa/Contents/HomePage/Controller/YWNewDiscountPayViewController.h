//
//  YWNewDiscountPayViewController.h
//  YuWa
//
//  Created by double on 17/4/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWCarListModel.h"
#import "YWShopInfoListModel.h"
@interface YWNewDiscountPayViewController : UIViewController
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,strong)YWCarListModel * model;
@property (nonatomic,strong)YWShopInfoListModel * infoModel;
@property (nonatomic,copy)NSString * money;
@property (nonatomic,assign)NSInteger status;//直接从店铺跳转
@property (nonatomic,strong)NSString * shopName;
@property (nonatomic,strong)NSString * shopDiscount;
@property (nonatomic,copy)NSString * shopID;
@end
