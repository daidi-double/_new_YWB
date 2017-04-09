//
//  TableBGView.m
//  YuWa
//
//  Created by double on 17/2/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "TableBGView.h"
@interface TableBGView ()<UITableViewDelegate,UITableViewDataSource>
{
   UIView * line;
    NSInteger markTag;
    UIButton * markBtn;
}
@property (nonatomic,strong) UITableView * placeTableView;//商圈tableview

@property (nonatomic,assign) NSInteger reset;

@end
@implementation TableBGView
- (instancetype)initWithFrame:(CGRect)frame andTag:(NSInteger)tag{
    self = [super initWithFrame:frame];
    if (self) {
        _staus = tag;
        [self setPlaceBtn];
        [self makeTableView];
        
    }
    return self;
}
- (void)setPlaceBtn{
    CGFloat btnWidth = (kScreen_Width - 80 - 100)/2;
    NSArray * title = @[@"商圈",@"地铁站"];
    for (int i = 0; i<2; i ++) {
        UIButton * placeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        placeBtn.frame = CGRectMake(40 + (100 + btnWidth)*i, 0,btnWidth , self.height*0.1f);
        [placeBtn setTitle:title[i] forState:UIControlStateNormal];
        [placeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [placeBtn setTitleColor:CNaviColor forState:UIControlStateSelected];
        placeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [placeBtn addTarget:self action:@selector(choosePlace:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:placeBtn];
    }
    line = [[UIView alloc]initWithFrame:CGRectMake(40, self.height*0.1f-1, btnWidth, 1)];
    line.backgroundColor = CNaviColor;
    
    [self addSubview:line];
}
- (void)makeTableView{
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height * 0.1f, kScreen_Width, 1)];
    grayView.backgroundColor = [UIColor grayColor];
    [self addSubview:grayView];//分割线
    if (_staus == 1111) {
        _placeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.height * 0.1f +1 , kScreen_Width* 0.4f, self.height * 0.9f) style:UITableViewStylePlain];
        
    }else {
        _placeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.height * 0.1f +1 , kScreen_Width, self.height * 0.3f) style:UITableViewStylePlain];
    }
    _placeTableView.delegate = self;
    _placeTableView.dataSource = self;
    
    [self addSubview:_placeTableView];
}
-(void)choosePlace:(UIButton*)sender{
    
    line.centerX = sender.centerX;
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_staus == 1111) {
        return 9;
    }else if (_staus == 1112){
        return 3;
    }else{
        return 2;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"placeCell"];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for(UIView * view in cell.contentView.subviews){
        
        if([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
        if([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        
    }
    if (_staus == 1111) {
        cell.backgroundColor = RGBCOLOR(249, 249, 249, 1);
        cell.textLabel.text = @"全部";
        
    }else if (_staus == 1112){
        NSArray *  titleArr = @[@"离我最近",@"价格最低",@"好评优先"];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.textLabel.centerY = cell.height/2;
        return cell;
    }else{
        if (indexPath.row == 0) {
            
        UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.width * 0.3f, 20)];
        titleLbl.text = @"特色功能";
        titleLbl.font = [UIFont systemFontOfSize:12];
        titleLbl.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLbl];
        NSArray * functionArr = @[@"全部",@"可退票",@"可改签",@"会员卡"];
        CGFloat btnWidth = (kScreen_Width -20 - 30)/4;
        for (int i = 0; i<4; i++) {
            UIButton * functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            functionBtn.frame = CGRectMake(10 + (btnWidth +10)*i, 20, btnWidth, 22);
            [functionBtn setTitle:functionArr[i] forState:UIControlStateNormal];
            [functionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [functionBtn setTitleColor:CNaviColor forState:UIControlStateSelected];
            functionBtn.tag = 2000 + i;
            [functionBtn addTarget:self action:@selector(itemBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                functionBtn.selected = YES;
                markBtn = functionBtn;
            }
            if (_reset == 0) {
                if (functionBtn.tag == 1111) {
                    
                    functionBtn.selected = YES;
                    markBtn = functionBtn;
                    markTag = 2000;
                }
            }
            [cell.contentView addSubview:functionBtn];
        }
            
        }else{
            UIButton * resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            resetBtn.frame = CGRectMake(10, 5, cell.width * 0.25f, cell.height - 10);
            resetBtn.layer.masksToBounds = YES;
            resetBtn.layer.cornerRadius = 5;
            [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
            [resetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [resetBtn addTarget:self action:@selector(resetBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:resetBtn];

            
            UIButton * completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            completeBtn.frame = CGRectMake(cell.width * 0.65f, 5, cell.width * 0.25f, cell.height - 10);
            completeBtn.layer.masksToBounds = YES;
            completeBtn.layer.cornerRadius = 5;
            [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
            [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            completeBtn.backgroundColor = CNaviColor;
            [completeBtn addTarget:self action:@selector(completion) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:completeBtn];

        }

    }
    return cell;
}
- (void)resetBtn{
    _reset = 0;
    _staus = 1113;
    markTag = 2000;
    [_placeTableView reloadData];
}
- (void)itemBtn:(UIButton*)sender{
    MyLog(@"%ld",sender.tag);
    if (sender.isSelected == YES) {
        return;
    }
    sender.selected = YES;
    markBtn.selected = NO;
    markBtn = sender;
    markTag = sender.tag;
}
- (void)completion{
    MyLog(@"完成%ld",markTag);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
