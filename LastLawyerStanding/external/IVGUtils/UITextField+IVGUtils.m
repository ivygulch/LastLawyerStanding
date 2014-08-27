//
//  UITextField+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 11/11/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "UITextField+IVGUtils.h"


@implementation UITextField (IVGUtils)

- (void) selectAll;
{
    self.selectedTextRange = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
}

@end
