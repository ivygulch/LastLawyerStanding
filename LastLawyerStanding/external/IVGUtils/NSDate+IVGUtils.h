//
//  UITextField+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 11/11/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSTimeInterval oneDay;

@interface NSDate (IVGUtils)

+ (NSDateFormatter *) sharedDateFormatter;
+ (NSDate *) dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSDate *) dateFromString:(NSString *)string withFormat:(NSString *)format timeZone:(NSTimeZone *) timeZone;
+ (NSDate *) dateFromYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day hour:(NSInteger) hour minute:(NSInteger) minute second:(NSInteger) second;
+ (NSDate *) dateFromYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day hour:(NSInteger) hour minute:(NSInteger) minute second:(NSInteger) second timeZone:(NSTimeZone *) timeZone;

- (NSDate *) dateWithYear:(NSNumber *) year month:(NSNumber *) month day:(NSNumber *) day hour:(NSNumber *) hour minute:(NSNumber *) minute second:(NSNumber *) second;
- (NSDate *) dateWithRelativeYear:(NSNumber *) year month:(NSNumber *) month day:(NSNumber *) day hour:(NSNumber *) hour minute:(NSNumber *) minute second:(NSNumber *) second;
- (NSDate *) dateWithZeroTime;

- (NSString *) stringWithFormat:(NSString *)format;
- (NSString *) stringWithFormat:(NSString *)format timeZone:(NSTimeZone *) timeZone;

- (NSInteger) year;
- (NSInteger) weekday;
- (NSInteger) calendarDaysRelativeToDate:(NSDate *) date;
- (NSDate *) dateByAddingDays:(NSInteger) days;
- (NSString *) formattedDate;
- (NSString *) formattedDay;
- (NSString *) formattedRelativeToDay:(NSDate *) relative;
- (NSString *) formattedRelativeToDate:(NSDate *) date;

- (NSDate *) earliestTimestampForDate;
- (NSDate *) latestTimestampForDate;

+ (BOOL) date:(NSDate *) date1 isSameDay:(NSDate *) date2;
- (BOOL) isSameDay:(NSDate *) date;
- (BOOL) isAfterDay:(NSDate *) date;
- (BOOL) isOnOrAfterDay:(NSDate *) date;
- (BOOL) isBeforeDay:(NSDate *) date;
- (BOOL) isOnOrBeforeDay:(NSDate *) date;

- (NSDate *) roundUpTime:(NSInteger) roundUpTime;

@end
