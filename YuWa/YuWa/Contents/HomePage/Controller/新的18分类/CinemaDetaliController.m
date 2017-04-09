//
//  CinemaDetaliController.m
//  YuWa
//
//  Created by double on 17/2/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinemaDetaliController.h"

@interface CinemaDetaliController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * cinemaTableView;
@property (nonatomic,strong)NSMutableArray * cellDataArr;
@property (nonatomic,strong)NSMutableArray * cellImageArr;
@end

@implementation CinemaDetaliController
- (NSMutableArray*)cellDataArr{
    if (!_cellDataArr) {
        _cellDataArr = [NSMutableArray array];
    }
    return _cellDataArr;
}
- (NSMutableArray*)cellImageArr{
    if (!_cellImageArr) {
        _cellImageArr = [NSMutableArray array];
    }
    return _cellImageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影院详情";
    NSArray * title = @[@"未取票用户放映前60分钟可退",@"未取票用户放映前60分钟可改签",@"限网上选座后取票",@"免押金",@"每位观影用户可免费带领1名身高1.3米（含）一下儿童同场观影，该儿童观影与大人同坐，不予单独出票"];
    NSArray * image = @[@"退",@"改签",@"取票机",@"3D眼镜",@"儿童优惠"];
    [self.cellImageArr addObjectsFromArray:image];
    [self.cellDataArr addObjectsFromArray:title];
    [self makeUI];
    // Do any additional setup after loading the view.
}
- (void)makeUI
{
    _cinemaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    _cinemaTableView.delegate = self;
    _cinemaTableView.dataSource = self;
    
    [self.view addSubview:_cinemaTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 6;//修改
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 5) {
        return 65.f;
    }else if (indexPath.section == 0){
        if (indexPath.row == 0) {
            return 55.f;
        }else{
            return 30.f;
        }
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cinemaCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cinemaCell"];
    }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.textLabel.text = @"横店电影城";
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = @"4.0分";
        cell.detailTextLabel.textColor = [UIColor orangeColor];
       
        }else{
            cell.imageView.image = [UIImage imageNamed:@"home_locate@2x.png"];
            cell.textLabel.text = @"地址";
        
            UIButton * iphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            iphoneBtn.frame = CGRectMake(cell.width*0.8f, 5, cell.width*0.2f, cell.height/2);
            iphoneBtn.backgroundColor = [UIColor clearColor];
            [iphoneBtn setImage:[UIImage imageNamed:@"dianhua.png"] forState:UIControlStateNormal];
            [iphoneBtn addTarget:self action:@selector(iphoneNum) forControlEvents:UIControlEventTouchUpInside];
            iphoneBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:iphoneBtn];

            
            CGFloat itemH =  cell.height * 0.3f;
            CGFloat itemW = 0;
            if (cell.imageView.image.size.width) {
                itemW = cell.imageView.image.size.height / cell.imageView.image.size.width * itemH;
                
                if (itemH >= itemW) {
                    itemH = cell.height * 0.3f;
                    itemW = cell.imageView.image.size.width * itemH/cell.imageView.image.size.height;
                }
            }
            
            CGSize itemSize = CGSizeMake(itemW,cell.height*0.5f);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"特色信息";
            cell.textLabel.textColor = [UIColor blackColor];
        }else{
            cell.imageView.image = [UIImage imageNamed:_cellImageArr[indexPath.row - 1]];
  
            cell.textLabel.text = _cellDataArr[indexPath.row-1];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            CGFloat itemH =  cell.height * 0.3f;
            CGFloat itemW = 0;
            if (cell.imageView.image.size.width) {
                itemW = cell.imageView.image.size.height / cell.imageView.image.size.width * itemH;
                
                if (itemH >= itemW) {
                    itemH = cell.height * 0.3f;
                    itemW = cell.imageView.image.size.width * itemH/cell.imageView.image.size.height;
                }
            }
            
            CGSize itemSize = CGSizeMake(itemW,cell.height*0.5f);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (indexPath.row == 1||indexPath.row == 2 || indexPath.row == 3) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    return cell;
}
- (void)iphoneNum{
    MyLog(@"拨打电话");
    NSString *allString = [NSString stringWithFormat:@"tel:17759725085"];
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
