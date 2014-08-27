//
//  IVVIViewController.h
//  LLSUserInterface
//
//  Created by Nathan Sjoquist on 8/26/14.
//  Copyright (c) 2014 Four of Six Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLSPlaytimeViewController : UIViewController

@property (nonatomic,strong) id target;
@property (nonatomic,strong) id gameController;
@property (nonatomic,strong) id targetTracker;


-(void)sendNameForTargetID:(NSString*)name;
-(void)didRecieveResponseToNameSubmission:(BOOL)targetValid;


@end
