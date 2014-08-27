//
//  UITabBarController+IVGUtils.m
//  MyFactor
//
//  Created by Douglas Sjoquist on 8/27/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "UITabBarController+IVGUtils.h"
#import "UIView+IVGUtils.h"

@implementation UITabBarController (IVGUtils)

- (BOOL) tabBarHidden;
{
    return self.tabBar.hidden;
}

- (void) setTabBarHidden:(BOOL)tabBarHidden;
{
    [self setTabBarHidden:tabBarHidden animated:NO];
}

- (void) setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL) animated;
{
    BOOL currentHidden = self.tabBarHidden;
    if (currentHidden == tabBarHidden) {
        return;
    }

    UIView *otherView = nil;
    for (UIView *subview in self.view.subviews) {
        if (![subview isEqual:self.tabBar]) {
            otherView = subview;
            break; // assume there are only two subviews
        }
    }
    CGFloat viewHeight = self.view.frameHeight;
    CGFloat tabBarHeight = self.tabBar.frameHeight;
    CGFloat otherViewNewHeight = currentHidden ? (viewHeight-tabBarHeight) : viewHeight;

    void(^animationBlock)() = ^{
        self.tabBar.hidden = tabBarHidden;
        otherView.frameHeight = otherViewNewHeight;
    };
    if (animated) {
        [UIView animateWithDuration:0.3 animations:animationBlock];
    } else {
        animationBlock();
    }
}

@end
