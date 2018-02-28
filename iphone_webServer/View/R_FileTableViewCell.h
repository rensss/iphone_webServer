//
//  R_FileTableViewCell.h
//  iphone_webServer
//
//  Created by MBP on 2018/2/28.
//  Copyright © 2018年 rzk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "R_FileModel.h"

@interface R_FileTableViewCell : UITableViewCell

@property (nonatomic, strong) R_FileModel *file; /**< 当前文件*/
@property (nonatomic, assign) BOOL isEditing; /**< 是否编辑状态*/

@end
