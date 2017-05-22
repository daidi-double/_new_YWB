//
//  TableBGView.h
//  YuWa
//
//  Created by double on 17/2/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableBGView : UIView
@property (nonatomic,assign) NSInteger staus;
@property (nonatomic,copy) void (^titleBlock)(NSString * title,NSString * cityCode);

- (instancetype)initWithFrame:(CGRect)frame andTag:(NSInteger)tag;

@end

