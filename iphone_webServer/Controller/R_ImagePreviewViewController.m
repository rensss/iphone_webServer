//
//  R_ImagePreviewViewController.m
//  iphone_webServer
//
//  Created by rzk on 2017/9/7.
//  Copyright © 2017年 rzk. All rights reserved.
//

#import "R_ImagePreviewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface R_ImagePreviewViewController ()

@property (nonatomic, strong) UIImageView *imageView; /**< 图*/

@end

@implementation R_ImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;

	UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    [self.imageView addGestureRecognizer:gesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = CGRectZero;
    frame.size = [self getImageSizeWithPath:self.path];
    self.imageView.frame = frame;
    
    self.imageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
}

- (void)dealloc {
	
}

#pragma mark - 长按手势
- (void)longPress {
    
    [self requestImagePickerAuthorizationAndHandler:^(BOOL hasAuthority) {
        if (hasAuthority) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            __weak typeof(self) weakSelf = self;
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf saveImageToPhotos:weakSelf.imageView.image];
            }];
            [alert addAction:saveAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                [[UIApplication sharedApplication] openURL:settingUrl];
            }
        }
    }];
}

#pragma mark - 函数
- (CGSize)getImageSizeWithPath:(NSString *)path {
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    
    CGFloat maxWidth = self.view.frame.size.width - 10;
    CGFloat maxHeight = self.view.frame.size.height - 10;
    
    if (size.width > size.height) {
        if (size.width > maxWidth) {
            size.width = maxWidth;
            size.height = image.size.height * maxWidth / image.size.width;
            if (size.height > maxHeight) {
                size.height = maxHeight;
                size.width = size.height * image.size.width / image.size.height;
            }
        }
    }else {
        if (size.height > maxHeight) {
            size.height = maxHeight;
            size.width = size.height * image.size.width / image.size.height;
            if (size.width > maxWidth) {
                size.width = maxWidth;
                size.height = image.size.height * maxWidth / image.size.width;
            }
        }
    }
    return size;
}

#pragma mark - 保存到相册
- (void)saveImageToPhotos:(UIImage *)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *)contextInfo
{
    NSString *msg = nil;
    if(error != NULL) {
        msg = @"保存图片失败";
    }else {
        msg = @"保存图片成功";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - 权限
#pragma mark -- 相册
/*
 AuthorizationStatusNotDetermined      // 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权
 AuthorizationStatusAuthorized = 0,    // 用户已授权，允许访问
 AuthorizationStatusDenied,            // 用户拒绝访问
 AuthorizationStatusRestricted,        // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
 */
- (void)requestImagePickerAuthorizationAndHandler:(void(^)(BOOL hasAuthority))callback {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusNotDetermined) { // 未授权
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    if (callback) {
                        callback(YES);
                    }
                } else if (status == PHAuthorizationStatusDenied) {
                    if (callback) {
                        callback(NO);
                    }
                } else if (status == PHAuthorizationStatusRestricted) {
                    if (callback) {
                        callback(NO);
                    }
                }
            }];
            
        } else if (authStatus == ALAuthorizationStatusAuthorized) {
            if (callback) {
                callback(YES);
            }
            
        } else if (authStatus == ALAuthorizationStatusDenied) {
            if (callback) {
                callback(NO);
            }
        } else if (authStatus == ALAuthorizationStatusRestricted) {
            if (callback) {
                callback(NO);
            }
        }
    } else {
        if (callback) {
            callback(NO);
        }
    }
}

#pragma mark - getting
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageWithContentsOfFile:self.path];
    }
    return _imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
