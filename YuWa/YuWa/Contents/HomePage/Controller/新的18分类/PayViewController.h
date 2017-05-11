//
//  PayViewController.h
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController
@property (nonatomic,strong) NSString * shop_id;
@property (nonatomic,assign) CGFloat order_id;
- (instancetype)initWithDataArray:(NSMutableArray*)ary;
@end
