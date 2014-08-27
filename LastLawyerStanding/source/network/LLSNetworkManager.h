//
//  LLSNetworkManager.h
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MultipeerConnectivity;

@protocol LLSNetworkManagerProtocol<NSObject>
- (void) peerIDAdded:(MCPeerID *) peerID;
- (void) dataReceived:(NSData *) data fromPeerID:(MCPeerID *) peerID;
@end

@interface LLSNetworkManager : NSObject

@property (nonatomic,weak) id<LLSNetworkManagerProtocol> networkManagerDelegate;

- (instancetype) initWithDisplayName:(NSString *) displayName serviceType:(NSString *) serviceType;
- (void) browseForPeersWithViewController:(UIViewController *) viewController;

- (BOOL) broadcast:(NSDictionary *) dictionary toPeer:(MCPeerID *) peerID;
- (BOOL) broadcast:(NSDictionary *) dictionary;

@end