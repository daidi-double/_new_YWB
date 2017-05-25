//
//  CinemaAndBuyTicketModel.h
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaAndBuyTicketModel : NSObject
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * score;
@property (nonatomic,copy)NSString * code;//影片编码
@property (nonatomic,copy)NSString * image;//影片图片
@property (nonatomic,copy)NSString * poster;//影片图片（详情界面）
@property (nonatomic,copy)NSString * director;//导演
@property (nonatomic,copy)NSString * cast;//主演
@property (nonatomic,copy)NSString * type;//类型
@property (nonatomic,copy)NSString * country;//地区和国家
@property (nonatomic,copy)NSString * cinema_name;//影院名
@property (nonatomic,copy)NSString * settle_price;//几元起
@property (nonatomic,copy)NSString * distance;//距离
@property (nonatomic,copy)NSString * intro;//简介
@property (nonatomic,copy)NSString * highlight;

//影片详情的图片字段
@property (nonatomic,copy)NSString * stills;

@end
