//
//  UIScrollView+JWGifRefresh.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "UIScrollView+JWGifRefresh.h"
#import "EaseConversationModel.h"
#import "HttpObject.h"
#import "EMConversation.h"
#import "YWMessageTableViewCell.h"
#import "VIPTabBarController.h"

@implementation UIScrollView (JWGifRefresh)

/**
 *  下拉刷新动画
 *  @param imageName  图片名
 *  @param imageCount 图片数量
 *
 *  @return 刷新Header
 */
+ (MJRefreshGifHeader *)scrollRefreshGifHeaderWithImgName:(NSString *)imageName withImageCount:(NSInteger)imageCount withRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock{
     [[[UIScrollView alloc]init]requestShopArrDataWithPages:1];
    MJRefreshGifHeader * gifHeader = [[MJRefreshGifHeader alloc]init];
    gifHeader.refreshingBlock = refreshBlock;
    gifHeader.lastUpdatedTimeLabel.hidden= YES;
    gifHeader.stateLabel.hidden = YES;
    NSMutableArray * headerImagesIdle = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * headerImagesPulling = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * headerImagesRefreshing = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < imageCount; i++) {
        if (i<18) {
            [headerImagesIdle addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }else if (i<38){
            [headerImagesPulling addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }else {
            [headerImagesRefreshing addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }
    }
    [gifHeader setImages:headerImagesIdle duration:(headerImagesIdle.count*0.05) forState:MJRefreshStateIdle];
    [gifHeader setImages:headerImagesPulling duration:(headerImagesPulling.count*0.05) forState:MJRefreshStatePulling];
    [gifHeader setImages:headerImagesRefreshing duration:(headerImagesRefreshing.count*0.05) forState:MJRefreshStateRefreshing];
    return gifHeader;
}


/**
 *  上拉刷新动画
 *  @param imageName  图片名
 *  @param imageCount 图片数量
 *
 *  @return 刷新Header
 */
+ (MJRefreshAutoGifFooter *)scrollRefreshGifFooterWithImgName:(NSString *)imageName withImageCount:(NSInteger)imageCount withRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock{
    [[[UIScrollView alloc]init]requestShopArrDataWithPages:1];
    MJRefreshAutoGifFooter * gifFooter = [[MJRefreshAutoGifFooter alloc]init];
    gifFooter.refreshingBlock = refreshBlock;
    gifFooter.stateLabel.hidden = YES;
    gifFooter.refreshingTitleHidden = YES;
    NSMutableArray * footerImagesIdle = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * footerImagesPulling = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * footerImagesRefreshing = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < imageCount; i++) {
        if (i>=16) {
            [footerImagesRefreshing addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }
    }
    for (int i = 14; i >= 0; i--) {
        if (i < 8||i>10) {
            [footerImagesRefreshing addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }
    }
    [gifFooter setImages:footerImagesIdle duration:(footerImagesIdle.count*0.05) forState:MJRefreshStateIdle];
    [gifFooter setImages:footerImagesPulling duration:(footerImagesPulling.count*0.05) forState:MJRefreshStatePulling];
    [gifFooter setImages:footerImagesRefreshing duration:(footerImagesRefreshing.count*0.05) forState:MJRefreshStateRefreshing];
    return gifFooter;
}
#pragma mark --- 用来设置消息模块有几条信息是未读的
- (void)requestShopArrDataWithPages:(NSInteger)page{
    NSMutableArray * dataArr = [NSMutableArray array];
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
        EMConversation * converstion = sorted[i];
        EaseConversationModel * model = [[EaseConversationModel alloc] initWithConversation:converstion];
        if (model&&([YWMessageTableViewCell latestMessageTitleForConversationModel:model].length>0)){
            [dataArr addObject:model];
            NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":([model.title length] > 0?model.title:model.conversation.conversationId)};
            [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
                MyLog(@"Regieter Code pragram is %@",pragram);
                MyLog(@"Regieter Code is %@",responsObj);
                YWMessageAddressBookModel * modelTemp = [YWMessageAddressBookModel yy_modelWithDictionary:responsObj[@"data"]];
                modelTemp.hxID = [model.title length] > 0?model.title:model.conversation.conversationId;
                model.title = modelTemp.nikeName;
                model.avatarURLPath = modelTemp.header_img;
                model.jModel = modelTemp;
                [dataArr replaceObjectAtIndex:i withObject:model];
                count++;
                int badgeValue = 0;
                for (EaseConversationModel * model in dataArr) {
                    badgeValue += model.conversation.unreadMessagesCount;
                }
                VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                UITabBarItem * item=[rootTabBarVC.tabBar.items objectAtIndex:3];
                item.badgeValue=[NSString stringWithFormat:@"%d",badgeValue];
                //还原
            } failur:^(id responsObj, NSError *error) {
            }];
        }
    }
}

@end
