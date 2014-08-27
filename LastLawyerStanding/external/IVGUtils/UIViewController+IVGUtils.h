//
//  UIViewController+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/23/12.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerChildRotationProtocol <NSObject>
@optional
- (BOOL) shouldChildRotate;
- (NSUInteger)supportedChildInterfaceOrientations;
- (UIInterfaceOrientation)preferredChildInterfaceOrientationForPresentation;
@end

@interface UIViewController (IVGUtils)

- (void) enumerateAncestorViewControllers:(void (^)(UIViewController *viewController, UIViewController *ancestorViewController, BOOL *stop))block;
- (NSString *) parentViewControllersDescription;
- (void) removeChildViewControllersOfClass:(Class) viewControllerClass;
- (void) removeAllChildViewControllers;

- (UIViewController *) actualTopViewController;

- (BOOL) isPortrait;
- (BOOL) isLandscape;

@end
