//
//  headerView.m
//  YuWa
//
//  Created by L灰灰Y on 2017/4/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "headerView.h"

@interface headerView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *allMoney;

@end
@implementation headerView
-(void)setAll:(float)all{
    _all = all;
          
    if (_all<0) {
        self.imageView.image =  [UIImage  imageNamed:@"remove"];
    }else{
        self.imageView.image = [UIImage  imageNamed:@"add"];
    }
    self.allMoney.text = @"9998";
}
@end
