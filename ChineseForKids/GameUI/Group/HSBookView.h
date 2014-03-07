//
//  HSBookView.h
//  ChineseForKids
//
//  Created by yang on 13-12-23.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBooksListView.h"
#import "CMPopTipView.h"

@protocol HSBookViewDelegate;

@interface HSBookView : UIView<CMPopTipViewDelegate, HSBooksListViewDelegate>

@property (nonatomic, unsafe_unretained)id<HSBookViewDelegate>delegate;
@property (nonatomic, readwrite)CGPoint coverCerter;
@property (nonatomic, strong)UIImage *imgCover;

@end

@protocol HSBookViewDelegate <NSObject>

@required
- (void)bookView:(HSBookView *)view close:(id)sender;
- (void)bookView:(HSBookView *)view selectedBookWithBookID:(NSInteger)bookID;

@end