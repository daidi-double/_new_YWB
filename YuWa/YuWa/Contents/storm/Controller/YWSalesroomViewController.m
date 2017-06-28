//
//  YWSalesroomViewController.m
//  YuWa
//
//  Created by double on 17/6/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWSalesroomViewController.h"
#import "YWBarnerTableViewCell.h"
#import "YWHotProjectTableViewCell.h"



#define HOTPROJECTCELL @"YWHotProjectTableViewCell"
#define BARNERCELL  @"YWBarnerTableViewCell"
@interface YWSalesroomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabbleViews;
@property (nonatomic,strong)UIView * footView;
@end

@implementation YWSalesroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"美食项目专场";
    [self makeUI];
}
- (void)makeUI{
    [self.tabbleViews registerNib:[UINib nibWithNibName:HOTPROJECTCELL bundle:nil] forCellReuseIdentifier:HOTPROJECTCELL];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != 1) {
        return 1;
    }
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        YWBarnerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BARNERCELL];
        if (!cell) {
            cell = [[YWBarnerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BARNERCELL];
        }
        
        return cell;
    }else {
        YWHotProjectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HOTPROJECTCELL];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kScreen_Height*352/1334;
    }else{
        if (kScreen_Height*634/1334 < 370) {
            return 370;
        }
        return kScreen_Height*634/1334 < 370;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height*300/1334;
    }
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return self.footView;
    }
    return nil;
}
- (void)toLookAll{
    MyLog(@"查看全部");
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (UIView*)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*300/1334)];
        _footView.backgroundColor = [UIColor whiteColor];
        UILabel * sectionNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width/4, 25)];
        sectionNameLabel.centerY = 20;
        sectionNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        sectionNameLabel.font = [UIFont systemFontOfSize:15];
        sectionNameLabel.text = @"投资明星";
        [_footView addSubview:sectionNameLabel];
        
        UIButton * allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allBtn.frame = CGRectMake(kScreen_Width*0.7f, 0, kScreen_Width*0.25f, 40);
        [allBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [allBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, -65)];
        [allBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [allBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [allBtn addTarget:self action:@selector(toLookAll) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:allBtn];
        
        //划分线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(12, allBtn.bottom, kScreen_Width-24, 0.5)];
        line.backgroundColor = RGBCOLOR(240, 241, 242, 1);
        [_footView addSubview:line];
        
        
    }
    return _footView;
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
