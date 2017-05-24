//
//  ChooseSeatController.m
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChooseSeatController.h"
#import "MBProgressHUD.h"
#import "XZSeatModel.h"
#import "XZSeatsModel.h"
#import "MJExtension.h"
#import "XZSeatsModel.h"
#import "XZSeatSelectionView.h"
#import "XZSeatSelectionTool.h"
#import "XZSeatsView.h"
#import "PayViewController.h"
#import "NSString+JWAppendOtherStr.h"
#import "ChooseSeatModel.h"//座位model


@interface ChooseSeatController ()<UITableViewDelegate,UITableViewDataSource>
{
//    UILabel * selectedSeat;
    XZSeatSelectionView *selectionView;
}
/**按钮数组*/
@property (nonatomic, strong) NSMutableArray *selecetedSeats;//已选的座位

@property (nonatomic,strong) NSMutableDictionary *allAvailableSeats;//所有可选的座位

@property (nonatomic,strong) NSMutableArray *seatsModelArray;
@property (nonatomic,strong) UITableView * seatTableView;
@property (nonatomic,strong) UIView * seatLblBGView;
@property (nonatomic,strong) NSMutableArray * seatModelAry;//座位model数组
@property (nonatomic,strong) NSMutableArray * payInformationArr;
@end

@implementation ChooseSeatController
- (NSMutableArray*)selecetedSeats{
    if (!_selecetedSeats) {
        _selecetedSeats = [NSMutableArray array];
        
    }
    return _selecetedSeats;
}
- (NSMutableArray*)seatModelAry{
    if (!_seatModelAry) {
        _seatModelAry = [NSMutableArray array];
    }
    return _seatModelAry;
}
- (NSMutableArray*)seatsModelArray{
    if (!_seatsModelArray) {
        _seatsModelArray = [NSMutableArray array];
    }
    return _seatsModelArray;
}
- (NSMutableArray*)payInformationArr{
    if (!_payInformationArr) {
        _payInformationArr = [NSMutableArray array];
    }
    return _payInformationArr;
}
- (UILabel * )price_num{
    if (!_price_num) {
        _price_num = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 70, 14)];
        _price_num.textColor = [UIColor lightGrayColor];
        _price_num.font = [UIFont systemFontOfSize:12];

    }
    return _price_num;
}
- (UIButton*)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(0, 0, kScreen_Width/3, 35);
        _sureBtn.center = CGPointMake(kScreen_Width * 0.8f, 22);
        
        _sureBtn.backgroundColor = [UIColor colorWithRed:176/255.0 green:233/255.0 blue:250/255.0 alpha:1];
        [_sureBtn setTitle:@"请先选座" forState:UIControlStateNormal];
        _sureBtn.userInteractionEnabled = NO;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 5;
        [_sureBtn addTarget:self action:@selector(sureSelected) forControlEvents:UIControlEventTouchUpInside];

    }
    return _sureBtn;
}

