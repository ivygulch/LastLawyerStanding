//
//  IVVIViewController.h
//  LLSUserInterface
//
//  Created by Nathan Sjoquist on 8/26/14.
//  Copyright (c) 2014 Four of Six Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSBeaconRangeManager.h"
#import "LLSGame.h"
#import "LLSPlayer.h"

@interface LLSPlaytimeViewController : UIViewController<LLSBeaconRangeDelegate>

@property (nonatomic,strong) LLSPlayer* target;
@property (nonatomic,strong) LLSGame* gameController;
@property (nonatomic,strong) LLSBeaconRangeManager* targetTracker;


@end
