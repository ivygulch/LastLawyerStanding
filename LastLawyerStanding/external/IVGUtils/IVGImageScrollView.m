//
//  IVGImageScrollView.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 6/12/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGImageScrollView.h"

@implementation IVGImageScrollView

- (void) setupInstance {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;        
    self.automaticMaximumScale = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setupInstance];
    }
    return self;
}

- (void) awakeFromNib {
    [self setupInstance];
}

#pragma mark -
#pragma mark Override touch handling to double tab zoom in/2-finger tap to zoom out

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an offset so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)handleDoubleTap:(CGPoint) centerPt {
    // double tap zooms in
    if (self.zoomScale < self.maximumZoomScale) {
        float newScale = self.zoomScale * kIVGImageScrollView_TapZoomStep;
        if (newScale > self.maximumZoomScale) {
            newScale = self.maximumZoomScale;
        }
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:centerPt];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (void)handleTwoFingerTap:(CGPoint) centerPt {
    // two-finger tap zooms out
    if (self.zoomScale > self.minimumZoomScale) {
        float newScale = self.zoomScale / kIVGImageScrollView_TapZoomStep;
        if (newScale < self.minimumZoomScale) {
            newScale = self.minimumZoomScale;
        }
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:centerPt];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (void)handleTwoFingerDoubleTap:(CGPoint) centerPt {
    // two-finger double tap zooms all the way back out
    if (self.zoomScale > self.minimumZoomScale) {
        CGRect zoomRect = [self zoomRectForScale:self.minimumZoomScale withCenter:centerPt];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGPoint) averageLocationInView:(UIView *) view forTouches:(NSSet *) touches {
    CGFloat totalX = 0.0;
    CGFloat totalY = 0;
    for (UITouch *touch in touches) {
        CGPoint pt = [touch locationInView:view];
        totalX += pt.x;
        totalY += pt.y;
    }
    return CGPointMake(totalX / [touches count], totalY / [touches count]);
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.dragging) {
        [super touchesEnded: touches withEvent: event];
        return;        
    }
    
    if(touches.count == 1) {  
        UITouch *touch =[touches anyObject];
        if([touch tapCount] == 2) {
            [self handleDoubleTap:[touch locationInView:self.imageView]];
        }
    } else if(touches.count == 2) {
        UITouch *touch =[touches anyObject];
        if ([touch tapCount] == 1) {
            [self handleTwoFingerTap:[self averageLocationInView:self.imageView forTouches:touches]];
        } else if ([touch tapCount] == 2) {
            [self handleTwoFingerDoubleTap:[self averageLocationInView:self.imageView forTouches:touches]];
        }
    }
}


#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.imageView.frame = frameToCenter;
    
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.secondaryDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.secondaryDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.secondaryDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.secondaryDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.secondaryDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.secondaryDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.secondaryDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.secondaryDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.secondaryDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.secondaryDelegate scrollViewShouldScrollToTop:scrollView];
    } else {
        return NO;
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if ([self.secondaryDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.secondaryDelegate scrollViewDidScrollToTop:scrollView];
    }
}

#pragma mark -
#pragma mark Configure scrollView to display new image (tiled or not)

- (UIImage *) image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    // clear the previous imageView
    [self.imageView removeFromSuperview];
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    // make a new UIImageView for the new image
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:self.imageView];
    
    self.contentSize = [image size];
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible

    if (self.automaticMaximumScale) {
        // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
        // maximum zoom scale to 0.5.
        CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
        
        self.maximumZoomScale = maxScale;
    }
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > self.maximumZoomScale) {
        minScale = self.maximumZoomScale;
    }
    self.minimumZoomScale = minScale;
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

// returns the center point, in image coordinate space, to try to restore after rotation. 
- (CGPoint)pointToCenterAfterRotation
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:self.imageView];
}

// returns the zoom scale to attempt to restore after rotation. 
- (CGFloat)scaleToRestoreAfterRotation
{
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
        contentScale = 0;
    
    return contentScale;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
{    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:self.imageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, 
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}

@end
