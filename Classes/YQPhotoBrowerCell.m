//
//  YQPhotoBrowerCell.m
//  YQPhotoBrower
//
//  Created by Leaf on 14-10-10.
//  Copyright (c) 2014年 Leaf. All rights reserved.
//

#import "YQPhotoBrowerCell.h"
#import "YQPotoBrowerController.h"


@implementation YQPhotoBrowerCell

- (void)awakeFromNib {
    // Initialization code
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
//    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *oneTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewOneTapped:)];
    oneTapRecognizer.numberOfTapsRequired = 1;
    [oneTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
//    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:oneTapRecognizer];
}



-(void)reset{
    
    CGRect zoomRect = [self zoomRectForScale:self.scrollView.minimumZoomScale withCenter:CGPointMake(self.scrollView.bounds.size.width/2, self.scrollView.bounds.size.height/2)];
    [self.scrollView zoomToRect:zoomRect animated:NO];
//    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
//    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
//    self.imgView.center = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.bounds.size.height/2);
}
- (void)scrollViewOneTapped:(UITapGestureRecognizer*)recognizer {
    
    [self.viewController showOrHideStatusBar:YES];
}
- (void)scrollViewDoubleTapped:(UIGestureRecognizer *)gesture
{
    if(self.scrollView.zoomScale != self.scrollView.minimumZoomScale){
        CGRect zoomRect = [self zoomRectForScale:self.scrollView.minimumZoomScale withCenter:CGPointMake(self.scrollView.bounds.size.width/2, self.scrollView.bounds.size.height/2)];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }else{
       
        CGRect zoomRect = [self zoomRectForScale:self.scrollView.maximumZoomScale withCenter:[gesture locationInView:gesture.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [scrollView setZoomScale:scale animated:NO];
    
}
@end
