//
//  R_webUploaderViewController.m
//  iphone_webServer
//
//  Created by rzk on 2017/9/7.
//  Copyright © 2017年 rzk. All rights reserved.
//

#import "R_webUploaderViewController.h"
#import "R_ImagePreviewViewController.h"
#import "R_FileTableViewCell.h"
#import "GCDWebUploader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface R_webUploaderViewController () <GCDWebUploaderDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray; /**< 数据源*/
@property (nonatomic, strong) NSMutableArray *selectFileArray; /**< 选中的数据*/
@property (nonatomic, strong) UITableView *tableView; /**< 列表*/
@property (nonatomic, copy) NSString *documentPath; /**< 本地文件夹路径*/
@property (nonatomic, strong) UILabel *addressLabel; /**< 地址*/
@property (nonatomic, strong) GCDWebUploader *webUploader; /**< 网页上传*/
@property (nonatomic, assign) BOOL isEditing; /**< 是否编辑*/
@property (nonatomic, strong) R_LoadingView *loadingView; /**< 加载中...*/
@property (nonatomic, strong) UIButton *saveButton; /**< 保存按钮*/
@property (nonatomic, strong) UIButton *deleteButton; /**< 删除按钮*/
@property (nonatomic, assign) NSInteger selectCount; /**< 选中的个数*/

@end

@implementation R_webUploaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"webUploader";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:@"关闭" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [leftButton setTitle:@"编辑" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.webUploader start];
    NSLog(@"Visit %@ in your web browser", self.webUploader.serverURL);
    
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.tableView];
    
    self.addressLabel.text = [NSString stringWithFormat:@"浏览器访问->%@",self.webUploader.serverURL];
    
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.deleteButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.addressLabel.frame = CGRectMake(0, self.navigationBarHeight + self.statusBarHeight, self.view.width, 25);
    
    CGFloat addressLabelMaxY = self.addressLabel.frame.size.height + self.addressLabel.frame.origin.y;
    
    self.tableView.frame = CGRectMake(0, addressLabelMaxY, self.view.frame.size.width, self.view.frame.size.height - addressLabelMaxY);
    
    self.saveButton.x = (self.view.width - 200) / 3;
    self.deleteButton.maxX = self.view.width - self.saveButton.x;
    
    self.deleteButton.maxY = self.saveButton.maxY = self.view.height - self.safeAreaInsets.bottom - 10;
}

- (void)dealloc {
    [self.webUploader stop];
    NSLog(@"%@ 销毁了",[self class]);
}

#pragma mark - 返回
- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 编辑
- (void)editClick {
    self.isEditing = !self.isEditing;
    [self reloadTableView];
    
    self.tableView.editing = self.isEditing;
    if (!self.editing) {
        [self.selectFileArray removeAllObjects];
        self.deleteButton.hidden = self.saveButton.hidden = YES;
    }else {
        self.deleteButton.hidden = self.saveButton.hidden = NO;
    }
}