- (UIButton*)changeMovieBtn{
    if (!_changeMovieBtn) {
        _changeMovieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeMovieBtn.frame = CGRectMake(_languageLabel.right, 10, kScreen_Width*0.25f, 25);
        [_changeMovieBtn.layer setBorderColor:CNaviColor.CGColor];
        [_changeMovieBtn.layer setBorderWidth:1];
        [_changeMovieBtn.layer setMasksToBounds:YES];
        [_changeMovieBtn setTitle:@"更换场次" forState:UIControlStateNormal];
        [_changeMovieBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
        _changeMovieBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _changeMovieBtn.layer.masksToBounds = YES;
        _changeMovieBtn.layer.cornerRadius = 5;
        [_changeMovieBtn addTarget:self action:@selector(changeMovieAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _changeMovieBtn;
}
-(UILabel *)allPrice{
    if (!_allPrice) {
        _allPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width/2, 30)];
        _allPrice.textColor = CNaviColor;
    }
    return _allPrice;
}
- (UILabel *)languageLabel{
    if (!_languageLabel) {
        _languageLabel = [[UILabel alloc]init];
        _languageLabel.font = [UIFont systemFontOfSize:12];
        _languageLabel.textColor = RGBCOLOR(167, 168, 169, 1);
        
    }
    return _languageLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选座";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self requestSeatinformation];

 
    // Do any additional setup after loading the view.
}

- (void)makeUI{
    
    _seatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
    _seatTableView.delegate = self;
    _seatTableView.dataSource = self;
    _seatTableView.scrollEnabled = NO;
    [self.view addSubview:_seatTableView];
    [self.sureBtn setEnabled:NO];
    
}
//更换场次
- (void)changeMovieAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44.f;
    }else if (indexPath.row == 1){
        return 30;
    }else if (indexPath.row == 2){
        return kScreen_Height * 0.6f;
    }else{
        return 44.f;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"seatCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"seatCell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"极限特工";
        CGRect strWidth = [cell.textLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: cell.textLabel.font} context:nil];
        
        self.languageLabel.frame = CGRectMake(cell.textLabel.right+25 +strWidth.size.width, cell.textLabel.top +3, kScreen_Width * 0.4, 25);
        _languageLabel.text = @"国语/2D/7号厅";
        [cell.contentView addSubview:self.languageLabel];
        cell.detailTextLabel.text = @"今日XXXXX";

        [cell.contentView addSubview:self.changeMovieBtn];
        [self.payInformationArr addObject:cell.textLabel.text];
        [self.payInformationArr addObject:cell.detailTextLabel.text];
        [self.payInformationArr addObject:self.title];
    }else if (indexPath.row == 1){
        cell.backgroundColor = [UIColor lightGrayColor];
        NSArray * seatAry = @[@"kexuan.imageset.png",@"yishou.imageset.png",@"xuanzhong.imageset.png"];
        NSArray * textAry = @[@"可选",@"不可选",@"已选"];
        CGFloat imageViewWidth = 15;
        CGFloat textWidth = 40;
        CGFloat jianju = (kScreen_Width - 165 -100)/2;
        for (int i = 0; i< 3; i++) {
            UIImageView * seatsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60 + (imageViewWidth +jianju+textWidth)*i, cell.height*0.1f, imageViewWidth, cell.height * 0.5f)];
            seatsImageView.image = [UIImage imageNamed:seatAry[i]];
            
            [cell.contentView addSubview:seatsImageView];
            UILabel * textlbl = [[UILabel alloc]initWithFrame:CGRectMake(80 + (imageViewWidth +jianju+textWidth)*i, cell.height*0.1f, textWidth, cell.height * 0.5f)];
            textlbl.text = textAry[i];
            textlbl.textColor = [UIColor lightGrayColor];
            textlbl.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:textlbl];
    
        }
    }else if (indexPath.row == 2){
        [cell.contentView addSubview:selectionView];
    }else if (indexPath.row == 3){
        
        static int i = 0;
        if (i == 0) {
            UILabel * select = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 50, 20)];
            
            select.font = [UIFont systemFontOfSize:12];
            select.textColor = [UIColor blackColor];
            select.text = @"已选座位";
            select.tag = 111;
            [cell.contentView addSubview:select];
            _seatLblBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, kScreen_Width, 20)];
            //            _seatLblBGView.backgroundColor = [UIColor greenColor];
            [cell.contentView addSubview:_seatLblBGView];
        }
        
