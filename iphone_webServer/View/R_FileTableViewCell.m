//
//  R_FileTableViewCell.m
//  iphone_webServer
//
//  Created by MBP on 2018/2/28.
//  Copyright © 2018年 rzk. All rights reserved.
//

#import "R_FileTableViewCell.h"

@interface R_FileTableViewCell ()

@property (nonatomic, strong) UIImageView *markImage; /**< 标记图片*/
@property (nonatomic, strong) UIImageView *thumbnailImage; /**< 缩略图*/
@property (nonatomic, strong) UILabel *titleName; /**< 文件名*/

@end

@implementation R_FileTableViewCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.markImage];
        [self.contentView addSubview:self.thumbnailImage];
        [self.contentView addSubview:self.titleName];
    }
    return self;
}

- (void)layoutSubviews {
    
    if (self.isEditing) {
        self.contentView.x = 0;
        
        self.markImage.frame = CGRectMake(5, 0, 25, 25);
        self.markImage.centerY = self.height / 2;
        
        self.thumbnailImage.frame = CGRectMake(35, 2, 100, self.height - 4);
        self.thumbnailImage.centerY = self.height / 2;
    }else {
        self.thumbnailImage.frame = CGRectMake(5, 2, 100, self.height - 4);
        self.thumbnailImage.centerY = self.height / 2;
    }
    
    self.titleName.frame = CGRectMake(self.thumbnailImage.maxX + 5, 0, self.width - self.thumbnailImage.maxX - 5, self.height);
}

#pragma mark - overwrite
- (void)willTransitionToState:(UITableViewCellStateMask)state {
    self.contentView.x = 0;
}

#pragma mark - 选中/未选中
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.markImage.image = [UIImage imageNamed:@"select"];
    }else {
        self.markImage.image = [UIImage imageNamed:@"unselect"];
    }
}

#pragma mark - 函数
- (void)cacheImage {
    //先把id记录下来，这是在cell里面加的property
//    cell.objectIdforThisCell = **这个cell所代表的对象的id**;
//    
//    //在这个block里面的id，到这一步是设置为cell.objectIdforThisCell一样的
//    NSString *blockObjectid = cell.objectIdforThisCell;
//    
//    dispatch_async(imagequeue, ^{
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:小图文件path];
//        dispatch_async(dispatch_get_main_queue(),
//                       ^{
//                           [self setImage:image forState:state];
//                       });
//        
//        image = [[UIImage alloc] initWithContentsOfFile:大图文件path];
//        dispatch_async(dispatch_get_main_queue(),
//                       ^{
//                           if ([cell.objectIdforThisCell isEqualToString:blockObjectid]) {
//                               
//                               
//                               //关键在这里，当列表拖动速度很快的时候，cell的property已经被修改（因为reuse了），但是blockObjectid在这个线程里面还是旧的。
//                               //当它们****不相等****，这个cell就是刷太快而被另外一个线程用上了，也就是说，这张大图已经不再需要输出到cell里面了（被另外一个线程的另外一张图冲掉了）
//                               //这样一来，在列表快速拖动的时候，瞬间把低清晰的图像给贴上去，等拖动速度慢下来之后，再贴高清晰的图，用户也感觉不出来，也不卡了。
//                               
//                               
//                               [self setImage:image forState:state];
//                           }
//                           
//                       });
//    });
//    
//    dispatch_release(imagequeue);
}

- (void)cacheSmallImage:(UIImage *)img {
//    CGSize newSize = CGSizeMake(100, self.height);
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
}

#pragma mark - setting
- (void)setFile:(R_FileModel *)file {
    
    _file = file;
    
    self.titleName.text = file.fileName;
    
    NSString *fileName = file.fileName;
    NSString *fileSuffix = [[fileName componentsSeparatedByString:@"."] lastObject];
    
    if ([fileSuffix isEqualToString:@"jpeg"] || [fileSuffix isEqualToString:@"jpg"] || [fileSuffix isEqualToString:@"png"]) {
        self.thumbnailImage.image = [UIImage imageWithContentsOfFile:file.filePath];
    }
    
}

#pragma mark - getting
- (UIImageView *)markImage {
    if (!_markImage) {
        _markImage = [[UIImageView alloc] init];
        _markImage.image = [UIImage imageNamed:@"unselect"];
    }
    return _markImage;
}

- (UIImageView *)thumbnailImage {
    if (!_thumbnailImage) {
        _thumbnailImage = [[UIImageView alloc] init];
        _thumbnailImage.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailImage.clipsToBounds = YES;
    }
    return _thumbnailImage;
}

- (UILabel *)titleName {
    if (!_titleName) {
        _titleName = [[UILabel alloc] init];
        _titleName.font = [UIFont systemFontOfSize:14];
        _titleName.numberOfLines = 0;
    }
    return _titleName;
}
@end
