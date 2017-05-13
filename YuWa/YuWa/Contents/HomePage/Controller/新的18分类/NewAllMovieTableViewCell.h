//
//  NewAllMovieTableViewCell.h
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotMovieModel.h"
@protocol NewAllMovieTableViewCellDeletage <NSObject>

-(void)toBuyTicket:(UIButton*)sender;

@end
@interface NewAllMovieTableViewCell : UITableViewCell
@property (nonatomic,strong) HotMovieModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (nonatomic,assign)id<NewAllMovieTableViewCellDeletage>deletage;

@end
