//
//  FilmShowTimeModel.h
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmShowTimeModel : NSObject
@property (nonatomic,strong)NSString * showTime;
@property (nonatomic,strong)NSString * endTime;
@property (nonatomic,strong)NSString * language;
@property (nonatomic,strong)NSString * hallname;
@property (nonatomic,strong)NSString * showtype;//价格放映类型（1：2D 2：3D 3：MAX2D 4：MAX3D 6：DMAX）
@property (nonatomic,strong)NSString * settlePrice;//起售价
@property (nonatomic,strong)NSString * channelShowCode;//渠道场次编码
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * score;

@end
