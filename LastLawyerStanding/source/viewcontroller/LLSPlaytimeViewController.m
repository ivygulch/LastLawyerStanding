//
//  IVVIViewController.m
//  LLSUserInterface
//
//  Created by Nathan Sjoquist on 8/26/14.
//  Copyright (c) 2014 Four of Six Apps. All rights reserved.
//

#import "LLSPlaytimeViewController.h"

@interface LLSPlaytimeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberServedLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UITextField *targetNameField;
@property (weak, nonatomic) IBOutlet UIButton *issueSubpeonaButton;
@property (weak, nonatomic) IBOutlet UILabel *proxyWarningButton;
- (IBAction)issueSubpeona:(id)sender;
- (IBAction)edditingBegan:(id)sender;

@end

@implementation LLSPlaytimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.targetNameField.delegate = self;
    self.issueSubpeonaButton.enabled = NO;
    
    [self didRecieveNewTarget:[NSNumber numberWithLong:127]];
    
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
    NSLog(@"issue to %@",self.targetNameField.text);
    
}

- (IBAction)edditingBegan:(id)sender {
    NSLog(@"begin edditing");
    self.issueSubpeonaButton.enabled = YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
   
    [self.targetNameField resignFirstResponder];
    return YES;

}             // called when 'return' key pressed. return NO to ignore.

-(void)didRecieveNewTarget:(NSNumber*)tgtNumber{
    
    self.targetTracker = [[LLSBeaconRangeManager alloc]initWithMinor:tgtNumber];
    self.targetTracker.beaconDelegate = self;

}
- (void)beaconVisible;
{
    [self showYellowForVisableTarget];
}
- (void)beaconInvisible;
{
    [self makeInvisableForInvisableTarget];
}
- (void)beaconImmediate;
{
    [self flashRedForImmediateTarget];
}
-(void)makeInvisableForInvisableTarget{
    self.proxyWarningButton.hidden = YES;
}
-(void)showYellowForVisableTarget{
    self.proxyWarningButton.hidden = NO;
    self.proxyWarningButton.textColor = [UIColor yellowColor];
}
-(void)flashRedForImmediateTarget{
    self.proxyWarningButton.hidden = NO;
    self.proxyWarningButton.textColor = [UIColor redColor];
}

@end
