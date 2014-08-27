//
//  UITextField+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 11/11/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "NSDate+IVGUtils.h"

// temporary kluge to work around "NSCalendarUnitWeekday not defined" weirdness when building directly to device
#define NSCalendarUnitWeekday ((NSCalendarUnit) kCFCalendarUnitWeekday)

const NSTimeInterval oneDay = (24.0*60.0*60.0);

@implementation NSDate (IVGUtils)

// creating a DateFormatter instance is pretty expensive, so creating a shared one makes sense
// DateFormatter is not threadsafe, so we need one per thread
// dwsjoquist 17-Aug-2012
+ (NSDateFormatter *) sharedDateFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *sharedDateFormatter = [dictionary objectForKey:@"sharedDateFormatter"];
    if (sharedDateFormatter == nil) {
        sharedDateFormatter = [[NSDateFormatter alloc] init];
        sharedDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        sharedDateFormatter.timeZone = [NSTimeZone systemTimeZone];
        [dictionary setObject:sharedDateFormatter forKey:@"sharedDateFormatter"];
    }
    return sharedDateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format timeZone:(NSTimeZone *) timeZone;
{
    if ([string isKindOfClass:[NSNull class]]) return nil;
    if (string.length == 0) return nil;

    NSDateFormatter *displayFormatter = [self sharedDateFormatter];
    [displayFormatter setDateFormat:format];
    [displayFormatter setTimeZone:timeZone];
	NSDate *date = [displayFormatter dateFromString:string];
	return date;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
{
    return [self dateFromString:string withFormat:format timeZone:[NSTimeZone defaultTimeZone]];
}

+ (NSDate *)utcDateFromString:(NSString *)string withFormat:(NSString *)format;
{
    return [self dateFromString:string withFormat:format timeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
}

+ (NSDate *) dateFromYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day hour:(NSInteger) hour minute:(NSInteger) minute second:(NSInteger) second timeZone:(NSTimeZone *) timeZone;
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    dateComponents.timeZone = timeZone;
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

+ (NSDate *) dateFromYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day hour:(NSInteger) hour minute:(NSInteger) minute second:(NSInteger) second;
{
    return [self dateFromYear:year month:month day:day hour:hour minute:minute second:second timeZone:[NSTimeZone defaultTimeZone]];
}

- (NSDate *) dateWithYear:(NSNumber *) year month:(NSNumber *) month day:(NSNumber *) day hour:(NSNumber *) hour minute:(NSNumber *) minute second:(NSNumber *) second;
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:self];
    if (year != nil) {
        dateComponents.year = [year integerValue];
    }
    if (month != nil) {
        dateComponents.month = [month integerValue];
    }
    if (day != nil) {
        dateComponents.day = [day integerValue];
    }
    if (hour != nil) {
        dateComponents.hour = [hour integerValue];
    }
    if (minute != nil) {
        dateComponents.minute = [minute integerValue];
    }
    if (second != nil) {
        dateComponents.second = [second integerValue];
    }
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

- (NSDate *) dateWithRelativeYear:(NSNumber *) year month:(NSNumber *) month day:(NSNumber *) day hour:(NSNumber *) hour minute:(NSNumber *) minute second:(NSNumber *) second;
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    if (year != nil) {
        dateComponents.year = [year integerValue];
    }
    if (month != nil) {
        dateComponents.month = [month integerValue];
    }
    if (day != nil) {
        dateComponents.day = [day integerValue];
    }
    if (hour != nil) {
        dateComponents.hour = [hour integerValue];
    }
    if (minute != nil) {
        dateComponents.minute = [minute integerValue];
    }
    if (second != nil) {
        dateComponents.second = [second integerValue];
    }
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *) dateWithZeroTime;
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

- (NSInteger) year;
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit) fromDate:self];
    return dateComponents.year;
}

- (NSInteger) weekday;
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday) fromDate:self];
    return dateComponents.weekday;
}

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *) timeZone;
{
	NSDateFormatter *outputFormatter = [NSDate sharedDateFormatter];
	[outputFormatter setDateFormat:format];
    [outputFormatter setTimeZone:timeZone];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	return timestamp_str;
}

- (NSString *)stringWithFormat:(NSString *)format;
{
    return [self stringWithFormat:format timeZone:[NSTimeZone defaultTimeZone]];
}

- (NSInteger) calendarDaysRelativeToDate:(NSDate *) argDate;
{
    NSDate *argDateAtMidnight = [argDate dateWithYear:nil month:nil day:nil hour:@0 minute:@0 second:@0];
    NSDate *selfAtMidnight = [self dateWithYear:nil month:nil day:nil hour:@0 minute:@0 second:@0];
    NSTimeInterval timeInterval = [selfAtMidnight timeIntervalSinceDate:argDateAtMidnight];
    NSInteger days = (int) ((timeInterval + ((timeInterval < 0) ? -1 : 1)) / oneDay);
    return days;
}

- (NSDate *) dateByAddingDays:(NSInteger) days;
{
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    dc.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self options:0];
}

