//
//  CinemaDetaliController.m
//  YuWa
//
//  Created by double on 17/2/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinemaDetaliController.h"
#import "MovieShopTableViewCell.h"
#import "CinemaCharacteristicTableViewCell.h"
#import "InfomationTableViewCell.h"
#import "CommentTableViewCell.h"

#define COMMENTCELL00  @"CommentTableViewCell"
#define INFOCELL23  @"InfomationTableViewCell"
#define CharacteristicCell  @"CinemaCharacteristicTableViewCell"
#define MOVIECELL12 @"MovieShopTableViewCell"
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
    [self makeUI];
    // Do any additional setup after loading the view.
}
- (void)makeUI
{
    _cinemaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    _cinemaTableView.delegate = self;
    _cinemaTableView.dataSource = self;
    
    [_cinemaTableView registerNib:[UINib nibWithNibName:MOVIECELL12 bundle:nil] forCellReuseIdentifier:MOVIECELL12];
    [_cinemaTableView registerNib:[UINib nibWithNibName:CharacteristicCell bundle:nil] forCellReuseIdentifier:CharacteristicCell];
    [_cinemaTableView registerNib:[UINib nibWithNibName:INFOCELL23 bundle:nil] forCellReuseIdentifier:INFOCELL23];
    [_cinemaTableView registerNib:[UINib nibWithNibName:COMMENTCELL00 bundle:nil] forCellReuseIdentifier:COMMENTCELL00];
    [self.view addSubview:_cinemaTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 6;//修改
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 165.f;
    }else if (indexPath.section == 1){

        if (indexPath.row == 0) {
            return 25.f;
        }else if (indexPath.row == 1){
            return 80.f;
        }else {
            return 50.f;
        }
       
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 25.f;
        }else {
            return 50.f;
        }
    }
    return 50.f;
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
        MovieShopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MOVIECELL12];
        
        return cell;
        
        
    }else if(indexPath.section ==1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"影院特色";
            cell.textLabel.textColor = RGBCOLOR(123, 124, 125, 1);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }else if(indexPath.row == 1) {
            CinemaCharacteristicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CharacteristicCell];
            //添加判断有多少图片，多余的隐藏，tag从100开始
            return cell;
        }else {
            InfomationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:INFOCELL23];
            return cell;
        }
        }else{
            if (indexPath.row == 0) {
                cell.textLabel.text = @"网友点评";
                cell.textLabel.textColor = RGBCOLOR(123, 124, 125, 1);
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }else{
            CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELL00];
            for (UIView * view in cell.contentView.subviews) {
                //            MyLog(@"%ld",(long)view.tag);
                if ((2100>=view.tag&&view.tag >= 2000)||(1100>=view.tag&&view.tag >= 1000)) {
                    [view removeFromSuperview];
                }
            }
            cell.selectionStyle=NO;

            return cell;
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
