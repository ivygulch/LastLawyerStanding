//
//  UIView+IVGCustomProperties.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 12/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "UIView+IVGCustomProperties.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "NSObject+IVGUtils.h"
#import "NSArray+IVGUtils.h"
#import "UIColor+IVGUtils.h"
#import "IVGUtils.h"

NSArray* CGColorArray(NSArray *colors) {
    return [colors arrayByTransforming:^(id color) {
        return (id) [color CGColor];
    }];
}

@interface UIView()
@property (nonatomic,assign) BOOL original_backgroundView_set;
@property (nonatomic,weak) UIView *original_backgroundView;
@property (nonatomic,weak) UIView *backing_backgroundView;
@property (nonatomic,assign,readonly) BOOL backing_highlighted;
@end

@implementation UIView (IVGCustomProperties)

- (BOOL) isGradientLayer;
{
    return [self.layer isKindOfClass:[CAGradientLayer class]];
}

- (CAGradientLayer *) gradientLayer;
{
    return self.isGradientLayer ? (CAGradientLayer *) self.layer : nil;
}

- (CGFloat) backing_cornerRadius;
{
    return [self associatedFloatValueForKey:@"backing_cornerRadius"];
}

- (void) setBacking_cornerRadius:(CGFloat) backing_cornerRadius;
{
    [self setAssociatedFloatValue:backing_cornerRadius forKey:@"backing_cornerRadius"];
    self.layer.cornerRadius = backing_cornerRadius;
}

- (CGFloat) backing_borderWidth;
{
    return [self associatedFloatValueForKey:@"backing_borderWidth"];
}

- (void) setBacking_borderWidth:(CGFloat) backing_borderWidth;
{
    [self setAssociatedFloatValue:backing_borderWidth forKey:@"backing_borderWidth"];
    self.layer.borderWidth = backing_borderWidth;
}

- (UIColor *) backing_borderColor;
{
    return [self associatedUserInfoObjectForKey:@"backing_borderColor"];
}

- (void) setBacking_borderColor:(UIColor *)backing_borderColor;
{
    [self setAssociatedUserInfoObject:backing_borderColor forKey:@"backing_borderColor"];
    self.layer.borderColor = [backing_borderColor CGColor];
}

- (BOOL) original_backgroundView_set;
{
    return [[self associatedUserInfoObjectForKey:@"original_backgroundView_set"] boolValue];
}

- (void) setOriginal_backgroundView_set:(BOOL)original_backgroundView_set;
{
    [self setAssociatedUserInfoObject:@(original_backgroundView_set) forKey:@"original_backgroundView_set"];
}

- (UIView *) original_backgroundView;
{
    return [self associatedUserInfoObjectForKey:@"original_backgroundView"];
}

- (void) setOriginal_backgroundView:(UIView *)original_backgroundView;
{
    [self setAssociatedUserInfoObject:original_backgroundView forKey:@"original_backgroundView"];
}

- (UIView *) backing_backgroundView;
{
    if ([self respondsToSelector:@selector(backgroundView)]) {
        return [self performSelector:@selector(backgroundView)];
    } else {
        return nil;
    }
}

- (void) setBacking_backgroundView:(UIView *)backing_backgroundView;
{
    if (!self.original_backgroundView_set) {
        self.original_backgroundView_set = YES;
        self.original_backgroundView = self.backing_backgroundView;
    }
    if ([self respondsToSelector:@selector(setBackgroundView:)]) {
        [self performSelector:@selector(setBackgroundView:) withObject:backing_backgroundView];
    }
}

- (BOOL) backing_highlighted;
{
    BOOL result = NO;
    if ([self respondsToSelector:@selector(isHighlighted)]) {
        result = [(id)self isHighlighted];
    }
    return result;
}

- (void) updateColors;
{
    NSArray *colors = (self.backing_highlighted && (self.backing_highlightColors != nil)) ? self.backing_highlightColors : self.backing_colors;

    if ([colors count] == 0) {
        if (self.original_backgroundView_set) {
            self.backing_backgroundView = self.original_backgroundView;
        }
    } else if (self.isGradientLayer && ([colors count] > 1)) {
        self.gradientLayer.colors = CGColorArray(colors);
        self.backgroundColor = [UIColor clearColor];
        self.backing_backgroundView = nil;
    } else {
        self.gradientLayer.colors = nil;
        self.backgroundColor = [colors objectAtIndex:0];
        self.backing_backgroundView = nil;
    }
}

- (NSArray *) backing_colors;
{
    return [self associatedUserInfoObjectForKey:@"backing_colors"];
}

- (void) setBacking_colors:(NSArray *) backing_colors;
{
    [self setAssociatedUserInfoObject:backing_colors forKey:@"backing_colors"];
    [self updateColors];
}

- (NSArray *) backing_highlightColors;
{
    return [self associatedUserInfoObjectForKey:@"backing_highlightColors"];
}

- (void) setBacking_highlightColors:(NSArray *) backing_highlightColors;
{
    [self setAssociatedUserInfoObject:backing_highlightColors forKey:@"backing_highlightColors"];
    [self updateColors];
}

@end
