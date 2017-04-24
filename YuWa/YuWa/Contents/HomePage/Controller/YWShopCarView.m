//
//  YWShopCarView.m
//  YuWa
//
//  Created by double on 17/4/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopCarView.h"
#import "YWShopCarTableViewCell.h"
#import "ShopDetailGoodsModel.h"


#define SHOPCARCELL @"YWShopCarTableViewCell"
@interface YWShopCarView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGRect  myFrame;

@end
@implementation YWShopCarView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.clearView];
        [self addSubview:self.shopTableView];
        [self.shopTableView registerNib:[UINib nibWithNibName:SHOPCARCELL bundle:nil] forCellReuseIdentifier:SHOPCARCELL];
        
    }
    return self;
}

-(UIView*)clearView{
    if (!_clearView) {
        _clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 35)];
        _clearView.backgroundColor = RGBCOLOR(234, 234, 234, 1);
        _strLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, _clearView.width * 0.4, 35)];
        _strLabel.text = @"已选商品";
        _strLabel.textColor = RGBCOLOR(112, 122, 112, 1);
        _strLabel.font = [UIFont systemFontOfSize:15];
        [_clearView addSubview:_strLabel];
        UIButton * clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(_clearView.width - 85, 0,70, 35);
        [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [clearBtn setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
        [clearBtn setTitleColor:RGBCOLOR(112, 122, 112, 1) forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearAllShopAction:) forControlEvents:UIControlEventTouchUpInside];
        [_clearView addSubview:clearBtn];
    }
    return _clearView;
}
- (UITableView*)shopTableView{
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, self.width, self.height-35) style:UITableViewStylePlain];
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        
    }
    return _shopTableView;
}
//- (void)drawRect:(CGRect)rect {
//    
//}
- (void)clearAllShopAction:(UIButton *)sender {
    [self.shopInfoAry removeAllObjects];
    [self.delegate clearShop];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopInfoAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWShopCarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SHOPCARCELL];
    NSDictionary * dit = self.shopInfoAry[indexPath.row];
        ShopDetailGoodsModel * goodModel = [ShopDetailGoodsModel yy_modelWithDictionary:dit];
    cell.model = goodModel;
    
    return cell;
}
@end
