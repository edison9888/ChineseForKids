//
//  HSPageIndexPath.h
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSPageIndexPath : NSObject
{
    int _page;
    int _section;
    int _row;
}

@property (nonatomic, readwrite) int page;
@property (nonatomic, readwrite) int section;
@property (nonatomic, readwrite) int row;

- (id)initWithRow:(int)aRow section:(int)aSection page:(int)aPage;
+ (id)indexPathForRow:(int)aRow section:(int)aSection page:(int)aPage;
+ (id)indexPathForPage:(int)aPage indexPath:(NSIndexPath *)aIndexPath;

@end
