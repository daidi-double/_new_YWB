//
//  headerView.h
//  YuWa
//
//  Created by L灰灰Y on 2017/4/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headerView : UIView
//总支出
@property (assign, nonatomic)  float all;
@property (weak, nonatomic) IBOutlet UILabel *month;
@end
