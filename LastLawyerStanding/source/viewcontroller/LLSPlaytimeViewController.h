//
//  IVVIViewController.h
//  LLSUserInterface
//
//  Created by Nathan Sjoquist on 8/26/14.
//  Copyright (c) 2014 Four of Six Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLSPlaytimeViewController : UIViewController

-(void)sendNameForTargetID:(NSString*)name;
-(void)didRecieveResponseToNameSubmission:(BOOL)targetValid;


@end
