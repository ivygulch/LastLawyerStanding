//
//  NSArray+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/19/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import "NSArray+IVGUtils.h"
#import <math.h>

@implementation NSArray (IVGUtils)

- (NSArray *) arrayByRandomizing {
    NSMutableArray *arrayCopy = [NSMutableArray arrayWithArray:self];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    while ([arrayCopy count] > 0) {
        int idx = arc4random() % [arrayCopy count];
        [result addObject:[arrayCopy objectAtIndex:idx]];
        [arrayCopy removeObjectAtIndex:idx];
    }
    return [result copy];
}

- (NSArray *) arrayByReversing {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [result addObject:element];
    }
    return [result copy];
}

- (NSArray *) arrayByTransforming:(id(^)(id)) transformationBlock;
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id originalValue in self) {
        [result addObject:transformationBlock(originalValue)];
    }
    return [result copy];
}

- (NSArray *) arrayByFiltering:(BOOL(^)(id)) filterBlock;
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id originalValue in self) {
        if (filterBlock(originalValue)) {
            [result addObject:originalValue];
        }
    }
    return [result copy];
}

- (BOOL) applyBlock:(BOOL(^)(id obj)) block;
{
    for (id value in self) {
        if (!block(value)) {
            return NO;
        }
    }
    return YES;
}

- (id) objectAtIndex:(NSUInteger) index outOfRange:(id) outOfRangeValue 
{
    if (index < [self count]) {
        return [self objectAtIndex:index];
    } else {
        return outOfRangeValue;
    }
}

- (NSString *) descriptionDelimitedBy:(NSString *) delimiter;
{
    return [self stringWithPrefix:@"[" delimiter:delimiter suffix:@"]"];
}

- (NSString *) stringWithPrefix:(NSString *) prefix delimiter:(NSString *) delimiter suffix:(NSString *) suffix;
{
    NSMutableString *ms = [NSMutableString string];
    if (prefix != nil) {
        [ms appendString:prefix];
    }
    NSString *sep = @"";
    for (id value in self) {
        [ms appendString:sep];
        [ms appendString:[NSString stringWithFormat:@"%@", value]];
        sep = delimiter;
    }
    if (suffix != nil) {
        [ms appendString:suffix];
    }
    return [NSString stringWithString:ms];
}

- (NSArray *) subarraysWithSubarraySize:(NSUInteger) subarraySize;
{
    if (subarraySize < 1) {
        return @[[self copy]];
    }

    NSUInteger numRecords = [self count];
    NSUInteger numSubarrays = ((NSUInteger) ((numRecords-1)/subarraySize)) + 1;

    NSMutableArray *subarrays = [NSMutableArray arrayWithCapacity:numSubarrays];
    NSUInteger startIdx = 0;
    for (NSUInteger subarrayIdx=0; subarrayIdx<numSubarrays; subarrayIdx++) {
        NSUInteger numInSubarray = (subarrayIdx < (numSubarrays-1)) ? subarraySize : (numRecords-startIdx);
        NSArray *subarray = [self subarrayWithRange:NSMakeRange(startIdx,numInSubarray)];
        [subarrays addObject:subarray];
        startIdx += subarraySize;
    }

    return [subarrays copy];
}

+ (NSArray *) sortDescriptors:(NSString *)firstKey, ...  {
    NSMutableArray *result = [NSMutableArray array];
    
    va_list args;
    va_start(args, firstKey);
    for (NSString *arg = firstKey; arg != nil; arg = va_arg(args, NSString*)) {
        NSString *key = arg;
        BOOL ascending = YES;
        if ([key hasPrefix:@"-"]) {
            key = [key substringFromIndex:1];
            ascending = NO;
        }
        [result addObject:[[NSSortDescriptor alloc] initWithKey:key ascending:ascending]];
    }
    va_end(args);
    
    return [result copy];
}

@end

@implementation NSMutableArray (IGUtils)

- (void) addIfNotNil:(id) item {
    if (item) {
        [self addObject:item];
    }
}

- (BOOL) addObject:(id)item ifBlock:(BOOL(^)(id obj)) ifBlock;
{
    BOOL result = NO;
    if (ifBlock(item)) {
        [self addObject:item];
        result = YES;
    }
    return result;
}

@end
