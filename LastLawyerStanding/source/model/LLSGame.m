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
@property (nonatomic,strong) NSNumber *myPlayerBeaconId;
@property (nonatomic,assign,readwrite) BOOL started;
@end

@implementation LLSGame

- (instancetype) initWithNetworkManager:(LLSNetworkManager *) networkManager myBeaconId:(NSNumber *) myBeaconId;
{
    if ((self = [super init])) {
        _networkManager = networkManager;
        _mutablePlayers = [NSMutableDictionary dictionary];
        _myPlayerBeaconId = myBeaconId;

        LLSPlayer *myPlayer = [[LLSPlayer alloc] init];
        myPlayer.beaconId = myBeaconId;
        [self addPlayer:myPlayer];
    }
    return self;
}

- (NSString *) description;
{
    NSMutableString *result = [NSMutableString string];
    [result appendFormat:@"game started=%u", self.started];
    for (LLSPlayer *player in [self.players allValues]) {
        [result appendFormat:@"\n%@", player];
    }
    return result;
}

- (NSDictionary *) players;
{
    return [self.mutablePlayers copy];
}

- (LLSPlayer *) myPlayer;
{
    return self.mutablePlayers[self.myPlayerBeaconId];
}

- (void) addPlayer:(LLSPlayer *) player;
{
    [self.mutablePlayers setObject:player forKey:player.beaconId];
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
    NSNumber *nextTargetBeaconId = [[sortedPlayers lastObject] beaconId];
    for (LLSPlayer *player in sortedPlayers) {
        player.targetBeaconId = nextTargetBeaconId;
        nextTargetBeaconId = player.beaconId;
    }

    [self.networkManager broadcast:self.serializedData];
}

- (void) broadcastGame;
{
    [self.networkManager broadcast:self.serializedData];
}

- (void) beatMyTarget;
{
    NSNumber *loserBeaconId = self.myPlayer.targetBeaconId;
    LLSPlayer *loserPlayer = self.mutablePlayers[loserBeaconId];
    self.myPlayer.targetBeaconId = loserPlayer.targetBeaconId;
    loserPlayer.winnerBeaconId = self.myPlayer.beaconId;
    loserPlayer.targetBeaconId = @0;
    [self broadcastGame];
}

- (NSDictionary *) serializedData;
{
    NSMutableArray *serializedPlayers = [NSMutableArray arrayWithCapacity:[self.mutablePlayers count]];
    [self.mutablePlayers enumerateKeysAndObjectsUsingBlock:^(id key, LLSPlayer *player, BOOL *stop) {
        [serializedPlayers addObject:[player serializedData]];
    }];
    return @{@"class":NSStringFromClass([self class]),
             @"players":serializedPlayers,
             @"started":@(self.started)};
}

- (void) updateFromSerializedData:(NSDictionary *) serializedData;
{
    NSNumber *previousWinnerBeaconId = self.myPlayer.winnerBeaconId;
    NSArray *serializedPlayers = serializedData[@"players"];
    for (NSDictionary *serializedPlayer in serializedPlayers) {
        NSNumber *beaconId = serializedPlayer[@"beaconId"];
        LLSPlayer *player = self.players[beaconId];
        if (player) {
            [player updateFromSerializedData:serializedPlayer];
        } else {
            player = [[LLSPlayer alloc] initWithDictionary:serializedPlayer];
            [self addPlayer:player];
        }
        if ([player.beaconId isEqual:self.myPlayer.beaconId]) {
            if (!previousWinnerBeaconId && player.winnerBeaconId) {
                LLSPlayer *winnerPlayer = self.mutablePlayers[player.winnerBeaconId];
                [self.gameDelegate playerBeatYou:winnerPlayer];
            }
        }
    }
    BOOL previousStarted = self.started;
    self.started = [serializedData[@"started"] boolValue];
    if (previousStarted) {
        [self.gameDelegate gameUpdated:self];
    }
}

@end
