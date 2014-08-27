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
        [self addPlayer:_myPlayer];
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
    NSLog(@"after sort\n%@", sortedPlayers);
    NSNumber *nextTargetBeaconId = [[sortedPlayers lastObject] beaconId];
    NSLog(@"nextTargetBeaconId=%@", nextTargetBeaconId);
    for (LLSPlayer *player in sortedPlayers) {
        player.targetBeaconId = nextTargetBeaconId;
        NSLog(@"player[%@].targetBeaconId=%@", player.beaconId, player.targetBeaconId);
        nextTargetBeaconId = player.beaconId;
        NSLog(@"  nextTargetBeaconId=%@", nextTargetBeaconId);
    }
    NSLog(@"after assign\n%@\n%@", sortedPlayers, self);

    [self.networkManager broadcast:self.serializedData];
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
