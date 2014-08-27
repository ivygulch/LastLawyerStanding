//
//  NSFileManager+IVGUtils.m
//  Pods
//
//  Created by Douglas Sjoquist on 3/12/13.
//
//

#import "NSFileManager+IVGUtils.h"

@implementation NSFileManager (IVGUtils)

- (NSDictionary *) fileAttributesForFilePath:(NSString *) filePath error:(NSError **) error;
{
    if ((filePath == nil) || ![self fileExistsAtPath:filePath]) {
        if (error != nil) {
            *error = [NSError errorWithDomain:@"NSFileManager+IVGUtils" code:1 userInfo:@{@"filePath":(filePath == nil) ? [NSNull null]: filePath}];
        }
        return nil;
    }

    return [self attributesOfItemAtPath:filePath error:error];
}

- (NSDate *) timestampForFilePath:(NSString *) filePath error:(NSError **) error;
{
    NSDictionary *fileAttributes = [self fileAttributesForFilePath:filePath error:error];
    if (fileAttributes == nil) {
        return nil;
    } else {
        return [fileAttributes objectForKey:NSFileModificationDate];
    }
}

- (NSDate *) regularFileTimestampForFilePath:(NSString *) filePath error:(NSError **) error;
{
    NSDictionary *fileAttributes = [self fileAttributesForFilePath:filePath error:error];
    NSString *fileType = [fileAttributes objectForKey:NSFileType];
    if ([fileType isEqualToString:NSFileTypeRegular]) {
        return [fileAttributes objectForKey:NSFileModificationDate];
    } else {
        return nil;
    }
}

- (BOOL) setTimestamp:(NSDate *) timestamp forFilePath:(NSString *) filePath error:(NSError **) error;
{
    if ((filePath == nil) || ![self fileExistsAtPath:filePath]) {
        if (error != nil) {
            *error = [NSError errorWithDomain:@"NSFileManager+IVGUtils" code:1 userInfo:@{@"filePath":(filePath == nil) ? [NSNull null]: filePath}];
        }
        return NO;
    }

    NSDictionary *updatedAttributes = @{NSFileModificationDate:timestamp};
    return [self setAttributes:updatedAttributes ofItemAtPath:filePath error:error];
}

- (BOOL) resetTimestampForFilePath:(NSString *) filePath error:(NSError **) error;
{
    return [self setTimestamp:[NSDate distantPast] forFilePath:filePath error:error];
}

- (BOOL) ensureDirectoryExistsForFilePath:(NSString *) filePath error:(NSError **) error;
{
    BOOL needMkdir = NO;
    BOOL isDir;
    if ([self fileExistsAtPath:filePath isDirectory:&isDir]) {
        if (!isDir) {
            [self removeItemAtPath:filePath error:nil];
            needMkdir = YES;
        }
    } else {
        needMkdir = YES;
    }
    if (needMkdir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:error];
    }
    return needMkdir;
}

@end
