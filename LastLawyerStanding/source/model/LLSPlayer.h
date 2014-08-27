//
//  LLSPlayer.h
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLSPlayer : NSObject

@property (nonatomic,strong) NSNumber *beaconId;
@property (nonatomic,strong) LLSPlayer *stalker;
@property (nonatomic,strong) LLSPlayer *target;

@end
