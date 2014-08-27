//
//  LLSViewController.m
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSViewController.h"
#import "LLSNetworkManager.h"
#import "LLSGame.h"
#import "LLSPlayer.h"
#import "LLSPlaytimeViewController.h"

@interface LLSViewController ()<LLSNetworkManagerProtocol, LLSGameProtocol>
@property (nonatomic,strong) IBOutlet UITextField *nameTextField;
@property (nonatomic,strong) IBOutlet UITextField *beaconIdTextField;
@property (nonatomic,strong) LLSNetworkManager *networkManager;
@property (nonatomic,strong) LLSGame *game;

@property (nonatomic,strong) LLSPlaytimeViewController* playtimeViewController;

@end

@implementation LLSViewController

- (IBAction) configureAction:(id)sender
{
    self.networkManager = [[LLSNetworkManager alloc] initWithDisplayName:self.nameTextField.text serviceType:@"LLSService"];
    self.networkManager.networkManagerDelegate = self;
    NSNumber *beaconId = @([[self.beaconIdTextField text] integerValue]);
    self.game = [[LLSGame alloc] initWithNetworkManager:self.networkManager myBeaconId:beaconId];
    self.beaconIdTextField.text = [NSString stringWithFormat:@"%@", beaconId];
    self.game.gameDelegate = self;

    [self.nameTextField resignFirstResponder];
    [self.beaconIdTextField resignFirstResponder];
    
    self.playtimeViewController = [[LLSPlaytimeViewController alloc]initWithGame:self.game];

}

- (IBAction) debugAction:(id) sender;
{
    NSLog(@"game: %@", self.game);
}

- (IBAction) browseAction:(id) sender;
{
    [self.networkManager browseForPeersWithViewController:self];
}

- (IBAction) startGameAction:(id) sender;
{
    [self.game startGame];
    self.playtimeViewController = [[LLSPlaytimeViewController alloc]initWithGame:self.game];
    [self presentViewController:self.playtimeViewController animated:YES completion:nil];
    [self.playtimeViewController didMoveToParentViewController:self];
    //[self.playtimeViewController didRecieveNewTarget:self.game.myPlayer.targetBeaconId];
}

- (IBAction) beatMyTargetAction:(id)sender;
{
    [self.game beatMyTarget];
}

#pragma mark - LLSNetworkManagerProtocol

- (void) peerIDAdded:(MCPeerID *) peerID;
{
    [self.networkManager broadcast:self.game.serializedData toPeer:peerID];
}

- (void) dataReceived:(NSData *) data fromPeerID:(MCPeerID *) peerID;
{
    NSError *error;
    NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (serializedData) {
        if ([serializedData[@"class"] isEqualToString:NSStringFromClass([LLSGame class])]) {
            [self.game updateFromSerializedData:serializedData];
        } else if ([serializedData[@"class"] isEqualToString:NSStringFromClass([LLSPlayer class])]) {
            NSNumber *beaconId = serializedData[@"beaconId"];
            if (beaconId) {
                LLSPlayer *player = self.game.players[beaconId];
                if (player) {
                    [player updateFromSerializedData:serializedData];
                } else {
                    player = [[LLSPlayer alloc] initWithDictionary:serializedData];
                    [self.game addPlayer:player];
                }
            }
        }
    } else {
        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Could not parse received data: %@ fromPeerID: %@", s, peerID);
    }
    if (self.playtimeViewController) {
        [self.playtimeViewController gameUpdated:self.game];
    }
}

- (void) gameStarted:(LLSGame *) game;
{
    if (!self.playtimeViewController) {
        [self presentViewController:self.playtimeViewController animated:YES completion:nil];
        
        [self.playtimeViewController didMoveToParentViewController:self];
        //[self.playtimeViewController didRecieveNewTarget:game.myPlayer.targetBeaconId];
    }
    
    NSLog(@"gameStarted: %@", game);
    
}

- (void) gameUpdated:(LLSGame *)game;
{
    if (!self.playtimeViewController) {
        self.playtimeViewController = [[LLSPlaytimeViewController alloc]initWithGame:self.game];
        [self presentViewController:self.playtimeViewController animated:YES completion:nil];
        
        [self.playtimeViewController didMoveToParentViewController:self];
        //[self.playtimeViewController didRecieveNewTarget:game.myPlayer.targetBeaconId];
    }
    NSLog(@"gameUpdated:%@", game);
}

- (void) playerBeatYou:(LLSPlayer *)player;
{
    NSLog(@"playerBeatYou: %@", player);
}

@end
