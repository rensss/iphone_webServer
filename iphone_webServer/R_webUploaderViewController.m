//
//  R_webUploaderViewController.m
//  iphone_webServer
//
//  Created by rzk on 2017/9/7.
//  Copyright © 2017年 rzk. All rights reserved.
//

#import "R_webUploaderViewController.h"
#import "R_ImagePreviewViewController.h"

#import "GCDWebUploader.h"

@interface R_webUploaderViewController () <GCDWebUploaderDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray; /**< 数据源*/
@property (nonatomic, strong) UITableView *tableView; /**< 列表*/
@property (nonatomic, copy) NSString *documentPath; /**< 本地文件夹路径*/
@property (nonatomic, strong) UILabel *addressLabel; /**< 地址*/
@property (nonatomic, strong) GCDWebUploader *webUploader; /**< 网页上传*/

@end

@implementation R_webUploaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"webUploader";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.webUploader start];
    NSLog(@"Visit %@ in your web browser", self.webUploader.serverURL);
    
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.tableView];
    
    self.addressLabel.text = [NSString stringWithFormat:@"浏览器访问:%@",self.webUploader.serverURL];
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"浏览器访问:" message:self.webUploader.serverURL.absoluteString preferredStyle:UIAlertControllerStyleAlert];
    
//    __weak typeof(self) weakSelf = self;
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:cancelAction];
//
//    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        [pasteboard setString:weakSelf.webUploader.serverURL.absoluteString];
//    }];
//    [alertController addAction:copyAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.addressLabel.frame = CGRectMake(50, 65, self.view.frame.size.width - 100, 25);
    
    CGFloat addressLabelMaxY = self.addressLabel.frame.size.height + self.addressLabel.frame.origin.y;
    
    self.tableView.frame = CGRectMake(0, addressLabelMaxY, self.view.frame.size.width, self.view.frame.size.height - addressLabelMaxY);
}

#pragma mark - tableViewDelegate
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.documentPath,self.dataArray[indexPath.row]];
    
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    NSString *fileName = self.dataArray[indexPath.row];
    NSString *fileSuffix = [[fileName componentsSeparatedByString:@"."] lastObject];
    
    if ([fileSuffix isEqualToString:@"jpg"] || [fileSuffix isEqualToString:@"png"]) {
        
        R_ImagePreviewViewController *imageVC = [[R_ImagePreviewViewController alloc] init];
        
        imageVC.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
        
        imageVC.preferredContentSize = [self getImageSizeWithPath:path];
        imageVC.modalPresentationStyle = UIModalPresentationPopover;
        
        UIPopoverPresentationController *popvc = imageVC.popoverPresentationController;
        popvc.delegate = self;
        popvc.sourceView = cell;
        popvc.sourceRect = cell.bounds;
        popvc.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        [self presentViewController:imageVC animated:YES completion:nil];
        
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"文件" message:[NSString stringWithFormat:@"%@",dict] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - GCDWebUploaderDelegate
/**
 *  This method is called whenever a file has been downloaded.
 */
- (void)webUploader:(GCDWebUploader*)uploader didDownloadFileAtPath:(NSString*)path {
    NSLog(@"didDownloadFileAtPath---->\n");
    [self reloadTableView];
}

/**
 *  This method is called whenever a file has been uploaded.
 */
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"didUploadFileAtPath---->\n");
    [self reloadTableView];
}

/**
 *  This method is called whenever a file or directory has been moved.
 */
- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"didMoveItemFromPath---->\n");
    [self reloadTableView];
}

/**
 *  This method is called whenever a file or directory has been deleted.
 */
- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"didDeleteItemAtPath---->\n");
    [self reloadTableView];
}

/**
 *  This method is called whenever a directory has been created.
 */
- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"didCreateDirectoryAtPath---->\n");
    [self reloadTableView];
}

#pragma mark -- UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}

#pragma mark - 函数
- (void)reloadTableView {
    self.dataArray = nil;
    [self.tableView reloadData];
}

//保存照片结果回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}

- (CGSize)getImageSizeWithPath:(NSString *)path {
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    CGFloat maxWidth = self.view.frame.size.width - 60;
    CGFloat maxHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - 60;
    
    if (size.width > maxWidth) {
        size.width = maxWidth;
        size.height = image.size.height * maxWidth / image.size.width;
        
        if (size.height > maxHeight) {
            size.height = maxHeight;
#warning -bug- 横屏高度不正确
            size.width = size.height * size.width / maxHeight;
        }
    }else {
        if (size.height > maxHeight) {
            size.height = maxHeight;
            size.width = size.height * image.size.width / image.size.height;
        }
    }
    
    return size;
}

#pragma mark - getting
- (NSString *)documentPath {
    if (!_documentPath) {
        _documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return _documentPath;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentPath error:nil]];
    }
    return _dataArray;
}

- (GCDWebUploader *)webUploader {
    if (!_webUploader) {
        _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:self.documentPath];
        _webUploader.delegate = self;
    }
    return _webUploader;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor blueColor];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addressLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 80;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
