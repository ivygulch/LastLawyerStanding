//
//  IVGGradientButton.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 4/17/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGGradientButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+IVGCustomProperties.h"

@interface IVGGradientButton()
@end

@implementation IVGGradientButton

+ (Class) layerClass;
{
    return [CAGradientLayer class];
}

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

- (NSArray *) colors;
{
    return self.backing_colors;
}

- (void) setColors:(NSArray *)colors;
{
    self.backing_colors = colors;
}

- (NSArray *) highlightColors;
{
    return self.backing_highlightColors;
}

- (void) setHighlightColors:(NSArray *)highlightColors;
{
    self.backing_highlightColors = highlightColors;
}

- (void) setHighlighted:(BOOL)highlighted;
{
    [super setHighlighted:highlighted];
    [self updateColors];
}

@end
