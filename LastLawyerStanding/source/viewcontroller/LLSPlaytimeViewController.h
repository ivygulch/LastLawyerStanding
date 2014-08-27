//
//  IVVIViewController.h
//  LLSUserInterface
//
//  Created by Nathan Sjoquist on 8/26/14.
//  Copyright (c) 2014 Four of Six Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSBeaconRangeManager.h"

@interface LLSPlaytimeViewController : UIViewController<LLSBeaconRangeDelegate>

@property (nonatomic,strong) id target;
@property (nonatomic,strong) id gameController;
@property (nonatomic,strong) LLSBeaconRangeManager* targetTracker;


-(void)sendNameForTargetID:(NSString*)name;
-(void)didRecieveResponseToNameSubmission:(BOOL)targetValid;


@end
