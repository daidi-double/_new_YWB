//
//  OtherTicketPayTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketPayTableViewCell.h"

@implementation OtherTicketPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSInteger number = [self.numberLabel.text integerValue];
    if (number == 0) {
       self.reduceBtn.enabled = NO;
    }
    // Initialization code
}
- (IBAction)reduceAction:(UIButton *)sender {
    NSInteger number = [self.numberLabel.text integerValue];
    if (number == 1) {
        sender.enabled = NO;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%zi",number-1];
    [self.delegate reduceOrAddTicket:2];
    
}
- (IBAction)addAction:(UIButton *)sender {
    self.reduceBtn.enabled = YES;
    NSInteger number = [self.numberLabel.text integerValue];
    self.numberLabel.text = [NSString stringWithFormat:@"%zi",number+1];

    [self.delegate reduceOrAddTicket:1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
