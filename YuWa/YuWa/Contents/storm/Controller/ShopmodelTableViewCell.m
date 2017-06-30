//
//  ShopmodelTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShopmodelTableViewCell.h"

@implementation ShopmodelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.firstLabel];
        [self.contentView addSubview:self.secondLabel];
        [self.contentView addSubview:self.threeLabel];
        [self.contentView addSubview:self.fourLabel];
    }
    return self;
}
- (UILabel*)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 21, kScreen_Width-28, (kScreen_Height *714/1334-108)/4)];
        _firstLabel.textColor = LightColor;
        _firstLabel.font = [UIFont systemFontOfSize:13];
        _firstLabel.numberOfLines = 0;
        _firstLabel.text = @"1、通过大规模培训输出菜场肉铺，通过大规模培训输出菜场肉铺，通过大规模培训输出菜场肉铺,通过大规模培训输出菜场肉铺，通过大规模培训输出菜场肉铺。";
    }
    return _firstLabel;
}
- (UILabel*)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, self.firstLabel.bottom+20, kScreen_Width-28, (kScreen_Height *714/1334-108)/4)];
        _secondLabel.textColor = LightColor;
        _secondLabel.font = [UIFont systemFontOfSize:13];
        _secondLabel.numberOfLines = 0;
        _secondLabel.text = @"2、通过大规模培训输出菜场肉铺。通过大规模培训输出菜场肉铺。通过大规模培训输出菜场肉铺";
    }
    return _secondLabel;
}
- (UILabel*)threeLabel{
    if (!_threeLabel) {
        _threeLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, self.secondLabel.bottom+20, kScreen_Width-28, (kScreen_Height *714/1334-108)/4)];
        _threeLabel.textColor = LightColor;
        _threeLabel.font = [UIFont systemFontOfSize:13];
        _threeLabel.numberOfLines = 0;
        _threeLabel.text = @"地方垃圾发了发了疯马恶犯佛；aijefaklnva.v啊；发哦发妈妈女啊阿佛案件麻烦漫卷；fiaj'ak/vavaofja阿妈率哦啊的v发大奖哦费劲啊啊快女阿卡局我AV的那可就阿尔法而非卡";
    }
    return _threeLabel;
}
- (UILabel*)fourLabel{
    if (!_fourLabel) {
        _fourLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, self.threeLabel.bottom+20, kScreen_Width-28, (kScreen_Height *714/1334-108)/4)];
        _fourLabel.textColor = LightColor;
        _fourLabel.font = [UIFont systemFontOfSize:13];
        _fourLabel.numberOfLines = 0;
        _fourLabel.text = @"地方垃圾发了发了疯马恶犯佛；aijefaklnva.v啊；发哦发妈妈女啊阿佛案件麻烦漫卷；fiaj'ak/vavaofja阿妈率哦啊的v发大奖哦费劲啊啊快女阿卡局我AV的那可就阿尔法而非卡";
    }
    return _fourLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
