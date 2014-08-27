//
//  NSURLResponse+IVGUtils.h
//  Pods
//
//  Created by Douglas Sjoquist on 3/12/13.
//
//

#import <Foundation/Foundation.h>

@interface NSURLResponse (IVGUtils)

- (NSDictionary *) allHTTPHeaderFields;
- (NSDate *) lastModified;
- (NSUInteger) httpStatusCode;

@end
