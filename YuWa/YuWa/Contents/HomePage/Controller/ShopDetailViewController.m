//
//  ShopDetailViewController.m
//  YuWa
//
//  Created by double on 17/4/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopdetailModel.h"
#import "CommentModel.h"
#import "ShowShoppingModel.h"
#import "NSString+JWAppendOtherStr.h"
#import "HPRecommendShopModel.h"
#import "StorePhotoViewController.h" //相册
#import "ScheduleViewController.h"    //预定
#import "YWLoginViewController.h"
#import "MapNavNewViewController.h"//地图导航
#import "YWPayViewController.h"    //优惠买单
#import "YWNewDiscountPayViewController.h"//新的优惠买单
#import "ShowMoreCommitViewController.h"
#import "ShopDetailGoodsModel.h"//商品model
#import "CategoryLeftTableViewCell.h"//类别的cell
#import "YWShopCarView.h"
#import "YWShopCommitView.h"//评价
#import "YWShopDetailViewController.h"
#import "ShopCarDeViewController.h"//购物车

#define CATEGORYCELL @"CategoryLeftTableViewCell"
@interface ShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,YWShopCarViewDelegate>
{
    UIButton * markBtn;
    UIView * line;
    UIView * lineView;
    UIView * markView;
    NSIndexPath * markPath;
}
@property(nonatomic,strong)ShopdetailModel*mainModel;   //大model
@property(nonatomic,strong)NSMutableArray*maMDatasGoods;  //左边的大分类
@property(nonatomic,strong)NSMutableArray * shops;//购物车里的物品
@property(nonatomic,strong)ShowShoppingModel * shopModel;//右边商品model
@property(nonatomic,strong)NSMutableArray*maMCommit;  //所有评论的model
@property(nonatomic,strong)NSMutableArray*maMRecommend; //推荐的model
@property (weak, nonatomic) IBOutlet UIView *touchInfoView;

