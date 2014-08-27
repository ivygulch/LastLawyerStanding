//
//  NSArray+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/19/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (IVGUtils)

- (NSArray *) arrayByRandomizing;
- (NSArray *) arrayByReversing;
- (NSArray *) arrayByTransforming:(id(^)(id obj)) transformationBlock;
- (NSArray *) arrayByFiltering:(BOOL(^)(id obj)) filterBlock;
- (BOOL) applyBlock:(BOOL(^)(id obj)) block;
- (id) objectAtIndex:(NSUInteger) index outOfRange:(id) outOfRangeValue;
- (NSString *) descriptionDelimitedBy:(NSString *) delimiter;
- (NSString *) stringWithPrefix:(NSString *) prefix delimiter:(NSString *) delimiter suffix:(NSString *) suffix;

- (NSArray *) subarraysWithSubarraySize:(NSUInteger) subarraySize;

+ (NSArray *) sortDescriptors:(NSString *)firstKey, ... NS_REQUIRES_NIL_TERMINATION;


@end

@interface NSMutableArray (IGUtils)

- (void) addIfNotNil:(id) item;
- (BOOL) addObject:(id)anObject ifBlock:(BOOL(^)(id anObject)) ifBlock;

@end
