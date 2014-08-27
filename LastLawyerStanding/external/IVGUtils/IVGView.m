//
//  IVGView.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 12/5/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+IVGCustomProperties.h"

@interface IVGView()
@end

@implementation IVGView

- (UIColor *) borderColor;
{
    return self.backing_borderColor;
}

- (void) setBorderColor:(UIColor *)borderColor;
{
    self.backing_borderColor = borderColor;
}

- (CGFloat) borderWidth;
{
    return self.backing_borderWidth;
}

- (void) setBorderWidth:(CGFloat)borderWidth;
{
    self.backing_borderWidth = borderWidth;
}

- (CGFloat)cornerRadius;
{
    return self.backing_cornerRadius;
}

- (void) setCornerRadius:(CGFloat)cornerRadius;
{
    self.backing_cornerRadius = cornerRadius;
}

@end
