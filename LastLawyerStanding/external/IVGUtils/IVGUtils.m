//
//  IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 09/01/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGUtils.h"
#import "NSString+IVGUtils.h"

@implementation IVGUtils

+ (NSDateFormatter *) sharedDateFormatter {
    // this is a threadsafe, fast method of creating a singleton or doing other one-time initialization
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *sharedDateFormatter = [dictionary objectForKey:@"sharedDateFormatter"];
    if (!sharedDateFormatter) {
        sharedDateFormatter = [[NSDateFormatter alloc] init];
        sharedDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dictionary setObject:sharedDateFormatter forKey:@"sharedDateFormatter"];
    }
    return sharedDateFormatter;
}

+ (NSString *) stringFromDate:(NSDate *) value withFormat:(NSString *) format {
    NSDateFormatter *df = [IVGUtils sharedDateFormatter];
    [df setDateFormat:format];
    return [df stringFromDate:value];
}

+ (NSDate *) dateFromString:(NSString *) value withFormat:(NSString *) format {
    NSDateFormatter *df = [IVGUtils sharedDateFormatter];
    [df setDateFormat:format];
    return [df dateFromString:value];
}

+ (id) ifNil:(id) value use:(id) defaultValue {
    return value ? value : defaultValue;
}

+ (void) showAlertViewTitle:(NSString *) title 
                    message:(NSString *) message 
                   delegate:(id<UIAlertViewDelegate>) delegate
          cancelButtonTitle:(NSString *) cancelButtonTitle {
    UIAlertView* alertView = [[UIAlertView alloc] 
                              initWithTitle:title
                              message:message
                              delegate:delegate
                              cancelButtonTitle:cancelButtonTitle
                              otherButtonTitles:nil];
    [alertView show];
}

@end
