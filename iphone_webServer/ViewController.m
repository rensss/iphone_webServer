//
//  ViewController.m
//  iphone_webServer
//
//  Created by rzk on 2017/9/7.
//  Copyright © 2017年 rzk. All rights reserved.
//

#import "ViewController.h"

#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"

#import "GCDWebUploader.h"

#import "R_webUploaderViewController.h"

@interface ViewController () <GCDWebServerDelegate>

@property (nonatomic, strong) UIScrollView *scrollerView; /**< 滚动视图*/

@property (nonatomic, strong) UIButton *webServerBtn; /**< 服务器按钮*/
@property (nonatomic, strong) UIButton *webUploaderbtn; /**< 网页上传按钮*/

@property (nonatomic, strong) GCDWebServer *webServer; /**< 服务器*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollerView.frame = self.view.bounds;
    
    self.webServerBtn.frame = CGRectMake(100, 100, self.view.width - 200, 45);
	
    self.webUploaderbtn.y = self.webServerBtn.maxY + 75;
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button {
    
    switch (button.tag - 1000) {
        case 0:
        {
            if ([self.webServer isRunning]) {
                [self.webServer stop];
                [button setTitle:@"webServer" forState:UIControlStateNormal];
            }else {
                // Start server on port 8080
                [self.webServer startWithPort:8080 bonjourName:nil];
                NSLog(@"Visit %@ in your web browser\n", self.webServer.serverURL);
                
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"已打开服务器" message:[NSString stringWithFormat:@"%@",self.webServer.serverURL] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [button setTitle:@"关闭webServer" forState:UIControlStateNormal];
                }];
                [alertC addAction:doneAction];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            R_webUploaderViewController *webUpload = [[R_webUploaderViewController alloc] init];
            UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:webUpload];
            [self presentViewController:NVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - GCDWebServerDelegate
/**
 *  This method is called after the server has successfully started.
 */
- (void)webServerDidStart:(GCDWebServer*)server {
    NSLog(@"webServerDidStart---->\n");
}

/**
 *  This method is called after the Bonjour registration for the server has
 *  successfully completed.
 *
 *  Use the "bonjourServerURL" property to retrieve the Bonjour address of the
 *  server.
 */
- (void)webServerDidCompleteBonjourRegistration:(GCDWebServer*)server {
    NSLog(@"webServerDidCompleteBonjourRegistration---->\n");
}

/**
 *  This method is called after the NAT port mapping for the server has been
 *  updated.
 *
 *  Use the "publicServerURL" property to retrieve the public address of the
 *  server.
 */
- (void)webServerDidUpdateNATPortMapping:(GCDWebServer*)server {
    NSLog(@"webServerDidUpdateNATPortMapping---->\n");
}

/**
 *  This method is called when the first GCDWebServerConnection is opened by the
 *  server to serve a series of HTTP requests.
 *
 *  A series of HTTP requests is considered ongoing as long as new HTTP requests
 *  keep coming (and new GCDWebServerConnection instances keep being opened),
 *  until before the last HTTP request has been responded to (and the
 *  corresponding last GCDWebServerConnection closed).
 */
- (void)webServerDidConnect:(GCDWebServer*)server {
    NSLog(@"webServerDidConnect---->\n");
}

/**
 *  This method is called when the last GCDWebServerConnection is closed after
 *  the server has served a series of HTTP requests.
 *
 *  The GCDWebServerOption_ConnectedStateCoalescingInterval option can be used
 *  to have the server wait some extra delay before considering that the series
 *  of HTTP requests has ended (in case there some latency between consecutive
 *  requests). This effectively coalesces the calls to -webServerDidConnect:
 *  and -webServerDidDisconnect:.
 */
- (void)webServerDidDisconnect:(GCDWebServer*)server {
    NSLog(@"webServerDidDisconnect---->\n");
}

/**
 *  This method is called after the server has stopped.
 */
- (void)webServerDidStop:(GCDWebServer*)server {
    NSLog(@"webServerDidStop---->\n");
}


#pragma mark - getting
- (UIScrollView *)scrollerView {
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] init];
        _scrollerView.alwaysBounceVertical = YES;
        
        [_scrollerView addSubview:self.webServerBtn];
        [_scrollerView addSubview:self.webUploaderbtn];
    }
    return _scrollerView;
}


- (UIButton *)webServerBtn {
    if (!_webServerBtn) {
        _webServerBtn = [[UIButton alloc] init];
        [_webServerBtn setTitle:@"webServer" forState:UIControlStateNormal];
        [_webServerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _webServerBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _webServerBtn.tag = 1000;
        _webServerBtn.layer.cornerRadius = 5;
        _webServerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _webServerBtn.layer.borderWidth = 1;
        [_webServerBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _webServerBtn;
}

- (UIButton *)webUploaderbtn {
    if (!_webUploaderbtn) {
        _webUploaderbtn = [[UIButton alloc] init];
        [_webUploaderbtn setTitle:@"webUploader" forState:UIControlStateNormal];
        [_webUploaderbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _webUploaderbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _webUploaderbtn.tag = 1001;
        _webUploaderbtn.layer.cornerRadius = 5;
        _webUploaderbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _webUploaderbtn.layer.borderWidth = 1;
        [_webUploaderbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _webUploaderbtn;
}

- (GCDWebServer *)webServer {
    if (!_webServer) {
        // Create server
        _webServer = [[GCDWebServer alloc] init];
        _webServer.delegate = self;
        // Add a handler to respond to GET requests on any URL
        [_webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                      
                                      return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hello World</p></body></html>"];
                                      
                                  }];
    }
    return _webServer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
