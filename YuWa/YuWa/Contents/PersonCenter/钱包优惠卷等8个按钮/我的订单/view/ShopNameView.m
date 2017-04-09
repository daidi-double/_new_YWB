//
//  ShopNameView.m
//  YuWa
//
//  Created by double on 17/3/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShopNameView.h"

@implementation ShopNameView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.shopNameLabel];
    }
    return self;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, self.height * 0.8f, self.height * 0.8f)];
        _imageView.centerY = self.height/2;
        _imageView.image = [UIImage imageNamed:@"placeholder"];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
    }
    return _imageView;
}

- (UILabel*)shopNameLabel{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 + self.height * 0.8f, 5, kScreen_Width * 0.85, self.height * 0.8)];
        _shopNameLabel.centerY = self.height/2;
        _shopNameLabel.textColor = [UIColor blackColor];
        _shopNameLabel.font = [UIFont systemFontOfSize:17];
        
    }
    return _shopNameLabel;
}
@end
