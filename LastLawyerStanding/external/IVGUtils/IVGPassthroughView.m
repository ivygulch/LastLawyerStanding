//
//  IVGPassthroughView.m
//  IVGUtils
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGPassthroughView.h"

@implementation IVGPassthroughView

// pass through hits on this view to views behind it
// but still allow subviews to receive hits
-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event 
{
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}

@end
