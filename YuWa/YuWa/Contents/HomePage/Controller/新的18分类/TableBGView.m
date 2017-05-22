//
//  TableBGView.m
//  YuWa
//
//  Created by double on 17/2/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "TableBGView.h"
#import "CityCodeModel.h"
@interface TableBGView ()<UITableViewDelegate,UITableViewDataSource>
{
   UIView * line;
    NSInteger markTag;
    UIButton * markBtn;
}
@property (nonatomic,strong) UITableView * placeTableView;//商圈tableview
@property (nonatomic,copy) NSString * cityCode;//城市编码
@property (nonatomic,copy) NSString* type;
@property (nonatomic,strong)NSMutableArray * cityCodeAry;


@end
@implementation TableBGView
- (instancetype)initWithFrame:(CGRect)frame andTag:(NSInteger)tag{
    self = [super initWithFrame:frame];
    if (self) {
        _staus = tag;
        self.type = @"0";
        [self setPlaceBtn];
        [self makeTableView];
        [self getlocatCityCode];
    }
    return self;
}
- (void)setPlaceBtn{
    CGFloat btnWidth = (kScreen_Width - 80 - 100)/2;
    NSArray * title = @[@"全部地区",@"离我最近"];
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
        _placeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.height * 0.1f +1 , kScreen_Width, self.height * 0.9f) style:UITableViewStyleGrouped];
        
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
        return self.cityCodeAry.count;
    }else{
        return 3;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_staus == 1111) {
        if (self.titleBlock) {
            CityCodeModel * model = self.cityCodeAry[indexPath.row];
            for (UIButton *btn in self.subviews) {
                if (btn.tag == 1111) {
                    [btn setTitle:model.name forState:UIControlStateNormal];
                }
            }
            self.titleBlock(model.name,model.code);
        }
    }
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
        CityCodeModel * model = self.cityCodeAry[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.cinema_count];
        
    }else if (_staus == 1112){
        NSArray *  titleArr = @[@"离我最近",@"价格最低",@"好评优先"];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.textLabel.centerY = cell.height/2;
        return cell;
    }
    
    return cell;
}

//- (void)itemBtn:(UIButton*)sender{
//    MyLog(@"%ld",sender.tag);
//    if (sender.isSelected == YES) {
//        return;
//    }
//    sender.selected = YES;
//    markBtn.selected = NO;
//    markBtn = sender;
//    markTag = sender.tag;
//}

//获取地区编码
- (void)getlocatCityCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CITYCODE];
    
    self.cityCode = @"350500";
    NSDictionary * pragrams = @{@"area":self.cityCode,@"type":self.type};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数 %@",pragrams);
        MyLog(@"地区编码 %@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.cityCodeAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                CityCodeModel * model = [CityCodeModel yy_modelWithDictionary:dict];
                [self.cityCodeAry addObject:model];
            }
        }else{
            [JRToast showWithText:@"网络超时,请检查网络" duration:1];
        }
        [self.placeTableView reloadData];
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (void)completion{
    MyLog(@"完成%ld",markTag);
    
}

- (NSMutableArray*)cityCodeAry{
    if (!_cityCodeAry) {
        _cityCodeAry = [NSMutableArray array];
    }
    return _cityCodeAry;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