@property (weak, nonatomic) IBOutlet UIView *touchMapView;//用来跳转地图
@property (nonatomic,strong)UIButton * btn;
@property (nonatomic,assign)BOOL isRoll;//判断左侧点击的时候，右侧滚动方法不影响左侧
@property (nonatomic,strong)YWShopCarView * shopCarView;//选则的商品
@property (nonatomic,strong)UIView * touchView;
@property (nonatomic,assign)BOOL isRemove;
@property(nonatomic,strong)NSMutableArray* markCells;//清空购物车时用
@property (nonatomic,strong)YWShopCommitView * commentView;//评价
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self getDatas];
     self.commentView.hidden = YES;

    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"清除数量" object:nil];
}
-(void)notice:(id)sender{
    [self clearNumberOfShop];
    [self clearShopCar:self.shop_id];
    [self.shops removeAllObjects];
    [self.rightTableView reloadData];
    [self.leftTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
   
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden  = NO;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"清除数量" object:nil];
    
}
- (void)makeUI{
    
    self.BGImageView.userInteractionEnabled = YES;
    self.BGImageView.contentMode = UIViewContentModeScaleToFill;
    self.numberLabel.hidden = YES;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //    effectView.backgroundColor = [UIColor orangeColor];
    effectView.frame = self.BGImageView.frame;
    effectView.alpha  = 0.97;
    [self.BGView insertSubview:effectView aboveSubview:self.BGImageView];
//    
    [self.rightTableView registerNib:[UINib nibWithNibName:CATEGORYCELL bundle:nil] forCellReuseIdentifier:CATEGORYCELL];
    
    UITapGestureRecognizer * mapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMapView)];
    mapTap.numberOfTapsRequired = 1;
    mapTap.numberOfTouchesRequired = 1;
    mapTap.delegate = self;
    [self.touchMapView addGestureRecognizer:mapTap];

    UITapGestureRecognizer * shopInfoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toShopDetail)];
    shopInfoTap.numberOfTapsRequired = 1;
    shopInfoTap.numberOfTouchesRequired = 1;
    shopInfoTap.delegate = self;
    [self.touchInfoView addGestureRecognizer:shopInfoTap];
    NSArray * btnTitle = @[@"商品",@"评价（4.3）"];
    for (int i = 0; i<2; i++) {
        if (i == 0) {
            
        }
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(kScreen_Width/2*i, 0, kScreen_Width/2, 28);
//        btn.centerY = self.shopAndCommontView.height/2;
        _btn.tag = 100 + i;
        [_btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:13];
        if (i == 1) {
            if (self.mainModel.score == nil || [self.mainModel.score isKindOfClass:[NSNull class]]) {
                self.mainModel.score = @"1.0";
            }
            [_btn setAttributedTitle:[NSString stringWithFirstStr:@"评价  " withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor colorWithHexString:@"#333333"] withSecondtStr:[NSString stringWithFormat:@"(%@)",self.mainModel.score]  withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor colorWithHexString:@"#fe8238"]] forState:UIControlStateNormal];
        }
        
        if (i == 0) {
            _btn.selected = YES;
            markBtn.selected = NO;
          markBtn = _btn;
        }
        [_btn setTitleEdgeInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
        [_btn setTitleColor:[UIColor colorWithHexString:@"#5dc0ea"] forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(shopAndCommitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.shopAndCommontView addSubview:_btn];
        
        
    }
    line = [[UIView alloc]initWithFrame:CGRectMake(0, 23, kScreen_Width/8, 1)];
    line.centerX = kScreen_Width/4;
    line.backgroundColor = [UIColor colorWithHexString:@"#5dc0ea"];
    
    [self.shopAndCommontView addSubview:line];
   
    

}
//跳店铺详情，有无wifi等
- (void)toShopDetail{
    YWShopDetailViewController * detailVC = [[YWShopDetailViewController alloc]init];
    detailVC.shop_id = self.shop_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)shopAndCommitAction:(UIButton *)sender{
    if (sender.selected == YES) {
        return;
    }
    sender.selected = YES;
    markBtn.selected = NO;
    markBtn = sender;
    line.centerX = sender.centerX;
    switch (sender.tag) {
        case 100:
            self.leftTableView.hidden = NO;
            self.rightTableView.hidden = NO;
            self.accountBGView.hidden = NO;
            self.commentView.hidden = YES;
            break;
            
        default:
            self.leftTableView.hidden = YES;
            self.rightTableView.hidden = YES;
            self.accountBGView.hidden = YES;
            self.commentView.hidden = NO;
           [self.view addSubview:self.commentView];
            
            break;
    }
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _leftTableView) {
        return 1;
    }
    return self.maMDatasGoods.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return self.maMDatasGoods.count;
    }
    ShowShoppingModel * model = self.maMDatasGoods[section];
    return model.cat_goods.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        return 52.f;
    }
    return 80.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"table"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table"];
    }
        _leftTableView.showsVerticalScrollIndicator = NO;

        cell.contentView.backgroundColor = RGBCOLOR(246, 247, 248, 1);
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, cell.width-6, cell.frame.size.height)];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        ShowShoppingModel * showModel = self.maMDatasGoods[indexPath.row];
        cell.textLabel.text = showModel.cat_name;
        cell.textLabel.textColor = RGBCOLOR(103, 104, 105, 1);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 52)];
        lineView.backgroundColor = CNaviColor;
        
        [cell.selectedBackgroundView addSubview:lineView];
        

        return cell;
    }else{
        ShowShoppingModel * model = self.maMDatasGoods[indexPath.section];
        
        CategoryLeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CATEGORYCELL];
        NSDictionary * dit = model.cat_goods[indexPath.row];
        ShopDetailGoodsModel * shopModel = [ShopDetailGoodsModel yy_modelWithDictionary:dit];
        cell.model = shopModel;
        UIButton * addBtn = [cell viewWithTag:11];
        [addBtn addTarget:self action:@selector(addShopAction:) forControlEvents:UIControlEventTouchUpInside];
        UIButton * reduceBtn = [cell viewWithTag:10];
        [reduceBtn addTarget:self action:@selector(reduceShopAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([cell.numberLabel.text integerValue] == 0) {
            reduceBtn.enabled = NO;
            reduceBtn.hidden = YES;
        }

        return cell;
    }
    
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _rightTableView) {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
        bgView.backgroundColor = RGBCOLOR(246, 247, 248, 1);
       UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, tableView.width, 25)];
        ShowShoppingModel * showModel = self.maMDatasGoods[section];
        titleLabel.text = showModel.cat_name;
        titleLabel.textColor = RGBCOLOR(103, 104, 105, 1);
        titleLabel.backgroundColor = RGBCOLOR(246, 247, 248, 1);
        titleLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:titleLabel];
        return bgView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _rightTableView) {
        return 25;
    }
    return 0.01;
}

