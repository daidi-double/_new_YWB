//
//  TimeDownLabel.m
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "TimeDownLabel.h"
@interface TimeDownLabel()
@property (nonatomic, strong)NSTimer *timer;
@end
@implementation TimeDownLabel
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;

    }
    
    self.text = [NSString stringWithFormat:@"电影订单 %ld:%ld",(long)self.minute,(long)self.second];
    if (self.second==0 && self.minute==0 ) {
        [self.delegate popToPage];
        [self.timer invalidate];
        self.timer = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
