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
@property (nonatomic, strong) UIActivityIndicatorView *indicator; /**< 小菊花*/

@property (nonatomic, strong) NSString *cellId; /**< 标识*/

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
    
    self.indicator.center = CGPointMake(self.thumbnailImage.width/2, self.thumbnailImage.height/2);
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
- (UIImage *)cacheImageWithName:(NSString *)imgPath {
    
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    [self cacheSmallImage:image];
    
    return image;
}

- (void)cacheSmallImage:(UIImage *)img {
    CGSize newSize = CGSizeMake(100, self.height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *path = NSHomeDirectory();
    NSString *Pathimg = [path stringByAppendingString:[NSString stringWithFormat:@"/SmallThumbnailImage/%@",self.file.fileName]];
    [UIImagePNGRepresentation(newImage) writeToFile:Pathimg atomically:YES];
    
    self.file.smallFilePath = Pathimg;
}

#pragma mark - setting
- (void)setFile:(R_FileModel *)file {
    
    _file = file;
    
    [self.indicator startAnimating];
    
    self.titleName.text = file.fileName;
    
    if ([file.fileType isEqualToString:@"jpeg"] || [file.fileType isEqualToString:@"jpg"] || [file.fileType isEqualToString:@"png"]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [weakSelf cacheImageWithName:file.filePath];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self.indicator stopAnimating];
//
//                self.thumbnailImage.image = image;
//            });
        });
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
        
        [_thumbnailImage addSubview:self.indicator];
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

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [_indicator startAnimating];
    }
    return _indicator;
}

@end
