//
//  R_LoadingView.h
//  iphone_webServer
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 rzk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface R_LoadingView : NSObject

@property (nonatomic, strong) NSString *message;

//初始化信息
- (instancetype)initWithMessage:(NSString *)message;
//显示等待弹窗
- (void)showInView:(UIView *)view;
//停止显示
- (void)stop;

@end
