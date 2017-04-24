//
//  YWShopCommitView.m
//  YuWa
//
//  Created by double on 17/4/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopCommitView.h"
#import "YWShopScoreTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#define COMMENTCELl @"CommentTableViewCell"
#define SCORECELL  @"YWShopScoreTableViewCell"
@interface YWShopCommitView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)HUDFailureShowView*failView;

@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*maMallDatas;
@end
@implementation YWShopCommitView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shopCommitTableView];
        [self setUpMJRefresh];
    }
    return self;
}
-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.shopCommitTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getDatas];
        
    }];
    
    //上拉刷新
    self.shopCommitTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
    }];
    
    //立即刷新
    [self.shopCommitTableView.mj_header beginRefreshing];
    
    
    
}

- (UITableView*)shopCommitTableView{
    if (!_shopCommitTableView) {
        _shopCommitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _shopCommitTableView.delegate = self;
        _shopCommitTableView.dataSource = self;
        [_shopCommitTableView registerNib:[UINib nibWithNibName:SCORECELL bundle:nil] forCellReuseIdentifier:SCORECELL];
        [_shopCommitTableView registerNib:[UINib nibWithNibName:COMMENTCELl bundle:nil] forCellReuseIdentifier:COMMENTCELl];
    }
    return _shopCommitTableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }
    return self.maMallDatas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 88.f;
    }
    CommentModel*model=self.maMallDatas[indexPath.section];
    return [CommentTableViewCell getCellHeight:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWShopScoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SCORECELL];
        cell.totalScore = self.totalScore;
        return cell;
    }else{
        CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELl];
        cell.selectionStyle=NO;
        
        CommentModel*model=self.maMallDatas[indexPath.row];
        [cell giveValueWithModel:model];
        return cell;
    }
}

-(void)getDatas{
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_MORECOMMIT];
    NSDictionary*params=@{@"shop_id":self.shop_id,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    
    UIView*loadingView=[JWTools addLoadingViewWithframe:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
    [self addSubview:loadingView];
    
    
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data[@"data"]);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                CommentModel*model=[CommentModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
                
            }
            [self.shopCommitTableView reloadData];
            
            //如果没有数据
            if (self.maMallDatas.count<1) {
                [JRToast showWithText:@"没有更多评论了！" duration:3.5f];
                
                //                [self.view addSubview:self.failView];
                //                UIView*failView=[JWTools addFailViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) withTouchBlock:^{
                //                    [failView removeFromSuperview];
                //                    [self.tableView.mj_header beginRefreshing];
                //
                //                }];
                ////                [self.view addSubview:failView];
                //                [self.view insertSubview:failView belowSubview:loadingView];
                
            }
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];    //移除
            
        });
        [self.shopCommitTableView.mj_header endRefreshing];
        [self.shopCommitTableView.mj_footer endRefreshing];
        
    }];
    
}



@end
