//
//  CategoryLeftTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CategoryLeftTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"
@implementation CategoryLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (void)setModel:(ShopDetailGoodsModel *)model{
    _model = model;
    [self setData];
}
- (void)setData{
    [_shop_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.goods_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.goods_id = self.model.goods_id;
    _shop_nameLabel.text = self.model.goods_name;
    self.shop_nameLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    self.monthPayLabel.text = [NSString stringWithFormat:@"月销售%@份",self.model.month_sales];
    NSString * price;
    self.monthPayLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    if (self.model.goods_disprice == nil ||[self.model.goods_disprice isKindOfClass:[NSNull class]]) {
        price = self.model.goods_price;
        self.oldPriceLabel.hidden = YES;
    }else{
        price = self.model.goods_disprice;
        NSString * str = [NSString stringWithFormat:@"￥%@",self.model.goods_price];
        NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,str.length)];
        
        self.oldPriceLabel.attributedText = attributeMarket;

    }
    self.priceLabel.attributedText = [NSString stringWithFirstStr:@"￥" withFont:[UIFont systemFontOfSize:12.f] withColor:RGBCOLOR(255, 152, 125, 1) withSecondtStr:[NSString stringWithFormat:@"%@",price]  withFont:[UIFont systemFontOfSize:15.f] withColor:RGBCOLOR(255, 152, 125, 1)];
 
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
