//
//  IVGPair.h
//  MyFactor
//
//  Created by Douglas Sjoquist on 5/6/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVGPair : NSObject

@property (nonatomic,strong,readonly) id a;
@property (nonatomic,strong,readonly) id b;

- (id) initWithA:(id) a b:(id) b;

+ (IVGPair *) pairWithA:(id) a b:(id) b;

@end
