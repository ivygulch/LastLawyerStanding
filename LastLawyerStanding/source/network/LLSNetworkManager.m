//
//  LLSNetworkManager.m
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSNetworkManager.h"

@interface LLSNetworkManager()<MCSessionDelegate,MCBrowserViewControllerDelegate>
@property (nonatomic,strong) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic,strong) MCSession *session;
@property (nonatomic,copy) NSString *serviceType;
@property (nonatomic,strong) NSMutableSet *peers;
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

        _peers = [NSMutableSet set];
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

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;
{
    NSLog(@"session:peer:%@ didChangeState:%d", peerID.displayName, state);
    if (state == MCSessionStateConnected) {
        [self.peers addObject:peerID];
        [self.networkManagerDelegate peerIDAdded:peerID];
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
{
    NSLog(@"session:didReceiveData:%u fromPeer:%@", [data length], peerID.displayName);
    [self.networkManagerDelegate dataReceived:data fromPeerID:peerID];
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID;
{
    NSLog(@"session:didReceiveStream:withName:%@ fromPeer:%@", streamName, peerID.displayName);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress;
{
    NSLog(@"session:didStartReceivingResourceWithName:%@ fromPeer:%@", resourceName, peerID.displayName);
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error;
{    
    NSLog(@"session:didFinishReceivingResourceWithName:%@ fromPeer:%@", resourceName, peerID.displayName);
}

#pragma mark - MCBrowserViewControllerDelegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController;
{
    NSLog(@"browserViewControllerDidFinish");
    [browserViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController;
{
    NSLog(@"browserViewControllerWasCancelled");
    [browserViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (BOOL) broadcast:(NSDictionary *) dictionary toPeer:(MCPeerID *) peerID;
{
    return [self broadcast:dictionary toPeers:@[peerID]];
}

- (BOOL) broadcast:(NSDictionary *) dictionary;
{
    if ([self.peers count] > 0) {
        return [self broadcast:dictionary toPeers:[self.peers allObjects]];
    } else {
        return NO;
    }
}

- (BOOL) broadcast:(NSDictionary *) dictionary toPeers:(NSArray *) peers;
{
    NSError *error;
    NSData *serialized = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (!serialized) {
        NSLog(@"Could not serialize: %@\n%@", dictionary, error);
        return NO;
    }

    if (![self.session sendData:serialized
                   toPeers:peers
                  withMode:MCSessionSendDataReliable
                          error:&error]) {
        NSLog(@"Could not sendData: %@\n%@", dictionary, error);
        return NO;
    }
    return YES;
}

@end
