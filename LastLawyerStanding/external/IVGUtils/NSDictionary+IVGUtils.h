//
//  NSDictionary+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 2/11/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSDictionary (IVGUtils)

- (CGRect) CGRectValue;
- (id) nilableObjectForKey:(id) key;

+ (NSDictionary *) dictionaryWithCGRect:(CGRect) r;

@end
