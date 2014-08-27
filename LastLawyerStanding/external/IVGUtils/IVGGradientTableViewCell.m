//
//  IVGGradientTableViewCell.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 4/17/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGGradientTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+IVGCustomProperties.h"

@implementation IVGGradientTableViewCell

+ (Class) layerClass;
{
    return [CAGradientLayer class];
}

- (NSArray *) colors;
{
    return self.backing_colors;
}

- (void) setColors:(NSArray *)colors;
{
    self.backing_colors = colors;
}

@end
