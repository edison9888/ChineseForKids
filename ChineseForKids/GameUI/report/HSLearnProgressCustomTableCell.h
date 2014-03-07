//
//  HSLearnProgressCustomTableCell.h
//  HSChildrenLearnProgress
//
//  Created by yang on 13-9-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSLearnProgressCustomTableCell : UITableViewCell

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) CGFloat processAnimationDuration;

@end
