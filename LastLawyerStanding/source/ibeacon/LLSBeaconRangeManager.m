//
//  LLSBeaconRangeManager.m
//  LastLawyerStanding
//
//  Created by Sam Raudabaugh on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSBeaconRangeManager.h"
@import CoreLocation;

@interface LLSBeaconRangeManager () <CLLocationManagerDelegate>

@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;

@end

@implementation LLSBeaconRangeManager

- (id)initWithMinor:(NSNumber *)minor
{
    self = [super init];
    self.minor = minor;
    
    _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"7D65B622-4AA8-4560-914C-502BE940BC16"]];
    
    self.beacons = [[NSMutableDictionary alloc] init];
    
    // This location manager will be used to demonstrate how to range beacons.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Populate the regions we will range once.
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    
    for (NSUUID *uuid in self.supportedProximityUUIDs)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        self.rangedRegions[region] = [NSArray array];
    }
    
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
    
    return self;
}

- (void)dealloc
{
    // Stop ranging when the view goes away.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    /*
     CoreLocation will call this delegate method at 1 Hz with updated range information.
     Beacons will be categorized and displayed by proximity.  A beacon can belong to multiple
     regions.  It will be displayed multiple times if that is the case.  If that is not desired,
     use a set instead of an array.
     */
    self.rangedRegions[region] = beacons;
    [self.beacons removeAllObjects];
    
    NSMutableArray *allBeacons = [NSMutableArray array];
    
    for (NSArray *regionResult in [self.rangedRegions allValues])
    {
        [allBeacons addObjectsFromArray:regionResult];
    }
    
    NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"minor = %d", [self.minor intValue]]];
    if ([proximityBeacons count]) {
        // Assume that we will only see one beacon for a given minor value.
        CLBeacon *beacon = [proximityBeacons firstObject];
        if (beacon.rssi > -60) {
            [self.beaconDelegate beaconImmediate];
        } else if (beacon.rssi > -90) {
            [self.beaconDelegate beaconVisible];
        } else {
            [self.beaconDelegate beaconInvisible];
        }
    } else {
        [self.beaconDelegate beaconInvisible];
    }
}

@end
