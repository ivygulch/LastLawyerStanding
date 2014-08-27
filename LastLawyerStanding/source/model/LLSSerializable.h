//
//  LLSSerializable.h
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LLSSerializable <NSObject>

- (NSDictionary *) serializedData;
- (void) updateFromSerializedData:(NSDictionary *) serializedData;

@end
