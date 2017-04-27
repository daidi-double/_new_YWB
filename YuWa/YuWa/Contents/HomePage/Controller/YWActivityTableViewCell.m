//
//  YWActivityTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWActivityTableViewCell.h"

@implementation YWActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setZhekou:(NSString *)zhekou{
    _zhekou = zhekou;
    
}
-(void)setHolidayArray:(NSArray *)holidayArray{
    
    
    //显示的特别活动
    NSArray*specail=holidayArray;
    CGFloat top = 61.0;
    CGFloat left = 13.0;
    //首先移除所有的东西
    for (UIView*view in self.saveAllImage) {
        [view removeFromSuperview];
    }
    
    for (UIView*view2 in self.saveAllLabel) {
        [view2 removeFromSuperview];
    }
    if (specail.count>0) {
        for (int i=0; i<specail.count; i++) {
            
            UIImageView*speImage=[self viewWithTag:200+i];
            if (!speImage) {
                speImage=[[UIImageView alloc]initWithFrame:CGRectMake(left, top, 20, 20)];
                speImage.tag=200+i;
            }
            [self.contentView addSubview:speImage];
            [self.saveAllImage addObject:speImage];
            speImage.image=[UIImage imageNamed:@"home_te"];
            
            UILabel*specailLabel=[self viewWithTag:300+i];
            if (!specailLabel) {
                specailLabel=[[UILabel alloc]initWithFrame:CGRectMake(left+25, top, kScreen_Width-110, 20)];
                specailLabel.font=[UIFont systemFontOfSize:14];
                specailLabel.textColor = RGBCOLOR(141, 142, 143, 1);
                specailLabel.tag=300+i;
                
            }
            [self.contentView addSubview:specailLabel];
            [self.saveAllLabel addObject:specailLabel];
            NSDictionary*dict=specail[i];
            NSString*zheNum=[dict[@"rebate"] substringFromIndex:2];
            if ([zheNum integerValue] % 10 == 0) {
                zheNum = [NSString stringWithFormat:@"%ld",[zheNum integerValue]/10];
            }else{
                zheNum = [NSString stringWithFormat:@"%.1f",[zheNum floatValue]/10];
            }
            specailLabel.text=[NSString stringWithFormat:@"%@折,闪付特享",zheNum];
            
            CGFloat numF=[dict[@"rebate"] floatValue];
            if (numF>=1 || numF<=0.00) {
                specailLabel.text=@"无特惠";
            }
            
            top=top+20+6;
        }
        
    }else{
        UIImageView*speImage=[self viewWithTag:200];

        [self.contentView addSubview:speImage];
        [self.saveAllImage addObject:speImage];
        
        speImage.image=[UIImage imageNamed:@"home_te"];
        UILabel*specailLabel=[self viewWithTag:300];

        [self.contentView addSubview:specailLabel];
        [self.saveAllLabel addObject:specailLabel];

        CGFloat zhek = [self.zhekou floatValue]*10;
        NSString*zheNum=[self.zhekou substringFromIndex:2];
        if ([zheNum integerValue] % 10 == 0) {
            zheNum = [NSString stringWithFormat:@"%ld",[zheNum integerValue]/10];
        }else{
            zheNum = [NSString stringWithFormat:@"%.1f",[zheNum floatValue]/10];
        }
        specailLabel.text=[NSString stringWithFormat:@"%@折,闪付特享",zheNum];
        
        //        MyLog(@"zhekou23 = %f",zhek);
        if (zhek>=10 || zhek<=1.00) {
            specailLabel.text=@"无特惠";
        }
        
        
    }
    
    
}


+(CGFloat)getCellHeight:(NSArray*)array{
    CGFloat top=61.0;
    for (int i=0; i<array.count; i++) {
        top=top+20+6;
    }
    
    return top;
    
}
-(NSMutableArray *)saveAllImage{
    if (!_saveAllImage) {
        _saveAllImage=[NSMutableArray array];
    }
    return _saveAllImage;
    
}

-(NSMutableArray *)saveAllLabel{
    if (!_saveAllLabel) {
        _saveAllLabel=[NSMutableArray array];
    }
    return _saveAllLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end