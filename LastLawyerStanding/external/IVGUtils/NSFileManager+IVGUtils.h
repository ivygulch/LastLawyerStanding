//
//  NSFileManager+IVGUtils.h
//  Pods
//
//  Created by Douglas Sjoquist on 3/12/13.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager (IVGUtils)

- (NSDate *) timestampForFilePath:(NSString *) filePath error:(NSError **) error;
- (NSDate *) regularFileTimestampForFilePath:(NSString *) filePath error:(NSError **) error;
- (BOOL) setTimestamp:(NSDate *) timestamp forFilePath:(NSString *) filePath error:(NSError **) error;
- (BOOL) resetTimestampForFilePath:(NSString *) filePath error:(NSError **) error;
- (BOOL) ensureDirectoryExistsForFilePath:(NSString *) filePath error:(NSError **) error;

@end
