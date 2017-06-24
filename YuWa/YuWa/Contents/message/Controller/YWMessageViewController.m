//
//  YWMessageViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/27.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "VIPTabBarController.h"
#import "YWMessageViewController.h"
#import "YWLoginViewController.h"
#import "YWMessageNotificationViewController.h"
#import "YWMessageFriendsAddViewController.h"
#import "YWMessageChatViewController.h"
#import "YWMessageAddressBookTableView.h"
#import "EaseUI.h"
#import "NSDictionary+Attributes.h"

#import "YWMessageTableViewCell.h"


#define MESSAGECELL @"YWMessageTableViewCell"
@interface YWMessageViewController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *noLoginBGBtnView;
@property (nonatomic,strong)UIImageView *noChatBGBtnView;
@property (nonatomic,strong)UILabel * noChatlabel;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;

@property (nonatomic,assign)NSInteger status;
@property (nonatomic,assign)NSInteger status1;//状态用来刷新当前页面是消息页面还是通讯录页面
@property (nonatomic,strong)UISegmentedControl * segmentedControl;
@property (nonatomic,strong)YWMessageAddressBookTableView * addressBooktableView;
@property (nonatomic,strong)UIBarButtonItem * rightBarBtn;

//为tabbar右上角提供红色数字提示用的
@property (nonatomic, assign) int badgeValue;
//用来记录好友的名称数组，如果有昵称，就用昵称，没有就用环信ID
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, copy) NSString * path;
@end

@implementation YWMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
   [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupRefresh];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    self.noLoginBGBtnView.hidden = YES;
    self.noChatBGBtnView.hidden = YES;
    self.noChatlabel.hidden = self.noChatBGBtnView.hidden;
    if (self.status == 1&&![UserSession instance].isLogin){
        self.segmentedControl.selectedSegmentIndex = 0;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![UserSession instance].isLogin){
        [self withOutLogion];
        return;
    }else if(self.status == 0||self.status1){
        [self headerRereshing];
    }else if (self.status == 1&&self.addressBooktableView) {
        [self.addressBooktableView headerRereshing];
    }
    if (self.status1) {
        [self.addressBooktableView setupRefresh];
    }
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGECELL bundle:nil] forCellReuseIdentifier:MESSAGECELL];
}

- (void)makeUI{
    self.tableView.alwaysBounceVertical = YES;
    self.noChatBGBtnView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2-40.f, kScreen_Height/2 - 80.f, 80.f, 80.f)];
    self.noChatBGBtnView.image = [UIImage imageNamed:@"MessageNoChat"];
    self.noChatBGBtnView.hidden = YES;
    [self.view addSubview:self.noChatBGBtnView];
    
    self.noChatlabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(self.noChatBGBtnView.frame), kScreen_Width, 21.f)];
    self.noChatlabel.textAlignment = NSTextAlignmentCenter;
    self.noChatlabel.text = @"暂时没有新消息";
    self.noChatlabel.textColor = [UIColor colorWithHexString:@"#b1b4bb"];
    self.noChatlabel.font = [UIFont systemFontOfSize:17.f];
    self.noChatlabel.hidden = YES;
    [self.view addSubview:self.noChatlabel];
    
    [self addressBookMake];

}
- (void)makeNavi{
    self.segmentedControl = [self makeSegmentedControl];
    self.navigationItem.titleView = self.segmentedControl;
}

- (UISegmentedControl *)makeSegmentedControl{
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"消息",@"通讯录"]];
    segmentControl.frame = CGRectMake(0.f, 0.f, ACTUAL_WIDTH(180.f), 30.f);
    segmentControl.tintColor = [UIColor whiteColor];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5.f;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentControl.layer.borderWidth = 2.f;
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    return segmentControl;
}

