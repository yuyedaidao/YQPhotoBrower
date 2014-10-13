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
    
    [self.scrollView zoomToRect:self.bounds animated:NO];
}
- (void)scrollViewOneTapped:(UITapGestureRecognizer*)recognizer {
    
    [self.viewController showOrHideStatusBar:YES];
}
- (void)scrollViewDoubleTapped:(UIGestureRecognizer *)gesture
{
    if(self.scrollView.zoomScale != 1.0f){
        CGRect zoomRect = [self zoomRectForScale:1.0f withCenter:[gesture locationInView:gesture.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }else{
        float newScale = 2.0f;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
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
