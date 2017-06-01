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
@property (nonatomic,strong) UITableView * rightTableView;
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
        placeBtn.frame = CGRectMake(40 + (100 + btnWidth)*i, 0,btnWidth ,30);
        [placeBtn setTitle:title[i] forState:UIControlStateNormal];
        [placeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        placeBtn.tag = 1111+i;
        [placeBtn setTitleColor:CNaviColor forState:UIControlStateSelected];
        placeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [placeBtn addTarget:self action:@selector(choosePlace:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:placeBtn];
    }
    line = [[UIView alloc]initWithFrame:CGRectMake(40, 25, btnWidth, 1)];
    if (self.staus == 1111) {
        line.centerX = 40 + btnWidth/2;
    }else{
        line.centerX = 40 +btnWidth+100+btnWidth/2;
    }
    line.backgroundColor = CNaviColor;
    
    [self addSubview:line];
}
- (void)makeTableView{
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 1)];
    grayView.backgroundColor = RGBCOLOR(222, 220, 223, 1);
    [self addSubview:grayView];//分割线
    _placeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,30 , kScreen_Width, self.height) style:UITableViewStyleGrouped];
    _placeTableView.delegate = self;
    _placeTableView.dataSource = self;
    
    [self addSubview:_placeTableView];
    self.rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,30 , kScreen_Width, self.height) style:UITableViewStyleGrouped];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    [self addSubview:self.rightTableView];

    if (_staus == 1111) {
        self.rightTableView.hidden = YES;

    }else {
        self.placeTableView.hidden = YES;
    }
}

-(void)choosePlace:(UIButton*)sender{
    
    line.centerX = sender.centerX;
    switch (sender.tag) {
        case 1111:
            self.rightTableView.hidden = YES;
            [self.delegate creatPlaceView:sender.tag];
            break;
            
        default:
            
            self.placeTableView.hidden = YES;
            [self.delegate creatPlaceView:sender.tag];
            break;
    }
    
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == _placeTableView) {
        return self.cityCodeAry.count;
    }else{
        return 3;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _placeTableView) {
        if (self.titleBlock) {
            CityCodeModel * model = self.cityCodeAry[indexPath.row];
            for (UIButton *btn in self.subviews) {
                if (btn.tag == 1111) {
                    [btn setTitle:model.name forState:UIControlStateNormal];
                }
            }
            self.titleBlock(model.name,model.code);
        }
    }else{
        if (self.titleBlockT) {
            NSArray *  titleArr = @[@"离我最近",@"价格最低",@"好评优先"];;
            for (UIButton *btn in self.subviews) {
                if (btn.tag == 1112) {
                    [btn setTitle:titleArr[indexPath.row] forState:UIControlStateNormal];
                }
            }
            NSString * listCode = [NSString stringWithFormat:@"%ld",indexPath.row];
            self.titleBlockT(titleArr[indexPath.row],listCode);
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"placeCell"];
    }

    if (tableView == _placeTableView) {
        cell.backgroundColor = RGBCOLOR(249, 249, 249, 1);
        CityCodeModel * model = self.cityCodeAry[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.cinema_count];
    }else{
        NSArray *  titleArr = @[@"离我最近",@"价格最低",@"好评优先"];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.textLabel.centerY = cell.height/2;
        return cell;
    }
    return cell;
}


//获取地区编码
- (void)getlocatCityCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CITYCODE];
    
    self.cityCode = @"110000";
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
