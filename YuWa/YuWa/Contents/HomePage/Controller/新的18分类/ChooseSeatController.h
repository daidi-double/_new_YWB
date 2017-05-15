//
//  ChooseSeatController.h
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSeatController : UIViewController
@property(nonatomic,strong)UILabel* titleLbl;
@property (nonatomic,strong)UILabel * playTime;
@property (nonatomic,strong)UIButton * sureBtn;
@property (nonatomic,strong) UILabel * allPrice;//总价;
@property (nonatomic,strong) UILabel * price_num;//价格和张数
@property (nonatomic,strong) UILabel * languageLabel;
@property (nonatomic,strong) UIButton * changeMovieBtn;//更换场次
@property (nonatomic,copy) NSString * channelShowCode;//渠道场次编码

@end
