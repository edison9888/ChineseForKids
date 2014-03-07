/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
@implementation UIImageView (WebCache)


- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
    
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    for(UIView *view in [self subviews])
    {
        if(view.tag==999)
        {
            [view removeFromSuperview];
        }
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setTag:999];
    [self addSubview:view];
    [view release];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake((self.bounds.size.width - activityIndicatorView.bounds.size.width) /2, (self.bounds.size.height - activityIndicatorView.bounds.size.height) /2, activityIndicatorView.bounds.size.width,activityIndicatorView.bounds.size.height);
    activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [activityIndicatorView startAnimating];
    [view addSubview:activityIndicatorView];
    [activityIndicatorView release];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    UIView *view=(UIView *)[self viewWithTag:999];
    if(view)
    {
//        [view stopAnimating];
        [view removeFromSuperview];
    }
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error{
    self.image=[UIImage imageNamed:@"image_default.png"];
    UIView *view=(UIView *)[self viewWithTag:999];
    if(view)
    {
//        [view stopAnimating];
        [view removeFromSuperview];
    }
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
//    if(image.size.width>image.size.height&&image.size.height>200&&image.size.width>200&&[[UIDevice currentDevice]userInterfaceIdiom]!=UIUserInterfaceIdiomPad)
//    {
//        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 350, 257)];
//        [self setTransform:CGAffineTransformMakeRotation(M_PI/2)];
//        [self setFrame:CGRectMake(self.frame.origin.x-56.5, self.frame.origin.y+46.5, self.frame.size.width, self.frame.size.height)];
//    }

    UIView *view=(UIView *)[self viewWithTag:999];
    if(view)
    {
//        [view stopAnimating];
        [view removeFromSuperview];
    }
    self.image=image;
}

@end
