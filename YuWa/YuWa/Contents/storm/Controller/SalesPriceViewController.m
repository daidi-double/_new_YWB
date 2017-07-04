//
//  SalesPriceViewController.m
//  YuWa
//
//  Created by double on 17/7/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SalesPriceViewController.h"
#import "NSString+JWAppendOtherStr.h"



@interface SalesPriceViewController ()<UIGestureRecognizerDelegate>
{
    UIView * btnBGView ;
}
@end

@implementation SalesPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatPayView];
    [self creatAddPriceView];
    [self creatDelegateView];
}
//创建底部视图
- (void)creatPayView{
    _BgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-45, kScreen_Width, 45)];
    _BgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_BgView];
    NSArray * imageAry = @[@"attend",@"more"];
    for (int i = 0; i<2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(13+(35+13)*i, 0, 35, 35);
        btn.centerY = _BgView.height/2;
        btn.tag = i+1;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageAry[i]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(salesAction:) forControlEvents:UIControlEventTouchUpInside];

        [_BgView addSubview:btn];
    }
    
    UIView * buleBGView = [[UIView alloc]initWithFrame:CGRectMake(100, 0, kScreen_Width-150, 35)];
    buleBGView.centerY = _BgView.height/2;
    buleBGView.backgroundColor = CNaviColor;
    [_BgView addSubview:buleBGView];
    
    self.directnessLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 35)];
    _directnessLabel.text =@"直接出价";
    _directnessLabel.centerY = buleBGView.height/2;
    _directnessLabel.textAlignment = 1;
    _directnessLabel.userInteractionEnabled = YES;
    _directnessLabel.textColor = [UIColor whiteColor];
    _directnessLabel.font = [UIFont systemFontOfSize:13];
    [buleBGView addSubview:_directnessLabel];
    
    self.myPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_directnessLabel.right, 0, buleBGView.width - 80, 35)];
    _myPriceLabel.text =@"￥7800";
    _myPriceLabel.centerY = buleBGView.height/2;
    _myPriceLabel.textAlignment = 1;
    _myPriceLabel.userInteractionEnabled = YES;
    _myPriceLabel.textColor = [UIColor whiteColor];
    _myPriceLabel.font = [UIFont systemFontOfSize:13];
    [buleBGView addSubview:_myPriceLabel];
    
    UITapGestureRecognizer * tapTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelView)];
    tapTouch.numberOfTapsRequired = 1;
    tapTouch.numberOfTouchesRequired = 1;
    tapTouch.delegate = self;
    [_directnessLabel addGestureRecognizer:tapTouch];
    [_myPriceLabel addGestureRecognizer:tapTouch];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(buleBGView.right, 0, 35, 35);
    addBtn.centerY = _BgView.height/2;
    [addBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"="] forState:UIControlStateSelected];
    [addBtn addTarget:self action:@selector(addPriceAction:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.layer.borderColor = CNaviColor.CGColor;
    addBtn.layer.borderWidth = 0.3f;
    [_BgView addSubview:addBtn];

    
}
//创建弹窗
- (void)creatAddPriceView{
    _delegatePriceBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _delegatePriceBGView.hidden = YES;
    [self.view addSubview:_delegatePriceBGView];
    
    UIToolbar * tool = [[UIToolbar alloc]initWithFrame:_delegatePriceBGView.bounds];
    tool.alpha = 0.95f;
    tool.barStyle = UIBarStyleBlackTranslucent;
    [_delegatePriceBGView addSubview:tool];
    
    
    _delegateBGView = [[UIView alloc]initWithFrame:CGRectMake(18, 0, kScreen_Width - 36, kScreen_Height * 794/1334)];
    if (IS_IPHONE_5) {
        _delegateBGView.height = 440.f;
    }
    _delegateBGView.centerY = (kScreen_Height-NavigationHeight)/2+30;
    _delegateBGView.backgroundColor = [UIColor whiteColor];
    [_delegatePriceBGView addSubview:_delegateBGView];
    
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 5, kScreen_Width/4, 30)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"代理出价";
    [_delegateBGView addSubview:titleLabel];
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kScreen_Width -83, 5, 30, 30);
    [cancelBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelWindows) forControlEvents:UIControlEventTouchUpInside];
    [_delegateBGView addSubview:cancelBtn];
    
    UIView * lightLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreen_Width-36, 10)];
    lightLine.backgroundColor = RGBCOLOR(234, 235, 236, 1);
    [_delegateBGView addSubview:lightLine];
    
    
    _cautionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, lightLine.bottom + 30, kScreen_Width/2, 35)];
    _cautionTitleLabel.textColor = LightColor;
    _cautionTitleLabel.textAlignment = 1;
    _cautionTitleLabel.font = [UIFont systemFontOfSize:15];
    _cautionTitleLabel.text = @"当前价：￥7800";
    _cautionTitleLabel.centerX = kScreen_Width/2;
    CGRect NameWidth = [_cautionTitleLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width/2, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    _cautionTitleLabel.width = NameWidth.size.width+30;
    _cautionTitleLabel.layer.masksToBounds = YES;
    _cautionTitleLabel.layer.cornerRadius = 17.5f;
    _cautionTitleLabel.layer.borderWidth = 0.3;
    _cautionTitleLabel.layer.borderColor = CNaviColor.CGColor;
    [_delegateBGView addSubview:_cautionTitleLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _cautionTitleLabel.bottom+27, 80, 35)];
    _priceLabel.centerX = _delegateBGView.width/2;
    _priceLabel.textColor = LightColor;
    _priceLabel.textAlignment = 1;
    _priceLabel.font = [UIFont systemFontOfSize:30];
    _priceLabel.text = @"8800";
    [_delegateBGView addSubview:_priceLabel];

 //加减按钮
    NSArray * imageAry = @[@"reduceprice",@"addprice"];
    for (int i = 0; i<2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i== 0) {
            
            btn.frame = CGRectMake(_priceLabel.left - 45-35, 0, 35, 35);
        }else{
             btn.frame = CGRectMake(_priceLabel.right +45, 0, 35, 35);
        }
        btn.centerY = _priceLabel.centerY;
        btn.tag = i+10;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageAry[i]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addOrReduceAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_delegateBGView addSubview:btn];
    }
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, lightLine.bottom + 150, _delegateBGView.width, 1)];
    _line.backgroundColor = RGBCOLOR(231, 232, 233, 1);
    [_delegateBGView addSubview:_line];
    
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(20, _delegateBGView.bottom- 125, _delegateBGView.width- 40, 35);
    sureBtn.backgroundColor = CNaviColor;
    [sureBtn setTitle:@"确定代理" forState:UIControlStateNormal];
    sureBtn.titleLabel.textColor = [UIColor whiteColor];
    [sureBtn addTarget:self action:@selector(sureDelegate) forControlEvents:UIControlEventTouchUpInside];
    [_delegateBGView addSubview:sureBtn];
}
- (void)creatDelegateView{
    btnBGView = [[UIView alloc]initWithFrame:CGRectMake(20, self.BgView.bottom, kScreen_Width/4, kScreen_Width/4)];
    btnBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnBGView];
    
    UIButton * delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delegateBtn.frame = CGRectMake(0, 0, kScreen_Width/4, kScreen_Width/4);

    [delegateBtn setTitle:@"代理出价" forState:UIControlStateNormal];
    [delegateBtn setImage:[UIImage imageNamed:@"delegateprice"] forState:UIControlStateNormal];
    [delegateBtn setTitleColor:LightColor forState:UIControlStateNormal];
    [delegateBtn setTitleEdgeInsets:UIEdgeInsetsMake(delegateBtn.imageView.frame.size.height ,-delegateBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [delegateBtn setImageEdgeInsets:UIEdgeInsetsMake(-delegateBtn.titleLabel.bounds.size.height, delegateBtn.titleLabel.bounds.size.width/2,0.0,-delegateBtn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边

    delegateBtn.titleLabel.textColor = [UIColor whiteColor];
    [delegateBtn addTarget:self action:@selector(delegatePrice) forControlEvents:UIControlEventTouchUpInside];
    [btnBGView addSubview:delegateBtn];
}
//代理出价按钮
- (void)delegatePrice{
    MyLog(@"代理出价");
}
- (void)sureDelegate{
    MyLog(@"确定代理");
    self.delegatePriceBGView.hidden = YES;
}

- (void)addOrReduceAction:(UIButton *)sender{
    switch (sender.tag) {
        case 10:
            MyLog(@"减");
            break;
            
        default:
             MyLog(@"加");
            break;
    }
}
- (void)cancelWindows{
    self.delegatePriceBGView.hidden = YES;
}
- (void)cancelView{
   self.delegatePriceBGView.hidden = NO;
}
- (void)addPriceAction:(UIButton*)sender{
    MyLog(@"显示代理出价");
    sender.selected = !sender.selected;

    if (sender.selected) {
        
        self.BgView.frame = CGRectMake(0, kScreen_Height-145, kScreen_Width, 45);
    }else{
        self.BgView.frame = CGRectMake(0, kScreen_Height-45, kScreen_Width, 45);
    }
    btnBGView.frame = CGRectMake(20, self.BgView.bottom, kScreen_Width/4, kScreen_Width/4);
}
- (void)salesAction:(UIButton*)sender{
    switch (sender.tag) {
        case 1://竞拍
            
            break;
            
        default://更多
            
            break;
    }
}
-(CGFloat)getCellHeightStr:(NSString*)content contentOfFont:(NSInteger)font{
    
    CGFloat labelHeight =[content boundingRectWithSize:CGSizeMake(kScreen_Width - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size.height;
    return labelHeight;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
