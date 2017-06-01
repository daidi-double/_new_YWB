//
//  TableBGView.h
//  YuWa
//
//  Created by double on 17/2/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TableBGViewDelegate <NSObject>

- (void)creatPlaceView:(NSInteger)tag;

@end
@interface TableBGView : UIView
@property (nonatomic,assign) NSInteger staus;
@property (nonatomic,copy) void (^titleBlock)(NSString * title,NSString * cityCode);
@property (nonatomic,copy) void (^titleBlockT)(NSString * title,NSString * listType);
@property (nonatomic,assign)id<TableBGViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andTag:(NSInteger)tag;

@end

