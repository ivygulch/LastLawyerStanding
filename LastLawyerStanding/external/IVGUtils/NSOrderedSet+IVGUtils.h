//
//  NSOrderedSet+IVGUtils.h
//  MyFactor
//
//  Created by Douglas Sjoquist on 12/6/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOrderedSet (IVGUtils)

- (NSArray *) arrayByRandomizing;
- (NSOrderedSet *) orderedSetByRandomizing;
- (id) objectAtIndex:(NSUInteger) index outOfRange:(id) outOfRangeValue;

@end
