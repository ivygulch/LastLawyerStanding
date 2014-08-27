//
//  LLSNetworkManager.m
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSNetworkManager.h"

@implementation LLSNetworkManager

+ (LLSNetworkManager *) sharedManager;
{
    static dispatch_once_t predicate;
    static LLSNetworkManager* instance = nil;
    if (instance == nil) {
        dispatch_once(&predicate, ^{
            instance = [[LLSNetworkManager alloc] init];
        });
    }
    return instance;
}

@end
