//
//  NewHotMovieCollectCell.m
//  YuWa
//
//  Created by double on 17/5/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "NewHotMovieCollectCell.h"

@implementation NewHotMovieCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setModel:(MovieHeaderModel *)model{
    _model = model;
    [self setdata];
}
-(void)setdata{
    //星星数量 -------------------------------------------------------
    CGFloat realZhengshu;
    CGFloat realXiaoshu;
//    NSString*starNmuber=self.model.grade;
    NSString * starNmuber = @"4.2";
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>0.5) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>0&&CGxiaoshu<=0.5){
        realXiaoshu=0.5;
    }else{
        realXiaoshu=0;
        
    }
    
    for (int i=40; i<45; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        imageView.size = CGSizeMake((self.frame.size.width - 30 - 16)/5, (self.frame.size.width - 30 - 16)/5);
        if (imageView.tag-40<realZhengshu) {
            //亮
            imageView.image=[UIImage imageNamed:@"满星"];
        }else if (imageView.tag-40==realZhengshu&&realXiaoshu!=0){
            //半亮
            imageView.image=[UIImage imageNamed:@"半星"];
            
        }else{
            //不亮
            imageView.image=[UIImage imageNamed:@"空星"];
        }
        
        
    }
    //---------------------------------------------------------------------------
    

}
@end
