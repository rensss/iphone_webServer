//
//  UIView+R_Categroy.h
//  R_category
//
//  Created by rzk on 2017/10/10.
//  Copyright © 2017年 rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UIView 的扩展
 */
@interface UIView (R_Categroy)

/**
 *  UIView的x
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  UIView的y
 */
@property (nonatomic, assign) CGFloat y;
/**
 *  UIView最大的x
 */
@property (nonatomic, assign) CGFloat maxX;
/**
 *  UIView最大的y
 */
@property (nonatomic, assign) CGFloat maxY;
/**
 *  UIView中心x
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 *  UIView中心y
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 *  UIView的宽
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  UIView的高
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  UIView的尺寸
 */
@property (nonatomic, assign) CGSize size;

/**
 *  当前view的controller
 *
 *  @return UIViewController
 */
- (UIViewController *)viewController;

@end
