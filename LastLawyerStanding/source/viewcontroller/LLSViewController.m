//
//  LLSViewController.m
//  LastLawyerStanding
//
//  Created by Douglas Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSViewController.h"
#import "LLSNetworkManager.h"

@interface LLSViewController ()
@property (nonatomic,strong) LLSNetworkManager *networkManager;
@end

@implementation LLSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.networkManager = [[LLSNetworkManager alloc] initWithDisplayName:@"me" serviceType:@"LLSService"];
}

- (IBAction) browseAction:(id) sender;
{
    [self.networkManager browseForPeersWithViewController:self];
}

@end
