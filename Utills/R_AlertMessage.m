//
//  R_AlertMessage.m
//  iphone_webServer
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 rzk. All rights reserved.
//

#import "R_AlertMessage.h"

@implementation R_AlertMessage
{
    MBProgressHUD *_hud;
}

- (instancetype)initWithMessage:(NSString *)message {
    self = [[R_AlertMessage alloc] init];
    self.message = message;
    return self;
}

- (instancetype)initWithAttributeMessage:(NSAttributedString *)msgAttributeStr;
{
    self = [[R_AlertMessage alloc] init];
    self.attributeMsg = msgAttributeStr;
    return self;
}

- (void)showInView:(UIView *)view dismiss:(void (^)(void))dismiss {
    
    if (!view) {
        return;
    }
    
    if (self.attributeMsg && self.attributeMsg.string > 0) {
        _message = self.attributeMsg.string;
    }
    
    if (!self.message && self.message.length <= 0) {
        return;
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.bezelView.color = [UIColor colorWithHexString:@"222222"];
    _hud.contentColor = [UIColor whiteColor];
    _hud.mode = MBProgressHUDModeText;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:18.0f];
    if (self.attributeMsg) {
        _hud.detailsLabel.attributedText = self.attributeMsg;
    }else {
        _hud.detailsLabel.text = self.message;
    }
    
    CGFloat delay = 1.5;
    
    if (_message.length > 10) {
        delay = 1.8;
    }
    
    if (_message.length > 15) {
        delay = 2.0;
    }
    
    if (_message.length > 20) {
        delay = 2.2;
    }
    
    [_hud hideAnimated:YES afterDelay:delay];
    
    if (dismiss) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dismiss();
        });
    }
}

@end
