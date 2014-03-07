//
//  HSLibraryCustomCell.m
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "HSLibraryCustomCell.h"

@implementation HSLibraryCustomCell
{
    UIImage *imgBackGround;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    imgBackGround = [UIImage imageNamed:@"bookshelf.png"];
	[imgBackGround drawInRect:self.bounds];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    imgBackGround = nil;
}

@end