//MARK: - 点击 cell 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 判断是否为 左侧 的 tableView
    if (tableView == self.leftTableView) {
        
        // 计算出 右侧 tableView 将要 滚动的 位置
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        
        // 将右侧 tableView 移动到指定位置(点击左边最后一个cell无法选中)
        [self.rightTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        self.isRoll = YES;
        // 取消选中效果
        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath animated:YES];
//        lineView.hidden = NO;
//        markView.hidden = YES;
//        markView = lineView;
    }
    if (tableView == self.rightTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isRoll == NO) {
        
    // 如果是 左侧的 tableView 直接return
    if (scrollView == self.leftTableView) return;
    
    // 取出显示在 视图 且最靠上 的 cell 的 indexPath
    NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
    
    // 左侧 talbelView 移动的 indexPath
    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
    
    // 移动 左侧 tableView 到 指定 indexPath 居中显示
    [self.leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    }
}
- (void)setHeaderInfo{
    
    [self.BGImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.mainModel.company_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.mainModel.company_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.shopNameLabel.text = self.mainModel.company_name;
    if (_btn.tag == 101) {
        [_btn setAttributedTitle:[NSString stringWithFirstStr:@"评价  " withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor colorWithHexString:@"#333333"] withSecondtStr:[NSString stringWithFormat:@"(%@)",self.mainModel.star]  withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor colorWithHexString:@"#fe8238"]] forState:UIControlStateNormal];

        [_btn setAttributedTitle:[NSString stringWithFirstStr:@"评价  " withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor colorWithHexString:@"#5dc0ea"] withSecondtStr:[NSString stringWithFormat:@"(%@)",self.mainModel.star]  withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor colorWithHexString:@"#5dc0ea"]] forState:UIControlStateSelected];
    }
    CGFloat realZhengshu;
    CGFloat realXiaoshu;
    NSString*starNmuber=self.mainModel.star;
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>0.5) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>0&&CGxiaoshu<=0.5){
        realXiaoshu=0.5;
    }else{
        realXiaoshu=0;
        
    }
    
    for (int i=40; i<45; i++) {
        UIImageView*imageView=[self.view viewWithTag:i];
        if (imageView.tag-40<realZhengshu) {
            //亮
            imageView.image=[UIImage imageNamed:@"home_lightStar"];
        }else if (imageView.tag-40==realZhengshu&&realXiaoshu!=0){
            //半亮
            imageView.image=[UIImage imageNamed:@"home_halfStar"];
            
        }else{
            //不亮
            imageView.image=[UIImage imageNamed:@"home_grayStar"];
        }
        
        
    }
    self.everyMoneyLabel.text = [NSString stringWithFormat:@"人均:￥%@",self.mainModel.per_capita];
    self.monthMoneyLabel.text = [NSString stringWithFormat:@"月消费人次:%@",self.mainModel.order_nums];
    NSString * dis = [self.mainModel.discount substringFromIndex:2];
    if ([dis integerValue]%10 == 0) {
        dis = [NSString stringWithFormat:@"%ld",[dis integerValue]/10];
    }else{
        dis = [NSString stringWithFormat:@"%.1f",[dis floatValue]/10];
    }
    self.discountLabel.text = [NSString stringWithFormat:@"优惠买单     闪付立享%@折",dis];
    
    self.addressLabel.text = self.mainModel.company_address;
    [self.shopCarView.shopInfoAry removeAllObjects];
    if (!self.shopCarView) {
        
        [self.view addSubview:self.shopCarView];
        self.shopCarView.shopInfoAry = self.shops;
    }else{
        self.shopCarView.shopInfoAry = self.shops;
    }
    self.commentView.shop_id = self.mainModel.id;
    self.commentView.totalScore = self.mainModel.star;
}
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SHOPDETAIL];
    NSDictionary*dict=@{@"shop_id":self.shop_id,@"device_id":[JWTools getUUID]};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserSession instance].isLogin) {
        [params setObject:@([UserSession instance].uid) forKey:@"user_id"];
        [params setObject:[UserSession instance].token forKey:@"token"];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data详情首页 = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode =[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            self.mainModel=[ShopdetailModel yy_modelWithDictionary:data[@"data"]];
            [self setHeaderInfo];
            self.maMDatasGoods=[NSMutableArray array];
            self.maMCommit=[NSMutableArray array];
            self.maMRecommend=[NSMutableArray array];
            //所有商品的model

            [self.shops removeAllObjects];
            for (NSDictionary*dict in self.mainModel.goods) {
//                self.shopModel= [ShowShoppingModel modelWithDic:dict];
                self.shopModel = [ShowShoppingModel yy_modelWithDictionary:dict];
                [self.maMDatasGoods addObject:self.shopModel];
                
            }
           

            [self.leftTableView reloadData];
            [self.rightTableView reloadData];
            NSIndexPath*indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
    }];
    
    
}

