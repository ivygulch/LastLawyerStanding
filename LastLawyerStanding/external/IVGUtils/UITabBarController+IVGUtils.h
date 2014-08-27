//
//  UITabBarController+IVGUtils.h
//  MyFactor
//
//  Created by Douglas Sjoquist on 8/27/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (IVGUtils)

@property (nonatomic,assign) BOOL tabBarHidden;

- (void) setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL) animated;

@end
