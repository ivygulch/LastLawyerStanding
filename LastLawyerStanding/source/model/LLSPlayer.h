//
//  LLSPlayer.h
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLSSerializable.h"

@interface LLSPlayer : NSObject<LLSSerializable>

@property (nonatomic,strong) NSNumber *beaconId;
@property (nonatomic,strong) NSNumber *targetBeaconId;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;

@end
