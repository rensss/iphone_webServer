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
        
        self.thumbnailImage.frame = CGRectMake(35, 0, 100, self.height);
        self.thumbnailImage.centerY = self.height / 2;
    }else {
        self.thumbnailImage.frame = CGRectMake(5, 0, 100, self.height);
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
