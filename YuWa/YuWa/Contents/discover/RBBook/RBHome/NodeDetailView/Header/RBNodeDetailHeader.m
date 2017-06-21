//
//  RBNodeDetailHeader.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDetailHeader.h"
#import "HttpObject.h"
#import "JWTools.h"

@implementation RBNodeDetailHeader

- (void)awakeFromNib{
    [super awakeFromNib];
//    self.attentiionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.attentiionBtn.layer.borderWidth = 1.f;
    self.attentiionBtn.layer.cornerRadius = 5.f;
    self.attentiionBtn.layer.masksToBounds = YES;
    [self.attentiionBtn setUserInteractionEnabled:NO];
    
    self.iconImageView.layer.cornerRadius = 13.f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.reduceBtn.hidden = YES;
    
    self.reduceBtn.layer.cornerRadius = 5.f;
    self.reduceBtn.layer.masksToBounds = YES;
    [self.reduceBtn setUserInteractionEnabled:NO];

    
    self.frame = CGRectMake(0.f, 0.f, kScreen_Width, 55.f);
}

- (void)tapAction{
    self.otherBlock();
}

- (IBAction)reduceNodeBtn:(UIButton *)sender {
    if ([UserSession instance].isLogin) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"您确定要删除此笔记吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
 
        
    }else{
        
            self.backToLoginBlock();
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self requesetDelNode];
    }
    
}
- (void)requesetDelNode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_DELNODE];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_type":@(1),@"note_id":self.node_id};
    
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSInteger errorCode = [data[@"errorCode"] integerValue];
        if (errorCode == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            self.popBlock();
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
    
}
- (void)setIsUser:(BOOL)isUser{
    _isUser = isUser;
    if (self.isUser == YES) {
        
        self.attentiionBtn.hidden = YES;
        self.reduceBtn.hidden = NO;
        self.reduceBtn.userInteractionEnabled = YES;
    }else{
        self.attentiionBtn.hidden = NO;
        self.reduceBtn.hidden = YES;
        self.reduceBtn.userInteractionEnabled = NO;
        
    }
}



- (void)setInfavs:(NSString *)infavs{
    if (!infavs)return;
    _infavs = infavs;
    if ([self.infavs isEqualToString:@"0"]) {
        self.attentiionBtn.backgroundColor = CNaviColor;
        [self.attentiionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.attentiionBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    }else{
        self.attentiionBtn.backgroundColor = [UIColor whiteColor];
        [self.attentiionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.attentiionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
}

- (void)setModel:(RBNodeUserModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.nickname;
    //判断是否为手机号码，是就隐藏一部分
    if ([JWTools isNumberWithStr:self.model.nickname]) {
        NSString * number = [self.model.nickname substringToIndex:7];
        self.nameLabel.text = [NSString stringWithFormat:@"%@****",number];
    }
    if(self.model.user_type)self.levelImageView.hidden = [self.model.user_type integerValue]>=2?NO:YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.images] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
    [self.levelImageView sd_setImageWithURL:[NSURL URLWithString:self.model.level.image] placeholderImage:[UIImage imageNamed:@"level22"] completed:nil];
    
    [self.attentiionBtn setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSet{
    NSDictionary * attributes = @{NSFontAttributeName:self.nameLabel.font};
    CGRect conRect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,self.nameLabel.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    self.nameLabelWidth.constant = conRect.size.width + 5.f;
    [self setNeedsLayout];
}

- (IBAction)attentiionBtnAction:(id)sender {
    if ([UserSession instance].isLogin) {
        self.infavs = [self.infavs isEqualToString:@"0"]?@"1":@"0";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([self.infavs isEqualToString:@"1"]) {
                [self requestAttention];
            }else{
                [self requestAttentionCancel];
            }
        });
    }else{
        self.careBlock();
    }
}

#pragma mark - Http
- (void)requestAttention{//关注此人
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"attention_id":self.model.userid,@"auser_type":self.model.user_type,@"user_type":@(1)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_ATTENTION_ADD withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSInteger number = [responsObj[@"errorCode"] integerValue];
        if (number == 0) {
            [UserSession instance].attentionCount = [NSString stringWithFormat:@"%zi",[[UserSession instance].attentionCount integerValue]+1];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
- (void)requestAttentionCancel{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"attention_id":self.model.userid,@"auser_type":self.model.user_type,@"user_type":@(1)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_ATTENTION_CANCEL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSInteger number = [responsObj[@"errorCode"] integerValue];
        if (number == 0) {
            [UserSession instance].attentionCount = [NSString stringWithFormat:@"%zi",[[UserSession instance].attentionCount integerValue]-1];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
