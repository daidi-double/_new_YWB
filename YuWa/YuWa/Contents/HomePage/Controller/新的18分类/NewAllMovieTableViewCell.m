//
//  NewAllMovieTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "NewAllMovieTableViewCell.h"

@implementation NewAllMovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyBtn.layer.borderColor = CNaviColor.CGColor;
    self.buyBtn.layer.borderWidth = 1;
    self.buyBtn.layer.cornerRadius = 5;
    [self.buyBtn.layer setMasksToBounds:YES];
}

- (void)setModel:(HotMovieModel *)model{
    _model = model;
    [self setCellData];
}
-(void)setCellData{
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.image]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.movieNameLabel.text = self.model.name;
    
    //星星数量 -------------------------------------------------------
    CGFloat realZhengshu;
    CGFloat realXiaoshu;
    NSString*starNmuber1=self.model.score;
    CGFloat totalScroe = [starNmuber1 floatValue]/2;
    NSString *starNmuber = [NSString stringWithFormat:@"%.2f",totalScroe];
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>=0.75) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>0&&CGxiaoshu<0.25){
        realXiaoshu=0;
    }else{
        realXiaoshu=0.5;
        
    }
    
    for (int i=40; i<45; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        if (imageView.tag-40<realZhengshu) {
            //亮
            imageView.image=[UIImage imageNamed:@"home_lightStar"];
        }else if (imageView.tag-40==realZhengshu&&realXiaoshu<0.75 && realXiaoshu >=0.25){
            //半亮
            imageView.image=[UIImage imageNamed:@"home_halfStar"];
            
        }else{
            //不亮
            imageView.image=[UIImage imageNamed:@"home_grayStar"];
        }
        
        
    }
    //---------------------------------------------------------------------------
    self.introduceLabel.text = self.model.intro;

}
- (IBAction)toBuyTicketAction:(UIButton *)sender {
    [self.deletage toBuyTicket:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