//            [cell.contentView addSubview:selectedSeat];

        }else{
            for (UILabel * label in cell.contentView.subviews) {
                if (label.tag == 111) {
                    [label removeFromSuperview];
                }
            }
            
            [cell.contentView addSubview:self.allPrice];
            
            _allPrice.text = [NSString stringWithFormat:@"一次最多选择4个座位"];
            _allPrice.font = [UIFont systemFontOfSize:15];
            _price_num.hidden = YES;

            
            [cell.contentView addSubview:self.price_num];

            [cell.contentView addSubview:self.sureBtn];


    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)requestSeatinformation{
//    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
//    
//    HUD.tintColor = [UIColor blackColor];
//    [self.view addSubview:HUD];
    WEAKSELF;
//    [HUD show:YES];
    //修改
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.channelShowCode = @"171000099327";
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CHOOSESEATS];
        NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"channelShowCode":self.channelshowcode,@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token};
        HttpManager * manager = [[HttpManager alloc]init];
        [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
                // NSData转为NSString
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            MyLog(@"选座%@",jsonStr);
            if ([data[@"errorCode"] integerValue] == 0) {
                [self.seatModelAry removeAllObjects];
           self.seatsModelArray =      [ChooseSeatModel ChooseSeatModelWithDic:data[@"data"]];
                 [weakSelf initSelectionView:self.seatsModelArray];
            }else{
                [JRToast showWithText:@"网络出现异常，请检查网络" duration:1];
            }
        }];

        
        
    
    });
}
//创建选座模块
-(void)initSelectionView:(NSMutableArray *)seatsModelArray{
    __weak typeof(self) weakSelf = self;
    NSMutableArray * seatNumAry = [NSMutableArray array];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPathT=[NSIndexPath indexPathForRow:3 inSection:0];
    selectionView = [[XZSeatSelectionView alloc]initWithFrame:CGRectMake(0, 0,kScreen_Width, kScreen_Height * 0.6f) SeatsArray:seatsModelArray HallName:self.hall_name seatBtnActionBlock:^(NSMutableArray *selecetedSeats, NSMutableDictionary *allAvailableSeats, NSMutableArray *cancelAry, NSString *errorStr) {
//        NSLog(@"=====%zd个选中按钮===========%zd个可选座位==========errorStr====%@=========",selecetedSeats.count,allAvailableSeats.count,errorStr);
        UILabel * selectedSeat;
        [seatNumAry removeAllObjects];

        if (errorStr) {
            //错误信息
            [self showMessage:errorStr];
            
        }else{
            //储存选好的座位及全部可选座位
            weakSelf.allAvailableSeats = allAvailableSeats;
            weakSelf.selecetedSeats = selecetedSeats;
            if (selecetedSeats.count == 0) {
                [self.sureBtn setEnabled:NO];
                _sureBtn.backgroundColor = [UIColor colorWithRed:176/255.0 green:233/255.0 blue:250/255.0 alpha:1];
                [_sureBtn setTitle:@"请先选座" forState:UIControlStateNormal];
                _sureBtn.userInteractionEnabled = NO;
                for (UIView * lblView in _seatLblBGView.subviews) {
                    [lblView removeFromSuperview];
                }
                _price_num.text = [NSString stringWithFormat:@"￥39X%ld",(unsigned long)self.selecetedSeats.count];
      
                _allPrice.text = [NSString stringWithFormat:@"一次最多选择4个座位"];
                 _allPrice.font = [UIFont systemFontOfSize:15];
                _price_num.hidden = YES;
            }else{
                _sureBtn.userInteractionEnabled = YES;
                [_sureBtn setEnabled: YES];
                _sureBtn.backgroundColor = CNaviColor;
                [_sureBtn setTitle:@"去结算" forState:UIControlStateNormal];
                _price_num.hidden = NO;
                _price_num.text = [NSString stringWithFormat:@"￥39X%ld",self.selecetedSeats.count];
                CGFloat p = self.selecetedSeats.count * 39;
                _allPrice.font = [UIFont systemFontOfSize:17];
                
                NSAttributedString * attributedText = [NSString stringWithFirstStr:@"待结算" withFont:[UIFont systemFontOfSize:12] withColor:CNaviColor withSecondtStr:[NSString stringWithFormat:@"￥%.2f",p] withFont:[UIFont systemFontOfSize:15] withColor:CNaviColor];
                _allPrice.attributedText = attributedText;
                
                CGFloat LblWidth = (kScreen_Width -20 -6)/4;
                
                XZSeatsModel * smodel;
                XZSeatModel * model;
                NSString * seatStr ;
                for (XZSeatButton * btn in weakSelf.selecetedSeats) {
                    smodel = btn.seatsmodel;
                    model = btn.seatmodel;
                    
                    NSString * str = [NSString stringWithFormat:@"%@排%@座",smodel.rowId,model.columnId];
                    [seatNumAry addObject:str];
                    seatStr = str;
                    
                }
 
                for (UIView * lblView in _seatLblBGView.subviews) {
                    [lblView removeFromSuperview];
                }
//                if (_seatLblBGView.subviews.count == 0) {
//                    
//                }


                for (int i = 0; i<seatNumAry.count; i++) {
                    selectedSeat = [[UILabel alloc]initWithFrame:CGRectMake(10 +(LblWidth +2)*i, 0, LblWidth, 20)];
                    selectedSeat.font = [UIFont systemFontOfSize:12];
                    selectedSeat.textColor = [UIColor darkGrayColor];
                    selectedSeat.tag = i + 1;
                    [_seatLblBGView addSubview:selectedSeat];
                    selectedSeat.text = seatNumAry[i];

                }

            }
           
        }

    }];
    [_seatTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexPathT,nil] withRowAnimation:UITableViewRowAnimationFade];
//    [self.payInformationArr addObject:@"厅号"];
//    if (seatNumAry.count != 0) {
//        
//        [self.payInformationArr addObjectsFromArray:seatNumAry];
//    }
//    [self.payInformationArr addObject:_allPrice.text];
}
- (void)sureSelected{
    NSLog(@"确认选座");
    if (!self.selecetedSeats.count) {
        [self showMessage:@"您还未选座"];
        return;
    }
    //验证是否落单
    if (![XZSeatSelectionTool verifySelectedSeatsWithSeatsDic:self.allAvailableSeats seatsArray:self.seatsModelArray]) {
        [self showMessage:@"落单"];
        
    }else{
        XZSeatsModel * smodel;
        XZSeatModel * model;
        
        [self.payInformationArr addObject:@"厅号"];
        for (XZSeatButton * btn in self.selecetedSeats) {
            smodel = btn.seatsmodel;
            model = btn.seatmodel;
            
            NSString * str = [NSString stringWithFormat:@"%@排%@座",smodel.rowId,model.columnId];
            [self.payInformationArr addObject:str];
        }
        [self.payInformationArr addObject:_allPrice.text];
        [self showMessage:@"正在为您预定座位"];
    }

}
-(void)showMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    if ([message isEqualToString:@"落单"]) {
        [JRToast showWithText:message duration:1];
        return;
    }
    [self presentViewController:controller animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
       [self dismissViewControllerAnimated:controller completion:^{
           PayViewController * payVC = [[PayViewController alloc]initWithDataArray:self.payInformationArr];
           [self.navigationController pushViewController:payVC animated:YES];
       }];
    });
}

//计算自动宽度
- (CGRect)getStrWidth:(NSString *)str  andHeight:(CGFloat)height andStrFont:(CGFloat)font{
     CGRect strWidth = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return strWidth;
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
