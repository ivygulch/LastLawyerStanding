//
//  IVGClock.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/25/14.
//  Copyright (c) 2014 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVGClock : NSObject

+ (IVGClock *) sharedClock;

@property (nonatomic,strong) NSDate *testDate;

/**
 Update or create test date using time increment and return the value

 @param timeInterval to use in incrementing current test date
 @return Returns current test date after incrementing value
 */
- (NSDate *) testDateAfterIncrementing:(NSTimeInterval) timeInterval;

/**
 Returns full current date, by default uses [NSDate date]

 @return Returns current date
 */
- (NSDate *) currentDate;

/**
 @return Returns YES if currently using live dates ([NSDate date])
 */
- (BOOL) isActualDate;

@end