- (BOOL)judgeLogin{
    if (![UserSession instance].isLogin) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    return [UserSession instance].isLogin;
}
//返回
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//结算
- (IBAction)accountAction:(UIButton *)sender {
    if ([self judgeLogin]) {
//        NSString * money = [self.totalMoneyLabel.text substringFromIndex:1];
//        if (money == nil ||[money floatValue] == 0.00) {
//            [JRToast showWithText:@"请选择商品" duration:1];
//            return;
//        }
//        CGFloat zhekou=[self.mainModel.discount floatValue];
//
//        YWPayViewController * vc = [YWPayViewController payViewControllerCreatWithQRCodePayAndShopName:self.mainModel.company_name andShopID:self.mainModel.id andZhekou:zhekou andpayAllMoney:[money floatValue] andNOZheMoney:0];
        YWNewDiscountPayViewController * vc =[[YWNewDiscountPayViewController alloc]init];
        if (self.shops.count==0) {
            
            vc.status = 1;
        }else{
            vc.status = 2;
        }
        vc.shopID = self.mainModel.id;
        vc.shopName = self.mainModel.company_name;
        vc.shopDiscount = self.mainModel.discount;
        NSString * money = [self. totalMoneyLabel.text substringFromIndex:1];
        vc.money = money;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


//优惠买单,付款
- (IBAction)payAction:(UIButton *)sender {
    if ([self judgeLogin]) {
//        CGFloat zhekou=[self.mainModel.discount floatValue];
        
//        YWPayViewController*vc=[YWPayViewController payViewControllerCreatWithWritePayAndShopName:self.mainModel.company_name andShopID:self.mainModel.id andZhekou:zhekou];
        YWNewDiscountPayViewController * vc = [[YWNewDiscountPayViewController alloc]init];
        if (self.shops.count==0) {
            
            vc.status = 1;
        }else{
            vc.status = 2;
        }
        vc.shopID = self.mainModel.id;
        vc.shopName = self.mainModel.company_name;
        vc.shopDiscount = self.mainModel.discount;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}
//抢优惠券
- (IBAction)qiangAction:(UIButton *)sender {
    if ([self judgeLogin]) {
        
        NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GET_CONPON];
        NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"shop_id":self.shop_id};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            NSNumber*number=data[@"errorCode"];
            NSString*errorCode =[NSString stringWithFormat:@"%@",number];
            if ([errorCode isEqualToString:@"0"]) {
                [JRToast showWithText:data[@"data"]];
                
            }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }
            
            
        }];
        
        
        
    }

}

