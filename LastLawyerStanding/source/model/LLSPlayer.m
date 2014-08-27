//
//  LLSPlayer.m
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSPlayer.h"
#import "LLSGame.h"

@implementation LLSPlayer

- (NSDictionary *) serializedData;
{
    NSNumber *targetBeaconId = self.target ? self.target.beaconId : @0;
    return @{@"beaconId":self.beaconId,
             @"target":targetBeaconId};
}

- (void) updateFromSerializedData:(NSDictionary *) serializedData;
{
    NSNumber *targetBeaconId = serializedData[@"target"];
    self.target = self.game.players[targetBeaconId];
}

@end
