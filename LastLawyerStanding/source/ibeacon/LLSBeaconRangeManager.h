//
//  LLSBeaconRangeManager.h
//  LastLawyerStanding
//
//  Created by Sam Raudabaugh on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LLSBeaconRangeDelegate <NSObject>

- (void)beaconVisible;
- (void)beaconInvisible;
- (void)beaconImmediate;

@end

@interface LLSBeaconRangeManager : NSObject

@property (nonatomic, weak) NSNumber * minor;
@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;
@property (nonatomic, weak) id <LLSBeaconRangeDelegate> beaconDelegate;

@end
