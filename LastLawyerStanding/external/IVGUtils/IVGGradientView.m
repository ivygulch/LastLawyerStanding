//
//  IVGGradientView.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 1/2/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGGradientView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+IVGCustomProperties.h"

@interface IVGGradientView()
@end

@implementation IVGGradientView

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
