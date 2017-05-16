//
//  ChooseSeatModel.m
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChooseSeatModel.h"
#import "XZSeatModel.h"
#import "XZSeatsView.h"

@implementation ChooseSeatModel
-(instancetype)initWithDic:(NSDictionary* )dic{
    if (self =  [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(NSMutableArray *)ChooseSeatModelWithDic:(NSMutableArray *)arr {
    //返回的数组model
    NSMutableArray * seatsModelArray = [NSMutableArray arrayWithCapacity:arr.count];
    //用来判断是否是同一行
    NSMutableArray * arrM = [NSMutableArray array ];
    //添加一行当中的座位数组
     NSMutableArray * seatModelAry = [NSMutableArray array ];
    
    for (NSDictionary * dic in arr) {
        ChooseSeatModel * ChooseSeatModel1 =  [[ChooseSeatModel alloc]initWithDic:dic];
//        [arrM addObject:model];
        //先找出一排当中的每一个座位model
        XZSeatModel * model = [[XZSeatModel alloc ]init];
        model.columnId = ChooseSeatModel1.rowNum;
        model.seatNo = ChooseSeatModel1.code;
        model.st = ChooseSeatModel1.status.description;
        if (![arrM containsObject:ChooseSeatModel1.colNum]) {

            //先判断是否是添加第一行，如果是，不运行下面代码
            if (arrM.count != 0) {
                //添加一行的数组
                XZSeatsModel * XZSeatsModel1 = [[XZSeatsModel alloc]init];
                XZSeatsModel1.columns = seatModelAry;
                XZSeatsModel1.rowId = arrM.lastObject;
                XZSeatsModel1.rowNum = arrM.lastObject;
                [seatsModelArray addObject:XZSeatsModel1];
                //清空一行座位model  的数据
                [seatModelAry removeAllObjects];
            }
            //表示不包含，则添加  同事把一行座位清空
            [arrM addObject:ChooseSeatModel1.colNum];
            //在添加下一行的数据
            [seatModelAry addObject:model];
        }else{
            [seatModelAry addObject:model];
        }
        
    }
    XZSeatsModel * XZSeatsModel1 = [[XZSeatsModel alloc]init];
    XZSeatsModel1.columns = seatModelAry;
    XZSeatsModel1.rowId = arrM.lastObject;
    XZSeatsModel1.rowNum = arrM.lastObject;
    [seatsModelArray addObject:XZSeatsModel1];
    return seatsModelArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key   {
    
}
@end