- (void)addressBookMake{
    self.addressBooktableView = [[YWMessageAddressBookTableView alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f - 49.f) style:UITableViewStylePlain];
    [self.addressBooktableView dataSet];
    WEAKSELF;
    self.addressBooktableView.friendsAddBlock = ^(){
        YWMessageFriendsAddViewController * vc = [[YWMessageFriendsAddViewController alloc]init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YWMessageAddressBookTableViewCell * firstCell = [weakSelf.addressBooktableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            firstCell.countLabel.hidden = YES;
        });
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.addressBooktableView.friendsChatBlock = ^(YWMessageAddressBookModel * model){
        [weakSelf chatWithUser:model];
    };
    self.addressBooktableView.friendsModel = ^(NSArray  * dataArrM){
        //已经排序号的数组，dataArrM[i]表示第几组。dataArrM[i][i]表示第几组第几个好友的model
        [weakSelf.nameArr removeAllObjects];
        if ([dataArrM[0]  isEqual: @1]) {
            //            说明没有好友
             [weakSelf requestShopArrDataWithPages:0];
            //没好友。更新个空数组
            
            [weakSelf.nameArr writeToFile:weakSelf.path atomically:YES];
            return ;
        }
        for (NSArray * section in dataArrM) {
            for (YWMessageAddressBookModel * model in section) {
                if (![weakSelf.nameArr containsObject:model.nikeName]) {
                    [weakSelf.nameArr addObject:model.nikeName];
                }
            }
        }
        //好友的名字数组得出之后 weakSelf.nameArr  对他进行数据持久化
        [weakSelf.nameArr writeToFile:weakSelf.path atomically:YES];
        //那怎么证明我的数据写入了呢？读出来看看
        NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:weakSelf.path];
        NSLog(@"%@", data1);
        //加载本页面数据
        [weakSelf requestShopArrDataWithPages:0];
        
    };
    [self.view addSubview:self.addressBooktableView];
}

#pragma mark - Control Action
- (IBAction)noLoginBGBtnAvtion:(id)sender {
    if (![UserSession instance].isLogin){
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)withOutLogion{
    self.noLoginBGBtnView.hidden = NO;
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    }];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:cancelAction];
    [alertVC addAction:OKAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex+2;
    
    if (!self.addressBooktableView)return;
    self.addressBooktableView.hidden = sender.selectedSegmentIndex == 0?YES:NO;
    
    if (sender.selectedSegmentIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
        self.status1 = 0;
    }else{
        [self.addressBooktableView.mj_header beginRefreshing];
         self.status1 = 1;
    }
}

