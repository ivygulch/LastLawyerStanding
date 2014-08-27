//
//  UIColor+IVGUtils.m
//  MyFactor
//
//  Created by Douglas Sjoquist on 4/17/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "UIColor+IVGUtils.h"

CG_INLINE CGFloat valueWithBrightnessFactor(CGFloat v, CGFloat factor) {
    if (factor < 0) {
        return MAX(0,v*(1+factor));
    } else {
        CGFloat remaining = (1-v);
        return MIN(1,v+remaining*(factor));
    }
}

@implementation UIColor (IVGUtils)

- (UIColor *) colorWithBrightnessFactor:(CGFloat) factor;
{
    CGFloat r = 0.0;
    CGFloat g = 0.0;
    CGFloat b = 0.0;
    CGFloat a = 0.0;
    [self getRed:&r green:&g blue:&b alpha:&a];

    CGFloat newR = valueWithBrightnessFactor(r,factor);
    CGFloat newG = valueWithBrightnessFactor(g,factor);
    CGFloat newB = valueWithBrightnessFactor(b,factor);

    return [UIColor colorWithRed:newR green:newG blue:newB alpha:a];
}
@end
