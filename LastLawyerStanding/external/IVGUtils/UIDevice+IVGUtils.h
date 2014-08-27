//
//  UIDevice+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/20/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIInterfaceOrientationIsLandscapeOrPortrait(orientation)  ((orientation) == UIInterfaceOrientationPortrait  || (orientation) == UIInterfaceOrientationPortraitUpsideDown || (orientation) == UIInterfaceOrientationLandscapeLeft  || (orientation) == UIInterfaceOrientationLandscapeRight)
#define RUNNING_ON_IOS7 ([UIDevice systemVersionAsFloat] >= 7.0)

@interface UIDevice (IVGUtils)

- (NSString *)machine;
- (BOOL) isLimitedMachine;

+ (BOOL) isRunningOniPad;
+ (BOOL) isRunningOnSimulator;
+ (BOOL) isDevicePortrait;
+ (BOOL) isDeviceLandscape;
+ (UIDeviceOrientation) deviceOrientation;
+ (CGFloat) systemVersionAsFloat;

@end
