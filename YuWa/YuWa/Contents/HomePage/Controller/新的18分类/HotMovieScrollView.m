//
//  HotMovieScrollView.m
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "HotMovieScrollView.h"
#import "CarouselViewCell.h"
@interface HotMovieScrollView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation HotMovieScrollView

- (instancetype)initWithFrame:(CGRect)frame andDataAry:(NSMutableArray *)dataAry{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self setScrollectViewImage];

        self.dataArr = dataAry;
        
    }
    return self;
}

- (void)setScrollectViewImage{
//    for (int i = 0; i<self.dataArr.count; i++) {
    
    for (int i = 0; i<5; i++) {
        UIImageView * pictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width*i, 0, kScreen_Width, self.bounds.size.height)];
        pictureImage.tag = 100+i;
        /////////////////////////////
//        删
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"a%d",i+1000]];
        [self.dataArr addObject:image];
        ////////////////////////////
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToDetail:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.delegate = self;
        
        [pictureImage addGestureRecognizer:tapGes];
        pictureImage.userInteractionEnabled = YES;
        pictureImage.image = _dataArr[i];
        [self addSubview:pictureImage];
    }
}
- (void)touchToDetail:(UITapGestureRecognizer*)tap{
    NSLog(@"tap.view.tag=%ld",tap.view.tag);
    [self.HotDelegate pushToDetailPage:tap.view.tag];
}
- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