#define defaultFormat @"MM/dd/yyyy, h:mm a"
#define defaultDayFormat @"MM/dd/yyyy"

- (NSString *) formattedDate;
{
    return [self stringWithFormat:defaultFormat];
}

- (NSString *) formattedDay;
{
    return [self stringWithFormat:defaultDayFormat];
}

- (NSString *) formattedRelativeToDay:(NSDate *) relative;
{
    NSInteger daysDifference = [self calendarDaysRelativeToDate:relative];
    NSInteger year = [self year];
    NSInteger relativeYear = [relative year];
    NSString *fmt;
    if (daysDifference == 0) {
        fmt = @"'Today'";
    } else if (daysDifference == 1) {
        fmt = @"'Tomorrow'";
    } else if (daysDifference == -1) {
        fmt = @"'Yesterday'";
    } else if ((daysDifference > 1) && (daysDifference < 7)) {
        fmt = @"'Next' EEEE";
    } else if ((daysDifference < 0) && (daysDifference > -7)) {
        fmt = @"'Last' EEEE";
    } else if (year == relativeYear) {
        fmt = @"MMMM d";
    } else {
        fmt = defaultDayFormat;
    }
    return [self stringWithFormat:fmt];
}

- (NSString *) formattedRelativeToDate:(NSDate *) relative;
{
    NSInteger daysDifference = [self calendarDaysRelativeToDate:relative];
    NSInteger year = [self year];
    NSInteger relativeYear = [relative year];
    NSString *fmt;
    if (daysDifference == 0) {
        fmt = @"'Today', hh:mm a";
    } else if (daysDifference == 1) {
        fmt = @"'Tomorrow', h:mm a";
    } else if (daysDifference == -1) {
        fmt = @"'Yesterday', h:mm a";
    } else if ((daysDifference > 1) && (daysDifference < 7)) {
        fmt = @"'Next' EEEE, h:mm a";
    } else if ((daysDifference < 0) && (daysDifference > -7)) {
        fmt = @"'Last' EEEE, h:mm a";
    } else if (year == relativeYear) {
        fmt = @"MMMM d, h:mm a";
    } else {
        fmt = defaultFormat;
    }
    return [self stringWithFormat:fmt];
}

- (NSDateComponents *) allComponents;
{
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [[NSCalendar currentCalendar] components:flags fromDate:self];
}

- (NSDateComponents *) dateComponents;
{
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    return [[NSCalendar currentCalendar] components:flags fromDate:self];
}

- (NSDateComponents *) timeComponents;
{
    NSUInteger flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [[NSCalendar currentCalendar] components:flags fromDate:self];
}

- (NSDate *) earliestTimestampForDate;
{
    return [self dateWithYear:nil month:nil day:nil hour:@0 minute:@0 second:@0];
}

- (NSDate *) latestTimestampForDate;
{
    return [[self dateWithYear:nil month:nil day:nil hour:@23 minute:@59 second:@59] dateByAddingTimeInterval:0.999];
}

+ (BOOL) date:(NSDate *) date1 isSameDay:(NSDate *) date2;
{
    if (date1 == date2) {
        return YES;
    }
    return [[date1 dateWithZeroTime] isEqual:[date2 dateWithZeroTime]];
}

- (BOOL) isSameDay:(NSDate *) date;
{
    NSDate *thisWithZeroTime = [self dateWithZeroTime];
    NSDate *thatWithZeroTime = [date dateWithZeroTime];
    return [thisWithZeroTime isEqual:thatWithZeroTime];
}

- (BOOL) isAfterDay:(NSDate *) date;
{
    NSDate *thisWithZeroTime = [self dateWithZeroTime];
    NSDate *thatWithZeroTime = [date dateWithZeroTime];
    return ([thisWithZeroTime compare:thatWithZeroTime] == NSOrderedDescending);
}

- (BOOL) isOnOrAfterDay:(NSDate *) date;
{
    NSDate *thisWithZeroTime = [self dateWithZeroTime];
    NSDate *thatWithZeroTime = [date dateWithZeroTime];
    return ([thisWithZeroTime compare:thatWithZeroTime] != NSOrderedAscending);
}

- (BOOL) isBeforeDay:(NSDate *) date;
{
    NSDate *thisWithZeroTime = [self dateWithZeroTime];
    NSDate *thatWithZeroTime = [date dateWithZeroTime];
    return ([thisWithZeroTime compare:thatWithZeroTime] == NSOrderedAscending);
}

- (BOOL) isOnOrBeforeDay:(NSDate *) date;
{
    NSDate *thisWithZeroTime = [self dateWithZeroTime];
    NSDate *thatWithZeroTime = [date dateWithZeroTime];
    return ([thisWithZeroTime compare:thatWithZeroTime] != NSOrderedDescending);
}

- (NSDate *) roundUpTime:(NSInteger) roundUpTime;
{
    NSTimeInterval currentTime = [self timeIntervalSinceReferenceDate];
    NSTimeInterval newTime = ((NSInteger) ((currentTime-1) / roundUpTime) + 1) * roundUpTime;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:newTime];
}

@end
