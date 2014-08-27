//
//  UIView+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/23/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import "UIView+IVGUtils.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation UIView(IVGUtils)

static NSString *VIEW_OWNER_ASSOCOBJ_KEY = @"com.ivygulch.VIEW_OWNER_KEY";

- (NSString *) superviewDescription {
    NSString *result = @"";
    NSString *sep = @"";
    UIView *v = self;
    NSString *margin = @"";
    while (v) {
        result = [NSString stringWithFormat:@"%@%@%@%@", result, sep, margin, v];
        v = v.superview;
        margin = [NSString stringWithFormat:@"%@    ", margin];
        sep = @"\n";
    }    
    return result;
}

- (id) findFirstViewInHierarchyWithKindOfClass: (Class) clazz {
    UIView *v = self;
    while (v) {
        if ([v isKindOfClass:clazz]) {
            return v;
        }
        v = v.superview;
    }    
    return nil;
}

- (void) logSizes:(NSString *) desc {
        NSLog(@"%@: f=[%0.1f,%0.1f %0.1f,%0.1f]  b=[%0.1f,%0.1f %0.1f,%0.1f]  c=[%0.1f,%0.1f]", 
              desc, 
              self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height,
              self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height,
              self.center.x, self.center.y
              );
}

- (void) removeAllGestureRecognizers {
    NSArray *recognizers = [NSArray arrayWithArray:self.gestureRecognizers];
    for (UIGestureRecognizer *recognizer in recognizers) {
        [self removeGestureRecognizer:recognizer];
    }
}

- (void) setOriginYBelow:(UIView *) baseView withGap:(CGFloat) gap;
{
    if (!baseView || baseView.hidden) {
        return; // do nothing
    }
    self.frame = (CGRect) {
        {self.frame.origin.x, baseView.frame.origin.y + baseView.bounds.size.height + gap},
        self.bounds.size
    };
}

- (CGFloat) bottom;
{
    return self.frame.origin.y + self.bounds.size.height;
}

- (CGFloat) bottomOfLowestSubview;
{
    return [UIView bottomOfLowestView:self.subviews];
}

- (CGFloat) topOfHighestSubview;
{
    return [UIView topOfHighestView:self.subviews];
}

+ (void) updateFrame:(UIView *) view x:(CGFloat) x {
    view.frame = (CGRect) {{x, view.frame.origin.y}, view.frame.size};
}

+ (void) updateFrame:(UIView *) view w:(CGFloat) w {
    view.frame = (CGRect) {view.frame.origin, {w, view.frame.size.height}};
}

+ (CGFloat) bottomOfLowestView:(NSArray *) views;
{
    CGFloat bottom = 0;
    for (UIView *view in views) {
        if (!view.hidden) {
            bottom = MAX(bottom, [view bottom]);
        }
    }
    return bottom;
}

+ (CGFloat) topOfHighestView:(NSArray *) views;
{
    CGFloat top = CGFLOAT_MAX;
    for (UIView *view in views) {
        if (!view.hidden) {
            top = MIN(top, view.frame.origin.y);
        }
    }
    return (top == CGFLOAT_MAX) ? 0 : top;
}

- (void) removeAllSubviews;
{
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

+ (id) findFirstViewInHiearchyWith:(id) item kindOfClass: (Class) clazz;
{
    if ([item isKindOfClass:[UIView class]]) {
        return [item findFirstViewInHierarchyWithKindOfClass:clazz];
    } else {
        return nil;
    }
}

- (CGRect) absoluteFrame;
{
    CGRect frame = self.frame;
    frame.origin = [self absoluteOrigin];
    return frame;
}

- (CGPoint) absoluteOrigin;
{
    CGPoint origin = self.frame.origin;
    UIView *view = self.superview;
    while (view != nil) {
        origin.x += view.frame.origin.x;
        origin.y += view.frame.origin.y;
        view = view.superview;
    }
    return origin;
}

- (UIView *) findFirstResponder;
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subview in self.subviews) {
        UIView *result = [subview findFirstResponder];
        if (result) {
            return result;
        }
    }
    return nil;
}

