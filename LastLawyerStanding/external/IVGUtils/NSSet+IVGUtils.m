//
//  NSSet+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/19/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import "NSSet+IVGUtils.h"
#import "NSArray+IVGUtils.h"

@implementation NSSet (IVGUtils)

- (NSArray *) randomizedArray {
    return [[self allObjects] arrayByRandomizing];
}

@end