- (void)isNewNotification:(BOOL)isNew{
    UILabel * redLabel = (UILabel *)[self.rightBarBtn.customView viewWithTag:1001];
    redLabel.hidden = !isNew;
}
- (void)chatWithUser:(YWMessageAddressBookModel *)model{
    YWMessageChatViewController *chatVC = [[YWMessageChatViewController alloc] initWithConversationChatter:model.hxID conversationType:EMConversationTypeChat];
    BOOL isCun = NO;
    for (NSString * name in self.nameArr) {
        MyLog(@"%@",name);
        if ([model.nikeName  isEqualToString:name]) {
            isCun = YES;
        }
    }
    if (isCun !=YES ) {
        //表示不是好友。则处理一下
        chatVC.chatMessage = @"已不是好友,不能执行此操作";
    }else{
        chatVC.chatMessage = nil;
    }
    chatVC.friendNikeName = model.nikeName;
    chatVC.friendID = model.user_id;
    chatVC.friendIcon = model.header_img;
    chatVC.user_type = model.user_type;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.f;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        if (indexPath.row<[self.dataArr count]) {
            EaseConversationModel *model = self.dataArr[indexPath.row];
            [self.dataArr removeObjectAtIndex:indexPath.row];//移除数据源的数据
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {

                [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];

            });
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //在进入聊天页面之前、先判断是否是好友，如果不是，则不能发送消息
    YWMessageTableViewCell * messageCell = [tableView cellForRowAtIndexPath:indexPath];
 
    [self chatWithUser:messageCell.model.jModel];

}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.noChatBGBtnView.hidden = self.dataArr.count != 0?YES:NO;
    if (![UserSession instance].isLogin)self.noChatBGBtnView.hidden = YES;
    self.noChatlabel.hidden = self.noChatBGBtnView.hidden;
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMessageTableViewCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGECELL];
    messageCell.model = self.dataArr[indexPath.row];
    return messageCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(cancelRefreshWithIsHeader:) userInfo:nil repeats:NO ];
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
        if ( !self.tableView.mj_footer.isRefreshing){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelRefreshWithIsHeader:YES];
            });
        }

    }];
}
- (void)footerRereshing{
    self.pages++;
    [self requestShopArrDataWithPages:self.pages];
}
- (void)headerRereshing{
    self.pages = 0;
         [self.addressBooktableView headerRereshing];
//    self.addressBooktableView.friendsModel  中回调了下面这个方法刷新本页面
//    [self requestShopArrDataWithPages:0];
}
- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if ( self.tableView.mj_footer.isRefreshing){
        [self.tableView.mj_footer endRefreshing];
    }

}
#pragma mark - Http
- (void)requestShopArrDataWithPages:(NSInteger)page{
    if (page>0){
        [self cancelRefreshWithIsHeader:YES];
        return;
    }else{
        [self.dataArr removeAllObjects];
    }
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:^(EMConversation *obj1, EMConversation* obj2){
        EMMessage *message1 = [obj1 latestMessage];
        EMMessage *message2 = [obj2 latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];
    
    __block NSInteger count = 0;
    for (int i = 0; i<sorted.count; i++) {
        dispatch_sync(dispatch_queue_create("friendsList", DISPATCH_QUEUE_SERIAL), ^{
            EMConversation * converstion = sorted[i];
            EaseConversationModel * model = [[EaseConversationModel alloc] initWithConversation:converstion];
            
            if (model&&([YWMessageTableViewCell latestMessageTitleForConversationModel:model].length>0)){
                [self.dataArr addObject:model];
                NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":([model.title length] > 0?model.title:model.conversation.conversationId),@"user_type":@(1),@"type":@2};
                
                [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
                    //循环到最后做一个的时候，执行取消刷新状态
                    if (sorted.count-1 == i) {
                        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
                        [self cancelRefreshWithIsHeader:YES];
                    }
                    MyLog(@"参数Regieter Code pragram is %@",pragram);
                    MyLog(@"好友信息Regieter Code is %@",responsObj);
                    YWMessageAddressBookModel * modelTemp = [YWMessageAddressBookModel yy_modelWithDictionary:responsObj[@"data"]];
                    modelTemp.hxID = [model.title length] > 0?model.title:model.conversation.conversationId;
                    model.title = modelTemp.nikeName;
                    model.avatarURLPath = modelTemp.header_img;
                    model.jModel = modelTemp;
                    [self.dataArr replaceObjectAtIndex:i withObject:model];
                    count++;
                    if (count >= sorted.count) {
                        [self.tableView reloadData];
                    }
                    //给tabbar 增加一个红色提示数字
                    for (EaseConversationModel * model in self.dataArr) {
                        self.badgeValue += model.conversation.unreadMessagesCount;
                        MyLog(@"%d",model.conversation.unreadMessagesCount);
                    }
                    VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    UITabBarItem * item=[rootTabBarVC.tabBar.items objectAtIndex:3];
                    item.badgeValue=[NSString stringWithFormat:@"%d",self.badgeValue];
                    if (self.badgeValue == 0) {
                        item.badgeValue = nil;
                    }
                    self.badgeValue = 0;
                } failur:^(id responsObj, NSError *error) {
                    MyLog(@"参数Regieter Code pragram is %@",pragram);
                    MyLog(@"错误信息Regieter Code error is %@",responsObj);
                    if (count>0) {
                        [self.tableView reloadData];
                    }
                }];
            }
        });
    }
}
-(void)messagesDidReceive:(NSArray *)aMessages{
    BOOL  isReceive = NO;
    for (EMMessage *message in aMessages) {
        if (message.body.type == EMMessageBodyTypeText) {
            MyLog(@"接收到文字消息");
            
            WEAKSELF;
            if (!isReceive) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf requestShopArrDataWithPages:0];
                    
                });
            }
            isReceive = YES;
        }
        
    }
    
}
-(NSMutableArray *)nameArr{
    if (!_nameArr) {
        _nameArr = [NSMutableArray array];
    }
    return _nameArr;
}
-(NSString *)path{
    if (!_path) {
        _path  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _path = [_path stringByAppendingPathComponent:@"isFriends.plist"];
    }
    return _path;
}
@end