//跳地图
- (void)toMapView{
    MapNavNewViewController * mapNaviVC = [[MapNavNewViewController alloc]init];
    mapNaviVC.coordinatex = self.mainModel.coordinatex;
    mapNaviVC.coordinatey = self.mainModel.coordinatey;
    mapNaviVC.shopName = self.mainModel.company_name;
    [self.navigationController pushViewController:mapNaviVC animated:YES];

}
//收藏
- (IBAction)collectAcion:(UIButton *)sender {
    if ([self judgeLogin] && self.mainModel.id !=nil) {
        
        NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ADDCOLLECTION];
        NSLog(@"self.mainModel.id%@",self.mainModel.id);
        
        NSDictionary*params=@{@"shop_id":self.mainModel.id,@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
            //        MyLog(@"%@",data);
            NSNumber*number=data[@"errorCode"];
            NSString*errorCode =[NSString stringWithFormat:@"%@",number];
            if ([errorCode isEqualToString:@"0"]) {
                [JRToast showWithText:data[@"msg"]];
                
                self.mainModel.is_collection=1;

            }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }
            
        }];
        
    }

}
//预约
- (IBAction)precontractAction:(UIButton *)sender {
    if ([self judgeLogin]) {
        UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([self.mainModel.company_first_tel  isEqual: @""]) {
            if (self.mainModel.company_second_tel == nil) {
                
                UIAlertAction * alertACNO =[UIAlertAction actionWithTitle:@"商家未预留电话哦,您可以进行预约！" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:alertACNO];
            }else{
                
                UIAlertAction * alertAC2 =[UIAlertAction actionWithTitle:self.mainModel.company_second_tel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString*str=[NSString stringWithFormat:@"tel:%@",self.mainModel.company_second_tel];
                    UIWebView*callWebView=[[UIWebView alloc]init];
                    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebView];
                    
                    [alertVC addAction:alertAC2];
                }];
            }
            
        }else{
            UIAlertAction*alertAC=[UIAlertAction actionWithTitle:self.mainModel.company_first_tel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.mainModel.company_first_tel];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
                
            }];
            [alertVC addAction:alertAC];
        }
        
        
#pragma 咨询
        UIAlertAction*consult=[UIAlertAction actionWithTitle:@"预约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ScheduleViewController*vc=[[ScheduleViewController alloc]init];
            vc.shopid=self.shop_id;
            [self.navigationController pushViewController:vc animated:NO];
        }];
        
        
        UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        
        [alertVC addAction:consult];
        [alertVC addAction:cancel];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }

}
//购物车
- (IBAction)shopCarAction:(UIButton *)sender {
    ShopCarDeViewController * carVC = [[ShopCarDeViewController alloc]init];
    carVC.shop_id = self.shop_id;
    [self.navigationController pushViewController:carVC animated:YES];
}
- (void)clearShopCar:(NSString *)shop_id{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_CLEARSHOPCARLIST];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"shop_id":shop_id};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"清空购物车%@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {

        }else{
  
        }
    }];
}


