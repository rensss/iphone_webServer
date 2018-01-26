//
//  R_AlertMessage.h
//  iphone_webServer
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 rzk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define RAlertMessageShowInWindow(message) R_AlertMessage *alertMessage = [[R_AlertMessage alloc] initWithMessage:message];\
[alertMessage showInView:[[UIApplication sharedApplication].delegate window] dismiss:nil];

#define RAlertMessage(message,view) R_AlertMessage *alertMessage = [[R_AlertMessage alloc] initWithMessage:message];\
[alertMessage showInView:view dismiss:nil];

@interface R_AlertMessage : NSObject

//提示信息
@property (copy,nonatomic)NSString *message;

//富文本提示
@property (nonatomic, strong) NSAttributedString *attributeMsg;

//初始化信息
- (instancetype)initWithMessage:(NSString *)message;

//富文本提示
- (instancetype)initWithAttributeMessage:(NSAttributedString *)msgAttributeStr;

//根据View显示弹窗 -- 带回调
- (void)showInView:(UIView *)view dismiss:(void(^)(void))dismiss;
@end
