//
//  IVGClock.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/25/14.
//  Copyright (c) 2014 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGClock.h"

@implementation IVGClock

+ (IVGClock *) sharedClock;
{
    static dispatch_once_t pred_shared_instance;
    static IVGClock *_sharedInstance = nil;
    dispatch_once(&pred_shared_instance, ^{
        _sharedInstance = [[IVGClock alloc] init];
    });
    return _sharedInstance;
}

- (NSDate *) testDateAfterIncrementing:(NSTimeInterval) timeInterval;
{
    if (self.testDate == nil) {
        self.testDate = [NSDate date];
    }
    self.testDate = [self.testDate dateByAddingTimeInterval:timeInterval];
    return self.testDate;
}

- (NSDate *) currentDate;
{
    if (self.testDate == nil) {
        return [NSDate date];
    } else {
        NSLog(@"*** IVGClock: using testDate (%@) instead of system date (%@)", self.testDate, [NSDate date]);
        return self.testDate;
    }
}

- (BOOL) isActualDate;
{
    return (self.testDate == nil);
}


@end
