//
//  HotMovieModel.h
//  YuWa
//
//  Created by double on 17/5/12.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotMovieModel : NSObject
@property (nonatomic,copy)NSString * image;
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * code;
@property (nonatomic,copy)NSString * score;//评分
@property (nonatomic,copy)NSString * name;//电影名称
@property (nonatomic,copy)NSString * publish_date;//上映日期
@property (nonatomic,copy)NSString * highlight;//简介
@end
