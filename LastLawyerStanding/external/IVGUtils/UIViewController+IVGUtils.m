//
//  UIViewController+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/23/12.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import "UIViewController+IVGUtils.h"
#import "UIView+IVGUtils.h"

@implementation UIViewController (IVGUtils)

- (void) enumerateAncestorViewControllers:(void (^)(UIViewController *viewController, UIViewController *ancestorViewController, BOOL *stop))block;
{
    UIViewController *vc = self.parentViewController;
    BOOL stop = NO;
    while (vc && !stop) {
        block(self, vc, &stop);
    }
}

- (NSString *) parentViewControllersDescription;
{
    NSString *result = @"";
    NSString *sep = @"";
    UIViewController *vc = self;
    NSString *margin = @"";
    while (vc) {
        result = [NSString stringWithFormat:@"%@%@%@%@", result, sep, margin, vc];
        vc = vc.parentViewController;
        margin = [NSString stringWithFormat:@"%@    ", margin];
        sep = @"\n";
    }
    return result;
}

- (void) removeChildViewControllersOfClass:(Class) viewControllerClass;
{
    NSArray *childViewControllers = [self childViewControllers];
    for (UIViewController *childViewController in childViewControllers) {
        if ([childViewController isKindOfClass:viewControllerClass]) {
            [childViewController willMoveToParentViewController:nil];
            [childViewController removeFromParentViewController];
            [childViewController.view removeFromSuperview];
            childViewController.view = nil;
        }
    }
}

- (void) removeAllChildViewControllers;
{
    [self removeChildViewControllersOfClass:[UIViewController class]];
}

- (UIViewController *) actualTopViewController;
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self topViewController] actualTopViewController];
    } else if ([self isKindOfClass:[UITabBarController class]]) {
        return [[(UITabBarController *)self selectedViewController] actualTopViewController];
    } else {
        return self;
    }
}

- (BOOL) isPortrait;
{
    return UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
}

- (BOOL) isLandscape;
{
    return UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
}

@end
