//
//  UIImage+R_Category.h
//  R_category
//
//  Created by rzk on 2017/10/10.
//  Copyright © 2017年 rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (R_Category)

/**
 *  根据颜色 生成图片 默认 3x3
 *
 *  @param color 图片的背景颜色
 *
 *  @return UIImage对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
