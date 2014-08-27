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

@interface LLSViewController ()<LLSNetworkManagerProtocol, LLSGameProtocol>
@property (nonatomic,strong) IBOutlet UITextField *textField;
@property (nonatomic,strong) LLSNetworkManager *networkManager;
@property (nonatomic,strong) LLSGame *game;
@end

@implementation LLSViewController

- (IBAction) configureAction:(id)sender
{
    self.networkManager = [[LLSNetworkManager alloc] initWithDisplayName:self.textField.text serviceType:@"LLSService"];
    self.networkManager.networkManagerDelegate = self;
    self.game = [[LLSGame alloc] initWithNetworkManager:self.networkManager myBeaconId:@(1)];
    self.game.gameDelegate = self;

    [self.textField resignFirstResponder];
}

- (IBAction) browseAction:(id) sender;
{
    [self.networkManager browseForPeersWithViewController:self];
}

- (IBAction) startGameAction:(id) sender;
{
    [self.game startGame];
}

#pragma mark - LLSNetworkManagerProtocol

- (void) peerIDAdded:(MCPeerID *) peerID;
{
    [self.networkManager broadcast:self.game.serializedData toPeer:peerID];
}

- (void) dataReceived:(NSData *) data fromPeerID:(MCPeerID *) peerID;
{
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"dataReceived: %@ fromPeerID: %@", s, peerID);
}

- (void) gameStarted:(LLSGame *) game;
{
    NSLog(@"gameStarted: %@", game);
}

@end
