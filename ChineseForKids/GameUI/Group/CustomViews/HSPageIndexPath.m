//
//  HSPageIndexPath.m
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "HSPageIndexPath.h"

@implementation HSPageIndexPath
@synthesize section = _section;
@synthesize page = _page;
@synthesize row = _row;

- (id)initWithRow:(int)aRow section:(int)aSection page:(int)aPage
{
    if (self = [super init])
    {
        _row = aRow;
        _section = aSection;
        _page = aPage;
    }
    return self;
}

+ (id)indexPathForRow:(int)aRow section:(int)aSection page:(int)aPage
{
#if __has_feature(objc_arc)
    return [[self alloc] initWithRow:aRow section:aSection page:aPage];
#else
    return [[[self alloc] initWithRow:aRow section:aSection page:aPage] autorelease];
#endif
}

+ (id)indexPathForPage:(int)aPage indexPath:(NSIndexPath *)aIndexPath
{
#if __has_feature(objc_arc)
    return [[self alloc] initWithRow:aIndexPath.row section:aIndexPath.section page:aPage];
#else
    return [[[self alloc] initWithRow:aIndexPath.row section:aIndexPath.section page:aPage] autorelease];
#endif
}

@end
