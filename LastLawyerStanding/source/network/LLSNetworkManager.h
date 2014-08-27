//
//  LLSNetworkManager.h
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLSNetworkManager : NSObject

- (instancetype) initWithDisplayName:(NSString *) displayName serviceType:(NSString *) serviceType;
- (void) browseForPeersWithViewController:(UIViewController *) viewController;

@end