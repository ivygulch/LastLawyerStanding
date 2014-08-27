//
//  IVGBlockMap.h
//  WAI2012
//
//  Created by Sjoquist Douglas on 2/1/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVGBlockMap : NSObject

- (void) setBlock:(id) block forKey:(id) key;
- (void) removeBlockForKey:(id) key;
- (id) blockForKey:(id) key;
- (NSArray *) allKeys;
- (void)enumerateKeysAndBlocksUsingBlock:(void (^)(id key, id block, BOOL *stop))enumerationBlock;

@end
