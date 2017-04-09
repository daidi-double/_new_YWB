//
//  CommendViewController.m
//  YuWa
//
//  Created by double on 17/2/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CommendViewController.h"
#import "ChooseMovieHeaderView.h"
#import "MovieAddComment.h"//评分
@interface CommendViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UITextView * textCommendView;
}
@property (nonatomic,strong) NSMutableArray * headerViewAry;//海报数据
@property (nonatomic,strong) UITableView * commendTableView;
@end

@implementation CommendViewController
- (NSMutableArray*)headerViewAry{
    if (!_headerViewAry) {
        _headerViewAry = [NSMutableArray array];
    }
    return _headerViewAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发影评";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * issuBtn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(addGrade)];
    self.navigationItem.rightBarButtonItem = issuBtn;
    [self makeUI];
    // Do any additional setup after loading the view.
}
- (void)addGrade{
    NSLog(@"发布影评");
}
- (void)makeUI{
    
    _commendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    
    _commendTableView.delegate = self;
    _commendTableView.dataSource = self;
    
    [self.view addSubview:_commendTableView];
    
    
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        ChooseMovieHeaderView * movieView = [[ChooseMovieHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.2f) andDataAry:self.headerViewAry];
        movieView.backgroundColor = [UIColor darkGrayColor];
        [movieView.playBtn removeFromSuperview];
        [movieView.PrivateLetterTap removeTarget:self action:@selector(tapAvatarView)];
        [movieView.wantSeeBtn removeFromSuperview];
        [movieView.gradeBtn removeFromSuperview];
        return movieView;
    }else{
        return nil;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height * 0.2f;
        
    }else{
        return 0.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    if (indexPath.section == 0) {
        MovieAddComment * addComent = [[MovieAddComment alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 2 * cell.height)];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:addComent];
       
    }else{
        textCommendView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, cell.width, 2* cell.height)];
        textCommendView.delegate = self;
        textCommendView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textCommendView];
        
        _comLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreen_Width/5, 20)];
        _comLabel.text = @"写下你影评";
        _comLabel.textColor = [UIColor lightGrayColor];
        _comLabel.font = [UIFont systemFontOfSize:10];
        [cell.contentView addSubview:_comLabel];
    }
    return cell;
}
//设置textView的placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (textCommendView.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            _comLabel.hidden=NO;//隐藏文字
        }else{
            _comLabel.hidden=YES;
        }
    }else{//textview长度不为0
        if (textCommendView.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                _comLabel.hidden=NO;
            }else{//不是删除
                _comLabel.hidden=YES;
            }
        }else{//长度不为1时候
            _comLabel.hidden=YES;
        }
    }

    return YES;
    
}
- (void)tapAvatarView{
    
  
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
