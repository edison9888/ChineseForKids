//
//  HSComicBookCoverView.m
//  ChineseForKids
//
//  Created by yang on 13-10-14.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "HSComicBookCoverView.h"

@implementation HSComicBookCoverView
{
    UIImage *imgCover;
}


- (id)initWithFrame:(CGRect)frame GroupID:(NSInteger)groupID ImageURL:(NSString *)imgURL
{
    self = [super initWithFrame:frame];
    if (self) {
        _groupID = groupID;
        _imageURL = imgURL;
    }
    return self;
}

- (void)initInterface
{
    
}

- (void)drawRect:(CGRect)rect
{
    //[imgCover drawInRect:self.bounds];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    imgCover = nil;
}

@end
