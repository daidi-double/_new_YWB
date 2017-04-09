//
//  TimeDownLabel.h
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  TimeDownLabelDelegate<NSObject>

- (void)popToPage;

@end
@interface TimeDownLabel : UILabel

@property (nonatomic,assign)NSInteger second;
@property (nonatomic,assign)NSInteger minute;
@property (nonatomic,assign)id<TimeDownLabelDelegate>delegate;

@end
