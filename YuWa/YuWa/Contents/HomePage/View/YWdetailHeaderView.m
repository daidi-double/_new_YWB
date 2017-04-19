//
//  YWdetailHeaderView.m
//  YuWa
//
//  Created by L灰灰Y on 2017/4/19.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWdetailHeaderView.h"

@interface YWdetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, assign) CGRect  myFrame;
@end
@implementation YWdetailHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nibs=[[NSBundle mainBundle]loadNibNamed:@"detailHeaderView" owner:nil options:nil];
        self=[nibs objectAtIndex:0];
        
        self.myFrame = frame;
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.frame = self.myFrame;
}
-(void)setImageView1:(UIImageView *)imageView1  {
    _imageView1 = imageView1;
    self.imageVIew = imageView1;
    self.bgImageView = imageView1;
}
@end
