//
//  ProgressView.m
//  YuWa
//
//  Created by double on 17/3/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()
@property (nonatomic,strong)UILabel * dataLabel;
@property (nonatomic,strong)UILabel * dataNameLabel;
@end

@implementation ProgressView
-(UILabel *)dataLabel{
    if (!_dataLabel) {
        CGFloat radius                          = MIN(self.bounds.size.width, self.bounds.size.height) - 20;
        _dataLabel                              = [[UILabel alloc]init];
        _dataLabel.bounds                       = CGRectMake(0, 0, radius - 10 ,self.bounds.size.width /4);
        _dataLabel.center                       = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 10);
        _dataLabel.textColor                    = self.progressColor;
        _dataLabel.text                         = self.data;
        _dataLabel.adjustsFontSizeToFitWidth    = YES;
        _dataLabel.textAlignment                = NSTextAlignmentCenter;
    }
    return _dataLabel;
}

-(UILabel *)dataNameLabel{
    if (!_dataNameLabel) {
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) - 20;
        _dataNameLabel                              = [[UILabel alloc]init];
        _dataNameLabel.bounds                       = CGRectMake(0, 0, radius - 10 ,self.bounds.size.width /4);
        _dataNameLabel.center                       = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + self.bounds.size.height/8);
        _dataNameLabel.textColor                    = self.progressColor;
        _dataNameLabel.text                         = self.dataName;
        _dataNameLabel.adjustsFontSizeToFitWidth    = YES;
        _dataNameLabel.textAlignment                = NSTextAlignmentCenter;
    }
    return _dataNameLabel;
}
-(instancetype)initWithFrame:(CGRect)frame andWithBusinessGrade:(NSString *)busnessGrade andWithProportion:(CGFloat)proportion{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor cyanColor];
        if ([busnessGrade isEqualToString:@"普通会员"]) {
//            self.proportion = proportion/1000;
            
        }else if ([busnessGrade isEqualToString:@"白银会员"]){
            
        }else if ([busnessGrade isEqualToString:@"黄金会员"]){
            
        }else if ([busnessGrade isEqualToString:@"白金会员"]){
            
        }else if ([busnessGrade isEqualToString:@"砖石会员"]){
            
        }else if ([busnessGrade isEqualToString:@"荣誉懂事"]){
            
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor color:(UIColor *)color proportion:(CGFloat)proportion{
    self = [super initWithFrame:frame];
    if (self) {
        
    if (!color) {
        self.progressColor  = [UIColor whiteColor];
    }else{
        self.progressColor  = color;
    }
    self.progressBackColor  = backColor;
    
    if (proportion <= 0) {
        proportion = 0;
    }
    else if (proportion > 0 && proportion < 1) {
        proportion = proportion;
    }
    else{
        proportion = 1;
    }
    self.proportion = proportion;
    [self showProgress];
    }
    return self;
}


-(void)showProgress{
    
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2 - MIN(self.bounds.size.width, self.bounds.size.height)/10;
    UIBezierPath * path     = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:radius startAngle: - M_PI endAngle:M_PI clockwise:YES];
    
    CAShapeLayer * backLayer    = [CAShapeLayer layer];
    backLayer.fillColor         = [[UIColor clearColor] CGColor];
    backLayer.strokeColor       = self.progressBackColor.CGColor;
    backLayer.lineWidth         = radius / 10;
    backLayer.strokeEnd         = 1;
    backLayer.path              = path.CGPath;
    [self.layer addSublayer:backLayer];
    
    CAShapeLayer * progressLayer    = [CAShapeLayer layer];
    progressLayer.fillColor         = [UIColor clearColor].CGColor;
    progressLayer.strokeColor       = self.progressColor.CGColor;
    progressLayer.lineWidth         = radius / 10;
    progressLayer.path              = path.CGPath;
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation * animation    = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue             = @(0);
    animation.toValue               = @(self.proportion);
    animation.duration              = 1;
    animation.fillMode              = kCAFillModeForwards;
    animation.removedOnCompletion   = NO;
    [progressLayer addAnimation:animation forKey:nil];
}

-(void)showContentData{
    [self addSubview:self.dataLabel];
    [self addSubview:self.dataNameLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