#pragma mark - 代理
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    R_FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"R_FileTableViewCell"];
    
    if (!cell) {
        cell = [[R_FileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"R_FileTableViewCell"];
    }
    
    cell.file = self.dataArray[indexPath.row];
    cell.isEditing = self.isEditing;
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    R_FileModel *file = self.dataArray[indexPath.row];
    
    if (self.isEditing) {
        if (self.selectFileArray.count >= 9) {
            RAlertMessage(@"一次最多9张图", self.view);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        [self.selectFileArray addObject:file];
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // 文件信息
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:file.filePath error:nil];
        // 是否图片后缀
        if ([file.fileType isEqualToString:@"jpeg"] || [file.fileType isEqualToString:@"jpg"] || [file.fileType isEqualToString:@"png"]) {
            
            R_ImagePreviewViewController *imageVC = [[R_ImagePreviewViewController alloc] init];
            
            imageVC.path = file.filePath;
            //        imageVC.preferredContentSize = [self getImageSizeWithPath:path];
            imageVC.modalPresentationStyle = UIModalPresentationPopover;
            
            UIPopoverPresentationController *popvc = imageVC.popoverPresentationController;
            popvc.delegate = self;
            popvc.sourceView = cell;
            popvc.sourceRect = cell.bounds;
            popvc.permittedArrowDirections = UIPopoverArrowDirectionAny;
            
            [self presentViewController:imageVC animated:YES completion:nil];
            
        }else {
            // 显示文件信息
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"文件" message:[NSString stringWithFormat:@"%@",dict] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    R_FileModel *file = self.dataArray[indexPath.row];
    [self.selectFileArray removeObject:file];
}


#pragma mark -- 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.documentPath,self.dataArray[indexPath.row]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //文件名
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave) {
        RAlertMessage(@"未找到该文件", self.view);
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele) {
            [self reloadTableView];
        }else {
            RAlertMessage(@"删除失败", self.view);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
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
    
    NSString *title = [path stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",uploader.uploadDirectory]  withString:@""];
    
    NSString *alertMessageStr = [NSString stringWithFormat:@"%@ 上传成功",title];
    
    RAlertMessage(alertMessageStr,self.view);
    
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
/// 刷新列表
- (void)reloadTableView {
    self.dataArray = nil;
    [self.tableView reloadData];
}

/// 保存照片结果回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    self.selectCount ++;
    if (error) {
//        RAlertMessage(@"保存失败!", self.view);
        NSLog(@"%@",error);
		[self saveImageToPhotos:image];
        return;
    }
    if (self.selectFileArray.count == self.selectCount) {
        [self.loadingView stop];
        RAlertMessage(@"保存成功!", self.view);
    }
}

#pragma mark - 保存到相册
/// 保存到相册
- (void)saveImageToPhotos:(UIImage *)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


#pragma mark - 点击事件
- (void)handleTapOnLabel:(UILabel *)label {
    // 剪切板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.webUploader.serverURL.absoluteString];
    
    RAlertMessage(@"已复制到剪切板", self.view);
}

- (void)buttonClick:(UIButton *)button {
    
    __weak typeof(self) weakSelf = self;
    
    switch (button.tag - 1000) {
        case 0:
        {
            if (self.selectFileArray.count > 0) {
                self.selectCount = 0;
                [self.loadingView showInView:self.view];
                for (R_FileModel *file in self.selectFileArray) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [weakSelf saveImageToPhotos:[UIImage imageWithContentsOfFile:file.filePath]];
                    });
                }
            }else {
                RAlertMessage(@"还未选择文件", self.view);
            }
        }
            break;
        case 1:
        {
            self.loadingView.message = @"删除中...";
            [self.loadingView showInView:self.view];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                unsigned count = 0;
                for (R_FileModel *file in weakSelf.selectFileArray) {
                    NSError *error;
                    BOOL res = [fileManager removeItemAtPath:file.filePath error:&error];
                    if (res) {
                        count ++;
                    }else {
                        NSLog(@"%@",error);
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (count == weakSelf.selectFileArray.count) {
                        // 关闭编辑模式
                        [weakSelf editClick];
                        [weakSelf.loadingView stop];
                        RAlertMessage(@"删除成功", weakSelf.view);
                    }else {
                        [weakSelf.loadingView stop];
                        NSString *str = [NSString stringWithFormat:@"%lu条 删除失败",weakSelf.selectFileArray.count - count];
                        RAlertMessage(str, weakSelf.view);
                        // 关闭编辑模式
                        [weakSelf editClick];
                    }
                });
            });
        }
            break;
            
        default:
            break;
    }
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
        _dataArray = [NSMutableArray array];
        NSFileManager *manager = [NSFileManager defaultManager];
        //获取数据
        //①只获取文件名
        NSArray *fileNameArray = [NSMutableArray arrayWithArray:[manager contentsOfDirectoryAtPath:self.documentPath error:nil]];
        
        for (NSString *fileName in fileNameArray) {
            R_FileModel *file = [R_FileModel new];
            file.fileName = fileName;
            file.filePath = [NSString stringWithFormat:@"%@/%@",self.documentPath,fileName];
            file.fileType = [[fileName componentsSeparatedByString:@"."] lastObject];
            [_dataArray addObject:file];
        }
        
    }
    return _dataArray;
}

- (NSMutableArray *)selectFileArray {
    if (!_selectFileArray) {
        _selectFileArray = [NSMutableArray array];
    }
    return _selectFileArray;
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
        
        _addressLabel.userInteractionEnabled = YES;
        [_addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
        
    }
    return _addressLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 80;
        _tableView.emptyImage = [UIImage imageNamed:@"empty_search"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (R_LoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[R_LoadingView alloc] initWithMessage:@"保存中..."];
    }
    return _loadingView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];

        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _saveButton.hidden = YES;
        _saveButton.tag = 1000;
        _saveButton.layer.cornerRadius = 5;
        _saveButton.backgroundColor = [UIColor grayColor];
        [_saveButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _deleteButton.hidden = YES;
        _deleteButton.tag = 1001;
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.backgroundColor = [UIColor redColor];
        [_deleteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
