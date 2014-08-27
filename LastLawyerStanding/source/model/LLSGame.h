//
//  LLSGame.h
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLSNetworkManager.h"

@class LLSPlayer;

@interface LLSGame : NSObject

@property (nonatomic,strong,readonly) NSDictionary *players;
@property (nonatomic,assign,readonly) BOOL started;

- (BOOL) addPlayer:(LLSPlayer *) player;
- (void) start;

- (instancetype) initWithNetworkManager:(LLSNetworkManager *) networkManager;

@end
