//
//  IVGBlockMap.m
//  WAI2012
//
//  Created by Sjoquist Douglas on 2/1/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGBlockMap.h"

@interface IVGBlockMap()

@property (strong) NSMutableDictionary *blockMap;
// allow map to handle nil block values by substituting a simple object
// for the block reference (value) in the map. NULL_BLOCK is that shared object.
@property (strong) id NULL_BLOCK;

@end

@implementation IVGBlockMap

- (id) init;
{
    if ((self = [super init])) {
        _blockMap = [[NSMutableDictionary alloc] init];
        _NULL_BLOCK = [[NSObject alloc] init];
    }
    return self;
}

- (void) setBlock:(id) block forKey:(id) key;
{
    id blockRef;
    if(block == nil){ 
        blockRef = self.NULL_BLOCK;
    } else { 
        blockRef = block;
    }
    [self.blockMap setObject:blockRef forKey:key];
}

- (void) removeBlockForKey:(id) key;
{
    [self.blockMap removeObjectForKey:key];
}

- (id) blockForKey:(id) key;
{
    id blockRef = [self.blockMap objectForKey:key];
    if (blockRef == self.NULL_BLOCK) {
        return nil;
    } else {
        return blockRef;
    }
}

- (NSArray *) allKeys;
{
    return [self.blockMap allKeys];
}

- (void)enumerateKeysAndBlocksUsingBlock:(void (^)(id key, id block, BOOL *stop))enumerationBlock;
{
    BOOL stopEnumeration = NO;
    for (id key in [self allKeys]) {
        id block = [self blockForKey:key];
        enumerationBlock(key, block, &stopEnumeration);
        if (stopEnumeration) {
            break;
        }
    }
}

@end
