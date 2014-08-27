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

@interface LLSViewController ()<LLSNetworkManagerProtocol>
@property (nonatomic,strong) LLSNetworkManager *networkManager;
@property (nonatomic,strong) LLSGame *game;
@end

@implementation LLSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.networkManager = [[LLSNetworkManager alloc] initWithDisplayName:@"me" serviceType:@"LLSService"];
    self.game = [[LLSGame alloc] initWithNetworkManager:self.networkManager myBeaconId:@(1)];
}

- (IBAction) browseAction:(id) sender;
{
    [self.networkManager browseForPeersWithViewController:self];
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

@end
