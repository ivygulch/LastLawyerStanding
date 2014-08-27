//
//  LLSGame.m
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSGame.h"
#import "LLSPlayer.h"
#import "NSArray+IVGUtils.h"

@interface LLSGame()
@property (nonatomic,strong) LLSNetworkManager *networkManager;
@property (nonatomic,strong) NSMutableDictionary *mutablePlayers;
@property (nonatomic,assign,readwrite) BOOL started;
@end

@implementation LLSGame

- (instancetype) initWithNetworkManager:(LLSNetworkManager *)networkManager;
{
    if ((self = [super init])) {
        _networkManager = networkManager;
        _mutablePlayers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL) okayToPerformAction:(NSString *) action;
{
    if (self.started) {
        NSString *message = [NSString stringWithFormat:@"Cannot perform '%@'", action];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game already started" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    return !self.started;
}

- (NSDictionary *) players;
{
    return [self.mutablePlayers copy];
}

- (BOOL) addPlayer:(LLSPlayer *) player;
{
    BOOL result = [self okayToPerformAction:@"Add player"];
    if (result) {
        [self.mutablePlayers setObject:player forKey:player.beaconId];
    }
    return result;
}

- (void) start;
{
    if (self.started) {
        return;
    }
    self.started = YES;

    NSArray *sortedPlayers = [[self.mutablePlayers allValues] arrayByRandomizing];
    LLSPlayer *nextTarget = [sortedPlayers lastObject];
    for (LLSPlayer *player in sortedPlayers) {
        player.target = nextTarget;
        nextTarget = player;
    }

//    [self.networkManager broadcastData:game onAcknowledge:^{
//        [self.networkManager broadcastData:]
//    }];

}


@end
