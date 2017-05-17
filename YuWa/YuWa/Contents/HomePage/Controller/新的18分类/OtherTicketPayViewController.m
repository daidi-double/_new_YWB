//
//  OtherTicketPayViewController.m
//  YuWa
//
//  Created by double on 17/5/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketPayViewController.h"
#import "OtherTicketPayTableViewCell.h"

#define TICKETPAYCELL  @"OtherTicketPayTableViewCell"
@interface OtherTicketPayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *payTableView;

@end

@implementation OtherTicketPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    
}

- (void)makeUI{
    [self.payTableView registerNib:[UINib nibWithNibName:TICKETPAYCELL bundle:nil] forCellReuseIdentifier:TICKETPAYCELL];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherTicketPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TICKETPAYCELL];
    
    return cell;
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
