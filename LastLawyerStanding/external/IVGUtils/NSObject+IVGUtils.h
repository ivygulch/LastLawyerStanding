//
//  NSObject+IVGUtils.h
//  IVG
//
//  Created by Sjoquist Douglas on 3/8/12.
//  Copyright 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSObject (IVGUtils)

@property (nonatomic,readonly) NSMutableDictionary *associatedUserInfo;

- (BOOL) haveAssociatedUserInfoObjectForKey:(id) key;
- (id) associatedUserInfoObjectForKey:(id) key;
- (void) setAssociatedUserInfoObject:(id) object forKey:(id) key;
- (CGFloat) associatedFloatValueForKey:(id) key;
- (void) setAssociatedFloatValue:(CGFloat) value forKey:(id) key;
- (NSString *) debugId;

- (id) asDictionaryKey;

@end
