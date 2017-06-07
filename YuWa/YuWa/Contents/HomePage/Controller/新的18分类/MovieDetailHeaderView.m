//
//  MovieDetailHeaderView.m
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieDetailHeaderView.h"
@interface MovieDetailHeaderView()<ChooseMovieHeaderViewDelegate>

@end
@implementation MovieDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    
    if (self) {

        
    }
    return self;
}

- (void)setModel:(CinemaAndBuyTicketModel *)model{
    _model = model;
    [self setData];
}
- (void)setData{

    self.backgroundColor = [UIColor whiteColor];
//    self.headerView.model = self.model;
//    [self.headerView.posterImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.poster]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    self.introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.headerView.bottom + 15 , kScreen_Width -30, self.height * 0.3f - 35.f)];
    self.introduceLabel.text = self.model.intro;
    _introduceLabel.frame= CGRectMake(16, self.line.bottom + 18, kScreen_Width -32 , [self getLabelHeight:self.model.intro]);

}


- (UILabel*)daoyanLabel{
    if (!_daoyanLabel) {
        _daoyanLabel = [[UILabel alloc]initWithFrame:CGRectMake(16,18, kScreen_Width-32, self.bounds.size.height*0.1f)];
        _daoyanLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _daoyanLabel.font = [UIFont systemFontOfSize:12];
         self.daoyanLabel.text = @"导演:";
        [self addSubview:_daoyanLabel];
    }
    return _daoyanLabel;
}
- (UILabel*)performerLabel{
    if (!_performerLabel) {
        _performerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.daoyanLabel.origin.x, self.daoyanLabel.bottom, kScreen_Width-32, self.bounds.size.height*0.2f)];
        _performerLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _performerLabel.numberOfLines = 0;
        _performerLabel.font = [UIFont systemFontOfSize:12];
        _performerLabel.text = @"主演:";

        [self addSubview:_performerLabel];
     }
    return _performerLabel;
}
- (UILabel*)categoryLabel{
    if (!_categoryLabel) {
        _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.daoyanLabel.origin.x, self.performerLabel.bottom, kScreen_Width-32, self.bounds.size.height*0.1f)];
        _categoryLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _categoryLabel.font = [UIFont systemFontOfSize:12];
        _categoryLabel.text = @"类型:";
        
        [self addSubview:_categoryLabel];
    }
    return _categoryLabel;
}

- (UILabel*)countryLabel{
    if (!_countryLabel) {
        _countryLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.daoyanLabel.origin.x, self.categoryLabel.bottom, kScreen_Width-32, self.bounds.size.height*0.1f)];
        _countryLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _countryLabel.font = [UIFont systemFontOfSize:12];
        _countryLabel.text = @"地区/国家:";
        
        [self addSubview:_countryLabel];
    }
    return _countryLabel;
}
- (UIView*)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(16, self.countryLabel.bottom+16, kScreen_Width-32, 0.5)];
        _line.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        [self addSubview:_line];
    }
    return _line;
}

- (UILabel*)introduceLabel{
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, self.line.bottom + 18, kScreen_Width - 32, 20)];
        if (self.model.intro == nil) {
            _introduceLabel.height = 0;
        }else{
            _introduceLabel.height = 200;
        }
        _introduceLabel.numberOfLines = 0;
        _introduceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _introduceLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_introduceLabel];
    }
    return _introduceLabel;
}
- (UIButton*)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(0, self.introduceLabel.bottom +35, 35, 35);
        [_moreBtn setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreIntro) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
    }
    return _moreBtn;
}
//自动计算label宽高
- (CGFloat)getLabelHeight:(NSString *)str{
    CGRect labelHeight = [str boundingRectWithSize:CGSizeMake(kScreen_Width-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return labelHeight.size.height;
}

+(CGFloat)getHeaderHeight:(NSString *)introduce{
    CGRect labelHeight = [introduce boundingRectWithSize:CGSizeMake(kScreen_Width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return labelHeight.size.height+kScreen_Height * 0.3f + 35;

}

-(void)commend{
    [self.delegate toCommentScore];
}
- (void)moreIntro{
    [self layoutIfNeeded];
}
- (void)layoutIfNeeded{
    self.introduceLabel.frame = CGRectMake(16, self.line.bottom + 18, kScreen_Width - 32, [self getLabelHeight:self.model.intro]);
}
@end
