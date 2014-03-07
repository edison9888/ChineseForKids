//
//  UIButton+WebCache.m
//  AnQu
//
//  Created by TGBUS on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIButton+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIButton (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    for(UIView *view in [self subviews])
    {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            return;
        }
    }
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake((self.bounds.size.width - activityIndicatorView.bounds.size.width) /2, (self.bounds.size.height - activityIndicatorView.bounds.size.height) /2, activityIndicatorView.bounds.size.width,activityIndicatorView.bounds.size.height);
    activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    activityIndicatorView.tag =999;
    [activityIndicatorView startAnimating];
    [self addSubview:activityIndicatorView];
    [activityIndicatorView release];
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
//    self.image = placeholder;
//    self.imageView.image=placeholder;
    [self setBackgroundImage:placeholder forState:UIControlStateNormal];
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    UIActivityIndicatorView *view=(UIActivityIndicatorView *)[self viewWithTag:999];
    if(view)
    {
        [view stopAnimating];
        [view removeFromSuperview];
    }

    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    //    self.image=[ImageHelper createRoundedRectImage:image size:CGSizeMake(64, 64)];
//    self.image=image;

    UIActivityIndicatorView *view=(UIActivityIndicatorView *)[self viewWithTag:999];
    if(view)
    {
        [view stopAnimating];
        [view removeFromSuperview];
    }

    [self setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    UIActivityIndicatorView *view=(UIActivityIndicatorView *)[self viewWithTag:999];
    if(view)
    {
        [view stopAnimating];
        [view removeFromSuperview];
    }

}

@end
