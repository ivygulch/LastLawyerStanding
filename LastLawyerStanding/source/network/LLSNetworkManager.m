//
//  LLSNetworkManager.m
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSNetworkManager.h"

@import MultipeerConnectivity;

@interface LLSNetworkManager()<MCSessionDelegate,MCBrowserViewControllerDelegate>
@property (nonatomic,strong) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic,strong) MCSession *session;
@property (nonatomic,copy) NSString *serviceType;
@end

@implementation LLSNetworkManager

- (instancetype) initWithDisplayName:(NSString *) displayName serviceType:(NSString *) serviceType;
{
    if ((self = [super init])) {
        MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
        _session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionRequired];
        _session.delegate = self;
        _serviceType = serviceType;
        _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceType discoveryInfo:nil session:_session];
        [_advertiserAssistant start];
    }
    return self;
}

- (void) browseForPeersWithViewController:(UIViewController *) viewController;
{
    MCBrowserViewController *browserViewController = [[MCBrowserViewController alloc] initWithServiceType:self.serviceType session:self.session];
	browserViewController.delegate = self;
    browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers;
    browserViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers;

    [viewController presentViewController:browserViewController animated:YES completion:nil];
}

@end
