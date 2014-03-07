//
//  HSComicBookCoverView.h
//  ChineseForKids
//
//  Created by yang on 13-10-14.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSComicBookCoverView : UIButton

- (id)initWithFrame:(CGRect)frame GroupID:(NSInteger)groupID ImageURL:(NSString *)imgURL;

@property (nonatomic, readwrite)NSInteger groupID;
@property (nonatomic, strong)NSString *imageURL;

@end