- (UIView *) findFirstResponderInView:(UIView*) view
{
    if (view.isFirstResponder) {
        return view;
    }
    for (UIView *subview in view.subviews) {
        UIView *result = [subview findFirstResponderInView:subview];
        if (result) {
            return result;
        }
    }
    return nil;
}

- (id) viewOwnerFor:(UIView *) view;
{
    return objc_getAssociatedObject(view, (__bridge const void *) VIEW_OWNER_ASSOCOBJ_KEY);
}

- (id) viewOwner;
{
    UIView *view = self;
    while (view != nil) {
        id result = [self viewOwnerFor:view];
        if (result) {
            return result;
        }
        view = view.superview;
    }
    return nil;
}

- (void) setViewOwner:(id) viewOwner;
{
    // needs to be a weak reference so we avoid a retain cycle between the view and it's controller/owner
    objc_setAssociatedObject(self, (__bridge const void *)  VIEW_OWNER_ASSOCOBJ_KEY, viewOwner, OBJC_ASSOCIATION_ASSIGN);
}

- (void) positionSubview:(UIView *) view horizontalAlignment:(UIViewHorizontalAlignment) horizontalAlignment verticalAlignment:(UIViewVerticalAlignment) verticalAlignment width:(CGFloat) width height:(CGFloat) height;
{
    CGSize svSize = self.bounds.size;
    CGFloat x = view.frame.origin.x;
    CGFloat y = view.frame.origin.y;
    CGFloat w = width;
    CGFloat h = height;
    UIViewAutoresizing autoresizingMask = UIViewAutoresizingNone;

    switch (verticalAlignment) {
        case UIViewVerticalAlignmentNone: {
            break;
        }
        case UIViewVerticalAlignmentTop: {
            y = 0;
            autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
        case UIViewVerticalAlignmentCenter: {
            y = (svSize.height - h) / 2;
            break;
        }
        case UIViewVerticalAlignmentFull: {
            y = 0;
            h = svSize.height;
            autoresizingMask |= UIViewAutoresizingFlexibleHeight;
            break;
        }
        case UIViewVerticalAlignmentBottom: {
            y = svSize.height - h;
            autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
            break;
        }
    }
    
    switch(horizontalAlignment) {
        case UIViewHorizontalAlignmentNone: {
            break;
        }
        case UIViewHorizontalAlignmentLeft: {
            x = 0;
            autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
            break;
        }
        case UIViewHorizontalAlignmentCenter: {
            x = (svSize.width - w) / 2;
            break;
        }
        case UIViewHorizontalAlignmentFull: {
            x = 0;
            w = svSize.width;
            autoresizingMask |= UIViewAutoresizingFlexibleWidth;
            break;
        }
        case UIViewHorizontalAlignmentRight: {
            x = svSize.width - w;
            autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
            break;
        }
    }
    
    view.autoresizingMask = autoresizingMask;
    view.frame = CGRectMake(x,y,w,h);
}

- (void) positionSubview:(UIView *) view horizontalAlignment:(UIViewHorizontalAlignment) horizontalAlignment verticalAlignment:(UIViewVerticalAlignment) verticalAlignment;
{
    [self positionSubview:view horizontalAlignment:horizontalAlignment verticalAlignment:verticalAlignment width:view.bounds.size.width height:view.bounds.size.height];
}

- (void) positionSubviewAtTop:(UIView *) view withHeight:(CGFloat) height;
{
    [self positionSubview:view horizontalAlignment:UIViewHorizontalAlignmentFull verticalAlignment:UIViewVerticalAlignmentTop width:0 height:height];
}

- (void) positionSubviewAtBottom:(UIView *) view withHeight:(CGFloat) height;
{
    [self positionSubview:view horizontalAlignment:UIViewHorizontalAlignmentFull verticalAlignment:UIViewVerticalAlignmentBottom width:0 height:height];
}

- (void) positionSubviewAtLeft:(UIView *) view withWidth:(CGFloat) width;
{
    [self positionSubview:view horizontalAlignment:UIViewHorizontalAlignmentLeft verticalAlignment:UIViewVerticalAlignmentFull width:width height:0];
}

- (void) positionSubviewAtRight:(UIView *) view withWidth:(CGFloat) width;
{
    [self positionSubview:view horizontalAlignment:UIViewHorizontalAlignmentRight verticalAlignment:UIViewVerticalAlignmentFull width:width height:0];
}

- (void) positionSubviewFull:(UIView *) view;
{
    [self positionSubview:view horizontalAlignment:UIViewHorizontalAlignmentFull verticalAlignment:UIViewVerticalAlignmentFull];
}

- (void) addSubview:(UIView *) view horizontalAlignment:(UIViewHorizontalAlignment) horizontalAlignment verticalAlignment:(UIViewVerticalAlignment) verticalAlignment width:(CGFloat) width height:(CGFloat) height;
{
    [self positionSubview:view horizontalAlignment:horizontalAlignment verticalAlignment:verticalAlignment width:width height:height];
    [self addSubview:view];
}

- (void) addSubview:(UIView *) view horizontalAlignment:(UIViewHorizontalAlignment) horizontalAlignment verticalAlignment:(UIViewVerticalAlignment) verticalAlignment;
{
    [self positionSubview:view horizontalAlignment:horizontalAlignment verticalAlignment:verticalAlignment];
    [self addSubview:view];
}

- (void) addSubviewToTop:(UIView *) view withHeight:(CGFloat) height;
{
    [self positionSubviewAtTop:view withHeight:height];
    [self addSubview:view];
}

- (void) addSubviewToBottom:(UIView *) view withHeight:(CGFloat) height;
{
    [self positionSubviewAtBottom:view withHeight:height];
    [self addSubview:view];
}

- (void) addSubviewToLeft:(UIView *) view withWidth:(CGFloat) width;
{
    [self positionSubviewAtLeft:view withWidth:width];
    [self addSubview:view];
}

- (void) addSubviewToRight:(UIView *) view withWidth:(CGFloat) width;
{
    [self positionSubviewAtRight:view withWidth:width];
    [self addSubview:view];
}

- (void) addSubviewFull:(UIView *) view;
{
    [self positionSubviewFull:view];
    [self addSubview:view];
}

- (NSString *) debugString;
{
    return [NSString stringWithFormat:@"sz=%.0f,%.0f %.0f,%.0f",
            self.frame.origin.x, self.frame.origin.y,
            self.frame.size.width, self.frame.size.height];
}

- (void) appendDebugHierarchyTo:(NSMutableString *) ms withOffset:(CGPoint) offset pointToCheck:(CGPoint) pointToCheck margin:(NSString *) margin;
{
    CGRect f = self.frame;
    CGRect fo = CGRectMake(f.origin.x+offset.x,f.origin.y+offset.y,f.size.width,f.size.height);

    BOOL checkInside = !CGPointEqualToPoint(pointToCheck, CGPointZero);

    BOOL inside = CGRectContainsPoint(fo,pointToCheck);
    
    if (!checkInside || inside) {
        if ([ms length] > 0) {
            [ms appendString:@"\n"];
        }
        
        [ms appendString:margin];
        [ms appendString:NSStringFromClass([self class])];
        if (self.viewOwner) {
            [ms appendString:@"/"];
            [ms appendString:NSStringFromClass([self.viewOwner class])];
        }
        [ms appendFormat:@"<%p>  %.0f,%.0f,%.0f,%.0f (%.0f,%.0f,%.0f,%.0f)",
         self,
         f.origin.x, f.origin.y, f.size.width, f.size.height,
         fo.origin.x, fo.origin.y, fo.size.width, fo.size.height
         ];
        if (checkInside) {
            [ms appendFormat:@"  %.0f,%.0f", pointToCheck.x, pointToCheck.y];
        }
    }
    NSString *nextMargin = [margin stringByAppendingString:@"  "];
    CGPoint origin = self.frame.origin;
    CGPoint nextOffset = CGPointMake(offset.x+origin.x,offset.y+origin.y);
    for (UIView *sv in self.subviews) {
        [sv appendDebugHierarchyTo:ms withOffset:nextOffset pointToCheck:pointToCheck margin:nextMargin];
    }
}

- (NSString *) debugHierarchy:(CGPoint) pointToCheck;
{
    NSMutableString *ms = [NSMutableString string];
    CGPoint origin = self.frame.origin;
    [self appendDebugHierarchyTo:ms withOffset:CGPointMake(-origin.x,-origin.y) pointToCheck:pointToCheck margin:@""];
    return ms;
}

- (UIImage *) captureContentAsImage;
{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return viewImage;
}

#pragma mark - frame and bounds helper properties

- (CGPoint) frameOrigin;
{
    return self.frame.origin;
}

- (void) setFrameOrigin:(CGPoint)frameOrigin;
{
    self.frame = (CGRect) {frameOrigin,self.frame.size};
}

- (CGFloat) frameX;
{
    return self.frameOrigin.x;
}

- (void) setFrameX:(CGFloat)frameX;
{
    self.frameOrigin = CGPointMake(frameX,self.frame.origin.y);
}

- (CGFloat) frameY;
{
    return self.frameOrigin.y;
}

- (void) setFrameY:(CGFloat)frameY;
{
    self.frameOrigin = CGPointMake(self.frame.origin.x,frameY);
}

- (CGSize) frameSize;
{
    return self.frame.size;
}

- (void) setFrameSize:(CGSize)frameSize;
{
    self.frame = (CGRect) {self.frame.origin,frameSize};
}

- (CGFloat) frameWidth;
{
    return self.frame.size.width;
}

- (void) setFrameWidth:(CGFloat)frameWidth;
{
    self.frameSize = CGSizeMake(frameWidth,self.frame.size.height);
}

- (CGFloat) frameHeight;
{
    return self.frame.size.height;
}

- (void) setFrameHeight:(CGFloat)frameHeight;
{
    self.frameSize = CGSizeMake(self.frame.size.width,frameHeight);
}

#pragma mark - frameBottom & frameRight are easier ways to change margin

- (CGFloat) frameLeft;
{
    return self.frame.origin.x;
}

- (void) setFrameLeft:(CGFloat)frameLeft;
{
    CGFloat x = self.frame.origin.x;
    CGFloat w = self.frame.size.width;
    CGFloat diff = (frameLeft - x);
    self.frame = CGRectMake(frameLeft,self.frame.origin.y,w-diff,self.frame.size.height);
}

- (CGFloat) frameRight;
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setFrameRight:(CGFloat)frameRight;
{
    CGFloat x = self.frame.origin.x;
    CGFloat w = self.frame.size.width;
    CGFloat right = x + w;
    CGFloat diff = (frameRight - right);
    self.frame = CGRectMake(x,self.frame.origin.y,w+diff,self.frame.size.height);
}

- (CGFloat) frameTop;
{
    return self.frame.origin.y;
}

- (void) setFrameTop:(CGFloat)frameTop;
{
    CGFloat y = self.frame.origin.y;
    CGFloat h = self.frame.size.height;
    CGFloat diff = (frameTop - y);
    self.frame = CGRectMake(self.frame.origin.x,frameTop,self.frame.size.width,h-diff);
}

- (CGFloat) frameBottom;
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setFrameBottom:(CGFloat)frameBottom;
{
    CGFloat y = self.frame.origin.y;
    CGFloat h = self.frame.size.height;
    CGFloat bottom = y + h;
    CGFloat diff = (frameBottom - bottom);
    self.frame = CGRectMake(self.frame.origin.x,y,self.frame.size.width,h+diff);
}

@end
