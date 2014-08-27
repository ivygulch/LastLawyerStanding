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

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;
{
    if ((self = [super init])) {
        _beaconId = dictionary[@"beaconId"];
        _targetBeaconId = dictionary[@"targetBeaconId"];
    }
    return self;
}

- (NSString *) description;
{
    return [NSString stringWithFormat:@"<%p> b=%@ t=%@", self, self.beaconId, self.targetBeaconId];
}

- (NSDictionary *) serializedData;
{
    NSNumber *targetBeaconId = self.targetBeaconId ? self.targetBeaconId : @0;
    return @{@"class":NSStringFromClass([self class]),
             @"beaconId":self.beaconId,
             @"targetBeaconId":targetBeaconId};
}

- (void) updateFromSerializedData:(NSDictionary *) serializedData;
{
    NSNumber *targetBeaconId = serializedData[@"targetBeaconId"];
    if ([targetBeaconId integerValue] > 0) {
        self.targetBeaconId = targetBeaconId;
    } else {
        self.targetBeaconId = nil;
    }
}

@end
