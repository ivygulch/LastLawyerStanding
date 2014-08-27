//
//  NSURLResponse+IVGUtils.m
//  Pods
//
//  Created by Douglas Sjoquist on 3/12/13.
//
//

#import "NSURLResponse+IVGUtils.h"
#import "NSDate+IVGUtils.h"

static NSString * const kLastModifiedTimestampFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";

@implementation NSURLResponse (IVGUtils)

- (NSDictionary *) allHTTPHeaderFields;
{
    if ([self isKindOfClass:[NSHTTPURLResponse class]]) {
        return [(NSHTTPURLResponse*)self allHeaderFields];
    } else {
        return nil;
    }
}

- (NSDate *) lastModified;
{
    NSDictionary *headers = [self allHTTPHeaderFields];
    NSString *lastModifiedStr = [headers objectForKey:@"Last-Modified"];
    return [NSDate dateFromString:lastModifiedStr withFormat:kLastModifiedTimestampFormat];
}

- (NSUInteger) httpStatusCode;
{
    if ([self isKindOfClass:[NSHTTPURLResponse class]]) {
        return [(NSHTTPURLResponse*)self statusCode];
    } else {
        return 0;
    }
}




@end
