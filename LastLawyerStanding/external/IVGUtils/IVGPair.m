//
//  IVGPair.m
//  MyFactor
//
//  Created by Douglas Sjoquist on 5/6/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGPair.h"

@implementation IVGPair

- (id) initWithA:(id) a b:(id) b;
{
    if ((self = [super init])) {
        _a = a;
        _b = b;
    }
    return self;
}

- (NSString *) description;
{
    return [NSString stringWithFormat:@"<%@,%@>", self.a, self.b];
}

+ (IVGPair *) pairWithA:(id) a b:(id) b;
{
    return [[IVGPair alloc] initWithA:a b:b];
}

@end
