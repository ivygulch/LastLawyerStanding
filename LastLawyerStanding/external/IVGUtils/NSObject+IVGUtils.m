//
//  NSObject+IVGUtils.m
//  IVG
//
//  Created by Sjoquist Douglas on 3/8/12.
//  Copyright 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "NSObject+IVGUtils.h"
#import <objc/runtime.h>

@implementation NSObject (IVGUtils)

static NSString *ASSOCIATED_USER_INFO_ASSOCOBJ_KEY = @"com.ivygulch.ASSOCIATED_USER_INFO";

- (NSMutableDictionary *) associatedUserInfoCreateIfNil:(BOOL) createIfNil;
{
    NSMutableDictionary *result = objc_getAssociatedObject(self, (__bridge const void *) ASSOCIATED_USER_INFO_ASSOCOBJ_KEY);
    if ((result == nil) && createIfNil) {
        result = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, (__bridge const void *) ASSOCIATED_USER_INFO_ASSOCOBJ_KEY, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

- (NSMutableDictionary *) associatedUserInfo;
{
    return [self associatedUserInfoCreateIfNil:NO];
}

- (id) associatedUserInfoObjectForKey:(id) key;
{
    NSMutableDictionary *dict = [self associatedUserInfoCreateIfNil:NO];
    return [dict objectForKey:key];
}

- (BOOL) haveAssociatedUserInfoObjectForKey:(id) key;
{
    return ([self associatedUserInfoObjectForKey:key] != nil);
}

- (void) setAssociatedUserInfoObject:(id) object forKey:(id) key;
{
    BOOL createIfNil = (object != nil); // do not create dict if the object is to be removed anyway
    NSMutableDictionary *dict = [self associatedUserInfoCreateIfNil:createIfNil];
    if (object) {
        [dict setObject:object forKey:key];
    } else {
        [dict removeObjectForKey:key];
    }
}

- (CGFloat) associatedFloatValueForKey:(id) key;
{
    return [[self associatedUserInfoObjectForKey:key] floatValue];
}

- (void) setAssociatedFloatValue:(CGFloat) value forKey:(id) key;
{
    return [self setAssociatedUserInfoObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (NSString *) debugId;
{
#if DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self respondsToSelector:@selector(shortDescription)]) {
        return [self performSelector:@selector(shortDescription)];
    } else {
        return [NSString stringWithFormat:@"%@<%p>", NSStringFromClass([self class]), self];
    }
#pragma clang diagnostic pop
#else
    return [NSString stringWithFormat:@"%@<%p>", NSStringFromClass([self class]), self];
#endif
}

- (id) asDictionaryKey;
{
    return [NSString stringWithFormat:@"<%p>", self];
}

@end
