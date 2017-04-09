//
//  NSDictionary+Attributes.m
//  JW百思
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "NSDictionary+Attributes.h"

@implementation NSDictionary (Attributes)

#pragma mark - SettingAttributes
/**
 *  设置控件文字Attributes
 *
 *  @param font  文字字体
 *  @param color 文字颜色
 *
 *  @return TextAttributes
 */
+ (NSDictionary *)dicOfTextAttributeWithFont:(UIFont *)font withTextColor:(UIColor *)color{
    NSDictionary * attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    return attributes;
}

@end
