//
//  OrderDetailViewController.m
//  YuWa
//
//  Created by double on 17/3/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrdelShopCellView.h"
#import "OrderModel.h"
#import "NSString+JWAppendOtherStr.h"
#import "ShopNameView.h"
#import "OrderRefundViewController.h"
#import "ShopDetailViewController.h"
@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * orderTableView;
@property (nonatomic,strong)NSMutableArray * orderAry;
@property (nonatomic,strong)NSString * shop_id;
//@property (nonatomic,strong)OrderModel * model;

@end

@implementation OrderDetailViewController
- (NSMutableArray *)orderAry{
    if (!_orderAry) {
        _orderAry = [NSMutableArray array];
    }
    return _orderAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.title = @"订单详情";
    [self setUpMJRefresh];
    self.view.backgroundColor = RGBCOLOR(241, 238, 245, 1);
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDatas];
}
- (void)makeUI{
    self.orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width, kScreen_Height * 0.8f) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_orderTableView];
    
    UIButton * refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refundBtn.frame = CGRectMake(16, kScreen_Height * 0.85f, kScreen_Width - 32, kScreen_Height * 0.1f);
    [refundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    [refundBtn setBackgroundColor:CNaviColor];
    refundBtn.layer.cornerRadius = 5;
    refundBtn.layer.masksToBounds = YES;
    refundBtn.hidden = YES;
//    [refundBtn addTarget:self action:@selector(placeRefundAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refundBtn];
    
    
}
-(void)setUpMJRefresh{

    self.orderTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{

        [self getDatas];
        
    }];
    
   
}

//- (void)placeRefundAction{
//    OrderRefundViewController * refundVC = [[OrderRefundViewController alloc]init];
//    [self.navigationController pushViewController:refundVC animated:YES];
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ShopDetailViewController * vc = [[ShopDetailViewController alloc]init];
        vc.shop_id = self.shop_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.orderAry.count > 0) {
        
    OrderModel * model = self.orderAry[0];
    if (indexPath.row == 0) {
        return 80.f;
    }else if(indexPath.row ==1){
        return 44.f * model.buy_shopAry.count;
    }else{
        return 44.f;
    }
    }
    return 44;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row >= 4) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.orderAry.count > 0) {
        
        OrderModel * orderModel = self.orderAry[0];
    
    if (indexPath.row == 0) {
        
        ShopNameView * nameView = [[ShopNameView alloc]initWithFrame:CGRectMake(0, 0, cell.width *0.8f, 80)];
        [nameView.imageView sd_setImageWithURL:[NSURL URLWithString:orderModel.shop_img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        nameView.shopNameLabel.text = orderModel.shop_name;
        [cell.contentView addSubview:nameView];



        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1){
        OrdelShopCellView * shopCellView;
        if (shopCellView) {
            [shopCellView removeFromSuperview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i = 0; i< orderModel.buy_shopAry.count; i++) {
            shopCellView = [[OrdelShopCellView alloc]initWithFrame:CGRectMake(0, 44 *i, cell.width, 44)];
            [cell.contentView addSubview:shopCellView];
        }
    }else if (indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"减"];
        CGFloat itemH =  cell.height * 0.3f;
        CGFloat itemW = 0;
        if (cell.imageView.image.size.width) {
            itemW = cell.imageView.image.size.height / cell.imageView.image.size.width * itemH;
            
            if (itemH >= itemW) {
                itemH = cell.height * 0.35f;
                itemW = cell.imageView.image.size.width * itemH/cell.imageView.image.size.height;
            }
        }
        
        CGSize itemSize = CGSizeMake(itemW,cell.height*0.5f);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat zhekou = [orderModel.discount floatValue]*10;
        if (zhekou >=10 || zhekou<=0.00) {
           cell.textLabel.text = @"不打折";
        }else{
        cell.textLabel.text = [NSString stringWithFormat:@"闪付享受%.1f折 折扣",zhekou];
            CGFloat discountMoney = [orderModel.total_money floatValue] - [orderModel.pay_money floatValue];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"-%.2f",discountMoney];
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            
        }
    }else if (indexPath.row == 3){

        if (orderModel.pay_money == NULL) {
//
            cell.detailTextLabel.text = [NSString stringWithFormat:@"实付款￥%@",orderModel.pay_money];
        }else{
            cell.detailTextLabel.attributedText = [NSString stringWithFirstStr:@"实付款" withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor blackColor] withSecondtStr:[NSString stringWithFormat:@"￥%@",orderModel.pay_money] withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor orangeColor]];
        }

    }else if (indexPath.row == 4){
        cell.textLabel.text = [NSString stringWithFormat:@"订单编号:%@",orderModel.order_id];
        
    }else if (indexPath.row == 5){
        cell.textLabel.text = [NSString stringWithFormat:@"订单状态:%@",orderModel.status];
    }else if (indexPath.row == 6){
        cell.textLabel.text = [NSString stringWithFormat:@"下单时间:%@",[JWTools getTime:orderModel.create_time]];
        UIButton * questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        questionBtn.frame = CGRectMake(kScreen_Width * 0.65f, 5, kScreen_Width * 0.3f, 34);
        [questionBtn setTitle:@"对订单有疑问?" forState:UIControlStateNormal];
        questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [questionBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
        [cell.contentView addSubview:questionBtn];
    
    }
   
    }
    return cell;
}

#pragma mark  --allDatas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYORDERDETAIL];

    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":self.order_id};
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        MyLog(@"responseObject = %@",responseObject);
        NSNumber*number = responseObject[@"errorCode"] ;
        [self.orderAry removeAllObjects];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            NSDictionary*dict = responseObject[@"data"];
            OrderModel*model=[OrderModel orderModelWithDic:dict];
            MyLog(@"status = %@",model.status);
            MyLog(@"dict = %@",dict);
            self.shop_id = model.shop_id;
            [self.orderAry addObject:model];
            
            [self.orderTableView reloadData];
//            MyLog(@"orderAry = %@",_orderAry);
        }else{
            [JRToast showWithText:responseObject[@"errorMessage"]];
        }
        [self.orderTableView.mj_header endRefreshing];
        [self.orderTableView.mj_footer endRefreshing];
    
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       
    }];
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        NSNumber*number=data[@"errorCode"];
//        [self.orderAry removeAllObjects];
//        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
//        if ([errorCode isEqualToString:@"0"]) {
//            NSDictionary*dict = data[@"data"];
////               OrderModel * model = [OrderModel orderModelWithDic:dict];
//            OrderModel * model = [OrderModel yy_modelWithDictionary:dict];
//                [self.orderAry addObject:model];
//            
//            [self.orderTableView reloadData];
//  
//        }else{
//            [JRToast showWithText:data[@"errorMessage"]];
//        }
//       
//    }];
// 
}
- (void)requestRefundData{
    NSString * urlStrr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_REFUNDORDER];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"order_id":self.order_id,@"token":[UserSession instance].token};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStrr withParams:pragrams compliation:^(id data, NSError *error) {
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            
        }
    }];
    
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
