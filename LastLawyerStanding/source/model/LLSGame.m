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
@property (nonatomic,strong,readwrite) LLSPlayer *myPlayer;
@property (nonatomic,assign,readwrite) BOOL started;
@end

@implementation LLSGame

- (instancetype) initWithNetworkManager:(LLSNetworkManager *) networkManager myBeaconId:(NSNumber *) myBeaconId;
{
    if ((self = [super init])) {
        _networkManager = networkManager;
        _mutablePlayers = [NSMutableDictionary dictionary];
        _myPlayer = [[LLSPlayer alloc] init];
        _myPlayer.beaconId = myBeaconId;
    }
    return self;
}

- (NSDictionary *) players;
{
    return [self.mutablePlayers copy];
}

- (void) addPlayer:(LLSPlayer *) player;
{
    [self.mutablePlayers setObject:player forKey:player.beaconId];
    [self.networkManager broadcast:player.serializedData];
}

- (void) setStarted:(BOOL)started;
{
    if (_started != started) {
        if (started) {
            [self.gameDelegate gameStarted:self];
        }
    }
    _started = started;
}

- (void) startGame;
{
    if (self.started) {
        return;
    }
    self.started = YES;

    NSArray *sortedPlayers = [[self.mutablePlayers allValues] arrayByRandomizing];
    NSNumber *nextTargetBeaconId = [sortedPlayers lastObject];
    for (LLSPlayer *player in sortedPlayers) {
        player.targetBeaconId = nextTargetBeaconId;
        nextTargetBeaconId = player.beaconId;
    }

    [self.networkManager broadcast:self.serializedData];
}

- (NSDictionary *) serializedData;
{
    NSMutableArray *serializedPlayers = [NSMutableArray arrayWithCapacity:[self.mutablePlayers count]];
    [self.mutablePlayers enumerateKeysAndObjectsUsingBlock:^(id key, LLSPlayer *player, BOOL *stop) {
        [serializedPlayers addObject:[player serializedData]];
    }];
    return @{@"players":serializedPlayers,
             @"started":@(self.started)};
}

- (void) updateFromSerializedData:(NSDictionary *) serializedData;
{
    NSArray *serializedPlayers = serializedData[@"players"];
    for (NSDictionary *serializedPlayer in serializedPlayers) {
        NSNumber *beaconId = serializedData[@"beaconId"];
        LLSPlayer *player = self.players[beaconId];
        if (player) {
            [player updateFromSerializedData:serializedPlayer];
        } else {
            player = [[LLSPlayer alloc] initWithDictionary:serializedPlayer];
            [self addPlayer:player];
        }
    }
    self.started = [serializedData[@"started"] boolValue];
}

@end
