//
//  MovieDetailViewController.m
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "ChooseMovieHeaderView.h"
#import "CommentTableViewCell.h"
#import "CinemaCharacteristicTableViewCell.h"
#import "MovieDetailHeaderView.h"
#import "CommentModel.h"

#import "CommendViewController.h"

#define COMMENTCELl111 @"CommentTableViewCell"
#define CinemaCell123 @"CinemaCharacteristicTableViewCell"
@interface MovieDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MovieDetailHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic,strong) MovieDetailHeaderView * headerView;
@property (nonatomic,strong) CommentModel * model;
@property (nonatomic,strong) NSMutableArray * commentAry;
@property (nonatomic,strong)UILabel * textLabel;
@property (nonatomic,strong) UIButton * commentBtn;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self makeUI];
    [self creatLabel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)makeUI{
    self.title = @"影片详情";
    [self.detailTableView registerNib:[UINib nibWithNibName:CinemaCell123 bundle:nil] forCellReuseIdentifier:CinemaCell123];
    
    [self.detailTableView registerNib:[UINib nibWithNibName:COMMENTCELl111 bundle:nil] forCellReuseIdentifier:COMMENTCELl111];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        if (self.commentAry.count<=0) {
            self.textLabel.hidden = NO;
            self.commentBtn.hidden = NO;
        }else{
            self.textLabel.hidden = YES;
            self.commentBtn.hidden = YES;
        }
        return self.commentAry.count;
    }
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"网友点评";
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 25.f;
    }
    return [MovieDetailHeaderView getHeaderHeight:self.cinemaDetailModel.intro];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [CommentTableViewCell getCellHeight:self.commentAry[indexPath.row]];
    }
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        self.headerView.model = self.cinemaDetailModel;
        return self.headerView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CinemaCharacteristicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CinemaCell123];
        
        NSArray * imageAry = [self.cinemaDetailModel.stills componentsSeparatedByString:@","];
        cell.imageAry = imageAry;
        return cell;
    }else{
        CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELl111];
        [cell giveValueWithModel:self.model];
        return cell;
    }
    
}

#pragma mark ---http
- (void)requestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_MOVIEDETAIL];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"filmNo":self.filmCode,@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"影片详情%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            //头部影片数据
            [self.commentAry removeAllObjects];
                self.cinemaDetailModel = [CinemaAndBuyTicketModel yy_modelWithDictionary:data[@"data"][@"filmDetail"]];
            
            //评论部分数据
            for (NSDictionary * commentDict in data[@"data"][@"filmComment"]) {
                self.model = [CommentModel yy_modelWithDictionary:commentDict];
                [self.commentAry addObject:self.model];
            }
            
            [self.detailTableView reloadData];
        }
    }];
}
- (void)creatLabel{
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreen_Height * 0.85, kScreen_Width/3, 35)];
    _textLabel.centerX = kScreen_Width/2;
    _textLabel.textAlignment = 1;
    _textLabel.textColor = RGBCOLOR(124, 125, 123, 1);
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.text = @"暂无评论";
    [self.view addSubview:_textLabel];
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(0, kScreen_Height * 0.85, kScreen_Width/3, 28);
    _commentBtn.centerX = kScreen_Width/2;
    _commentBtn.centerY = _textLabel.centerY + 30;
    [_commentBtn setTitle:@"我来评论" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
    
    _commentBtn.layer.borderColor = CNaviColor.CGColor;
    _commentBtn.layer.borderWidth = 1;
    _commentBtn.layer.masksToBounds = YES;
    _commentBtn.layer.cornerRadius = 5;
    [_commentBtn addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentBtn];
    _commentBtn.hidden = YES;
    _textLabel.hidden = YES;
}
- (void)toComment{
    CommendViewController * commendVC = [[CommendViewController alloc]init];
    commendVC.film_code = self.filmCode;
    commendVC.headerModel = self.cinemaDetailModel;
    [self.navigationController pushViewController:commendVC animated:YES];
}
- (MovieDetailHeaderView*)headerView{
    if (!_headerView) {
        CGFloat height = [MovieDetailHeaderView getHeaderHeight:self.cinemaDetailModel.intro];
        _headerView = [[MovieDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
        _headerView.delegate =self;
    }
    return _headerView;
}

- (NSMutableArray *)commentAry{
    if (!_commentAry) {
        _commentAry = [NSMutableArray array];
    }
    return _commentAry;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toCommentScore{
    CommendViewController * commendVC = [[CommendViewController alloc]init];
    commendVC.headerModel = self.cinemaDetailModel;
//    commendVC.order_id = //在我的订单中评价才需要
    [self.navigationController pushViewController:commendVC animated:YES];
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
