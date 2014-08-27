//
//  NSDictionary+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 2/11/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "NSDictionary+IVGUtils.h"
#import "NSString+IVGUtils.h"

@implementation NSDictionary (IVGUtils)

- (CGRect) CGRectValue;
{
    CGRect r;
    CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)(self), &r);
    return r;
}

- (id) nilableObjectForKey:(id) key;
{
    id result = [self objectForKey:key];
    if ([result respondsToSelector:@selector(objectForKey:)]) {
        NSString *nilValue = [[result objectForKey:@"_i:nil"] description];
        if ([nilValue xmlBoolValue]) {
            result = nil;
        }
    }
    return result;
}

+ (NSDictionary *) dictionaryWithCGRect:(CGRect) r;
{
    return [NSDictionary dictionaryWithDictionary:CFBridgingRelease(CGRectCreateDictionaryRepresentation(r))];
}

@end
