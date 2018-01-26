//
//  R_LoadingView.m
//  iphone_webServer
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 rzk. All rights reserved.
//

#import "R_LoadingView.h"

@implementation R_LoadingView {
    MBProgressHUD *hud;
}

- (instancetype)initWithMessage:(NSString *)message {
    self = [[R_LoadingView alloc] init];
    _message = message;
    return self;
}

- (void)showInView:(UIView *)view {
    
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.color = [UIColor colorWithHexString:@"222222"];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = self.message;
}

//停止显示
- (void)stop {
    [hud hideAnimated:YES];
}


- (void)setMessage:(NSString *)message{
    _message = message;
    hud.detailsLabel.text = message;
}

@end
