//
//  LLSGame.h
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLSNetworkManager.h"
#import "LLSSerializable.h"

@class LLSPlayer;
@class LLSGame;

@protocol LLSGameProtocol <NSObject>
- (void) gameStarted:(LLSGame *) game;
@end

@interface LLSGame : NSObject<LLSSerializable>

@property (nonatomic,weak) id<LLSGameProtocol> gameDelegate;
@property (nonatomic,strong,readonly) NSDictionary *players;
@property (nonatomic,assign,readonly) BOOL started;

- (BOOL) addPlayer:(LLSPlayer *) player;
- (void) start;

- (instancetype) initWithNetworkManager:(LLSNetworkManager *) networkManager;

@end