//更多-相册
- (IBAction)seeMoreAction:(UIButton *)sender {
    StorePhotoViewController*vc=[[StorePhotoViewController alloc]init];
    vc.shop_id=self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];

}
//加
- (void)addShopAction:(UIButton *)sender {
//    MyLog(@"tag = %ld",sender.tag);
    CategoryLeftTableViewCell * cell = (CategoryLeftTableViewCell *)[[sender superview] superview];
//    NSIndexPath * path = [self.rightTableView indexPathForCell:cell];
//    markPath = path;
//    NSLog(@"index row%@", cell.priceLabel.text);
    NSString * price = [cell.priceLabel.text substringFromIndex:1];
    NSString * totalMoney = [self.totalMoneyLabel.text substringFromIndex:1];
    CGFloat newTotalMoney = [totalMoney floatValue] + [price floatValue];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",newTotalMoney];
    cell.numberLabel.text = [NSString stringWithFormat:@"%zi",[cell.numberLabel.text integerValue] + 1];
    self.numberLabel.hidden = NO;
    self.numberLabel.text = [NSString stringWithFormat:@"%zi",[self.numberLabel.text integerValue] + 1];
    if ([cell.numberLabel.text integerValue] > 0) {
        for (UIButton * reduce in cell.contentView.subviews) {
            reduce.hidden = NO;
            reduce.enabled = YES;
        }
    }

    NSDictionary * dic;
    
    if ([self isAddShop:cell.shop_nameLabel.text]) {
        __block typeof(cell)weakCell = cell;
        __block typeof(dic) weakDic = dic;
        WEAKSELF;
        [self.shops enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * name = obj[@"goods_name"];
            if ([name isEqualToString:cell.shop_nameLabel.text]) {
                *stop = YES;
                weakDic = @{@"goods_name":weakCell.shop_nameLabel.text,@"goods_price":weakCell.priceLabel.text,@"number":weakCell.numberLabel.text};
                [weakSelf.shops replaceObjectAtIndex:idx withObject:weakDic];
            }
        }];
    }else{
       dic = @{@"goods_name":cell.shop_nameLabel.text,@"goods_price":cell.priceLabel.text,@"number":cell.numberLabel.text};
        [self.markCells addObject:cell];
        [self.shops addObject:dic];
    }
    [self addShopToCar:cell.goods_id];
}
//YES就已经存在，no不存在
- (BOOL)isAddShop:(NSString *)shopName{
    for (NSDictionary * dict in self.shops) {
        NSString * name = dict[@"goods_name"];
        if ([name isEqualToString:shopName]) {
            return YES;
        }
    }
    return NO;
}
//减
- (void)reduceShopAction:(UIButton *)sender {
//     MyLog(@"tag = %ld",sender.tag);
    CategoryLeftTableViewCell * cell = (CategoryLeftTableViewCell *)[[sender superview] superview];
    //    NSIndexPath * path = [self.rightTableView indexPathForCell:cell];
    //    NSLog(@"index row%@", cell.priceLabel.text);
    NSString * price = [cell.priceLabel.text substringFromIndex:1];
    NSString * totalMoney = [self.totalMoneyLabel.text substringFromIndex:1];
    CGFloat newTotalMoney = [totalMoney floatValue] - [price floatValue];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",newTotalMoney];
    cell.numberLabel.text = [NSString stringWithFormat:@"%zi",[cell.numberLabel.text integerValue] - 1];
        self.numberLabel.text = [NSString stringWithFormat:@"%zi",[self.numberLabel.text integerValue] - 1];
    if ([cell.numberLabel.text integerValue] == 0 ) {
        sender.hidden = YES;
    }
    if ([self.numberLabel.text integerValue] == 0 ) {
        self.numberLabel.hidden = YES;
    }
    NSDictionary * dic;
    
    if ([self isAddShop:cell.shop_nameLabel.text]) {
        int a = 0;
        for (NSDictionary * dict in self.shops) {
            NSString * name = dict[@"goods_name"];
            NSString * number = dict[@"number"];
            if ([name isEqualToString:cell.shop_nameLabel.text]) {
                if ([number integerValue] == 1) {
                    [self.shops removeObjectAtIndex:a];
                }else{
                    dic = @{@"goods_name":cell.shop_nameLabel.text,@"goods_price":cell.priceLabel.text,@"number":cell.numberLabel.text};
                    [self.shops replaceObjectAtIndex:a withObject:dic];
                }
            }
            a ++;
            
        }
        
    }
    [self reduceShopToCar:cell.goods_id];

}
//点击加号，把商品传到服务器
- (void)addShopToCar:(NSString *)goodsID{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SHOPCAR];
    NSDictionary*dict=@{@"shop_id":self.shop_id,@"device_id":[JWTools getUUID],@"goods_id":goodsID};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserSession instance].isLogin) {
        [params setObject:@([UserSession instance].uid) forKey:@"user_id"];
        [params setObject:[UserSession instance].token forKey:@"token"];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"购物车 %@",data);
    }];
}
//点减加号，把商品传到服务器
- (void)reduceShopToCar:(NSString *)goodsID{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_REDUCESHOPCAR];
    NSDictionary*dict=@{@"shop_id":self.shop_id,@"device_id":[JWTools getUUID],@"goods_id":goodsID};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserSession instance].isLogin) {
        [params setObject:@([UserSession instance].uid) forKey:@"user_id"];
        [params setObject:[UserSession instance].token forKey:@"token"];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"购物车 %@",data);
    }];
}
//所选的商品
- (IBAction)myShopAction:(UIButton *)sender {
    if (self.shops.count<=0) {
        return;
    }
    BOOL viewRemove = self.isRemove = !self.isRemove;
    if (viewRemove == NO) {
        [self.shopCarView removeFromSuperview];
        [self.touchView removeFromSuperview];
    }else{
        [self creatShopView];
        self.shopCarView.shopInfoAry = self.shops;
    }
    
}
- (void)creatShopView{
    _shopCarView = [[YWShopCarView alloc]initWithFrame:CGRectMake(0, kScreen_Height * 0.3, kScreen_Width, kScreen_Height * 0.7f - 60)];
    _shopCarView.delegate = self;
    [self.view addSubview:_shopCarView];
    self.touchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height * 0.3f)];
    self.touchView.backgroundColor = [UIColor grayColor];
    self.touchView.alpha = 0.7;
    [self.view addSubview:_touchView];
    
    UITapGestureRecognizer * touchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    touchTap.numberOfTapsRequired = 1;
    touchTap.numberOfTouchesRequired = 1;
    touchTap.delegate = self;
    [self.touchView addGestureRecognizer:touchTap];
}
- (void)removeView{
    self.isRemove = !self.isRemove;
    [self.shopCarView removeFromSuperview];
    [self.touchView removeFromSuperview];
    
    
}
-(void)clearNumberOfShop{
    for (CategoryLeftTableViewCell * cell in self.markCells) {
            cell.numberLabel.text = @"0";
            UIButton * btn = [cell viewWithTag:10];
            btn.hidden = YES;

    }
    self.totalMoneyLabel.text = @"0.00";
   self.numberLabel.text = @"0";
}
//所有的评论
- (void)allCommitAction{
    ShowMoreCommitViewController*vc=[[ShowMoreCommitViewController alloc]init];
    vc.shop_id=self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray*)shops{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (NSMutableArray*)markCells{
    if (!_markCells) {
        _markCells = [NSMutableArray array];
    }
    return _markCells;
}
- (YWShopCommitView*)commentView{
    if (!_commentView) {
        _commentView = [[YWShopCommitView alloc]initWithFrame:CGRectMake(0, self.bottomBGView.height-32, kScreen_Width,kScreen_Height - self.bottomBGView.height+32)];
        _commentView.hidden = YES;
        _commentView.shop_id = self.shop_id;
    }
    return _commentView;
}
//代理  清空商品
-(void)clearShop{
    [self.shops removeAllObjects];
    self.isRemove = !self.isRemove;
    [self.shopCarView removeFromSuperview];
    [self.touchView removeFromSuperview];
    [self clearNumberOfShop];
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
