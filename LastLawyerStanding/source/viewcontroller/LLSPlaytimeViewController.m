//
//  IVVIViewController.m
//  LLSUserInterface
//
//  Created by Nathan Sjoquist on 8/26/14.
//  Copyright (c) 2014 Four of Six Apps. All rights reserved.
//

#import "LLSPlaytimeViewController.h"
#import "LLSLosingViewController.h"

@interface LLSPlaytimeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberServedLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberRemainingLabel;
@property (nonatomic,assign) long numberServed;
@property (nonatomic,assign) long numberRemaining;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UITextField *targetNameField;
@property (weak, nonatomic) IBOutlet UIButton *issueSubpeonaButton;
@property (weak, nonatomic) IBOutlet UILabel *proxyWarningLabel;

@property (nonatomic,assign) BOOL enableSubpeonasFromProximity;
@property (nonatomic,assign) BOOL enableSubpeonasFromField;

- (IBAction)issueSubpeona:(id)sender;
- (IBAction)edditingBegan:(id)sender;



@end

@implementation LLSPlaytimeViewController


- (void) gameStarted:(LLSGame *) game;
{
//handled in LLSViewController.m
}
//you got beat
//say you beat
- (void) gameUpdated:(LLSGame *) game;{
    
    int countRemaining = 0;
    
    for (LLSPlayer* player in [self.gameController.players allValues]) {
        if (![player.winnerBeaconId isEqualToNumber:@0]) {
            countRemaining++;
        }
    }
    self.numberRemaining = countRemaining;
    
    self.numberRemainingLabel.text = [NSString stringWithFormat:@"%lu",self.numberRemaining];
    
    [self didRecieveNewTarget:self.gameController.myPlayer.targetBeaconId];

}
- (void) playerBeatYou:(LLSPlayer *) player;{
    
    [self handleLoss];

}

-(void)handleLoss{

    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    LLSLosingViewController* losingVC = [sb instantiateViewControllerWithIdentifier:@"kLLSLosingViewControllerID"];
    
    [self presentViewController:losingVC animated:YES completion:nil];

}

- (id)initWithGame:(LLSGame*)game{

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [sb instantiateViewControllerWithIdentifier:@"kLLSPlaytimeViewControllerID"];
    self.gameController = game;
    game.gameDelegate = self;
    self.player = game.myPlayer;
    
    self.numberRemaining = [game.players count]-1;
    self.numberRemainingLabel.text = [NSString stringWithFormat:@"%lu",self.numberRemaining];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.targetNameField.delegate = self;
    self.issueSubpeonaButton.enabled = NO;
    self.enableSubpeonasFromProximity = NO;
    self.numberServed = 0;
    
    //TODO:--> remove this debug code
    [self didRecieveNewTarget:self.gameController.myPlayer.targetBeaconId];
    
    //self.targetTracker.aDelegate = self;
    //self.gameController.aDelegate = self;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)issueSubpeona:(id)sender {
    [self.targetNameField resignFirstResponder];
    self.issueSubpeonaButton.enabled = NO;
    self.enableSubpeonasFromField = NO;
    
    NSNumber* listedNumber = [NSNumber numberWithLongLong:self.targetNameField.text.longLongValue];
    
    if ([self.gameController.myPlayer.targetBeaconId isEqualToNumber:listedNumber]) {
        NSLog(@"issue to %@",self.targetNameField.text);
        //self.proxyWarningLabel.text = @"SERVED!";
        //self.proxyWarningLabel.textColor = [UIColor greenColor];
        
        self.numberServed++;
        self.numberServedLabel.text = [NSString stringWithFormat:@"%lu"
                                       ,self.numberServed];
        
        [self.gameController beatMyTarget];
        
        UILabel* successLabel = [[UILabel alloc]initWithFrame:(CGRect){0,0,self.view.bounds.size.width,self.view.bounds.size.width}];
        successLabel.font = [UIFont systemFontOfSize:100];
        successLabel.textColor = [UIColor greenColor];
        successLabel.text = self.targetNameField.text;
        successLabel.contentMode = UIViewContentModeCenter;
        successLabel.textAlignment = NSTextAlignmentCenter;
        successLabel.alpha = 0;
        [self.view addSubview:successLabel];
        [UIView animateWithDuration:1 animations:^{
            successLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                successLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [successLabel removeFromSuperview];
                
            }];
        }];
    }
    
}

- (IBAction)edditingBegan:(id)sender {
    NSLog(@"begin edditing");
    self.enableSubpeonasFromField = YES;
   if (self.enableSubpeonasFromProximity)self.issueSubpeonaButton.enabled = YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
   
    [self.targetNameField resignFirstResponder];
    return YES;

}             // called when 'return' key pressed. return NO to ignore.

-(void)didRecieveNewTarget:(NSNumber*)tgtNumber{
    if (tgtNumber){
    self.targetTracker = nil;
    
    self.gameController.myPlayer.targetBeaconId = tgtNumber;
    
    self.targetTracker = [[LLSBeaconRangeManager alloc]initWithMinor:tgtNumber];
    self.targetTracker.beaconDelegate = self;
    
    self.proxyWarningLabel.text = @"PROXIMITY WARNING!!!";
    }

}
- (void)beaconVisible;
{
    [self showYellowForVisableTarget];
    self.enableSubpeonasFromProximity = NO;
    self.issueSubpeonaButton.enabled = NO;

}
- (void)beaconInvisible;
{
    [self makeInvisableForInvisableTarget];
    self.enableSubpeonasFromProximity = NO;
    self.issueSubpeonaButton.enabled = NO;

}
- (void)beaconImmediate;
{
    [self flashRedForImmediateTarget];
    self.enableSubpeonasFromProximity = YES;
    if (self.enableSubpeonasFromField)self.issueSubpeonaButton.enabled = YES;

}
-(void)makeInvisableForInvisableTarget{
    self.proxyWarningLabel.hidden = YES;
}
-(void)showYellowForVisableTarget{
    self.proxyWarningLabel.hidden = NO;
    self.proxyWarningLabel.textColor = [UIColor yellowColor];
}
-(void)flashRedForImmediateTarget{
    self.proxyWarningLabel.hidden = NO;
    self.proxyWarningLabel.textColor = [UIColor redColor];
}



@end
