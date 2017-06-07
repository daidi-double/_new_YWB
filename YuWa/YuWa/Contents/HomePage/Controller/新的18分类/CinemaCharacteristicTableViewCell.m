//
//  CinemaCharacteristicTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinemaCharacteristicTableViewCell.h"

@implementation CinemaCharacteristicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setImageAry:(NSArray *)imageAry{
    _imageAry = imageAry;
    
    [self setData];
    
}

- (void)setData{
    
    self.imageScrollView.contentSize = CGSizeMake(((kScreen_Width -48)/4 +8) * self.imageAry.count, self.height-16);
    
    for (int i = 0; i<_imageAry.count; i ++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + ((kScreen_Width -48 )/4 +8)*i, 8, (kScreen_Width -48)/4, self.height-16)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageAry[i]]] placeholderImage:[UIImage imageNamed:@"palceholder"]];
        [self.imageScrollView addSubview:imageView];
    }
}

//查看所有的剧照
- (IBAction)allPhotoAction:(UIButton *)sender {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
