//
//  UIButton+R_Category.m
//  R_category
//
//  Created by rzk on 2017/10/10.
//  Copyright © 2017年 rzk. All rights reserved.
//

#import "UIButton+R_Category.h"

@implementation UIButton (R_Category)

- (void)setImageAndTitleLabelVertical{
    
    if (!self.titleLabel.text || self.titleLabel.text.length == 0 || !self.imageView.image) {
        return;
    }
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + 5);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

- (void)setImageToRight
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width+2.5, 0.0, -titleSize.width-2.5);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width-2.5, 0.0, imageSize.width+2.5);
}

@end
