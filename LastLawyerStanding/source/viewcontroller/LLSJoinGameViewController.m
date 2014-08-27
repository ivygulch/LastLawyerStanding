//
//  LLSJoinGameViewController.m
//  LastLawyerStanding
//
//  Created by Nathan Sjoquist on 8/26/14.
//  Copyright (c) 2014 Ivy Gulch. All rights reserved.
//

#import "LLSJoinGameViewController.h"

@interface LLSJoinGameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *beconIDField;
@property (weak, nonatomic) IBOutlet UILabel *youAreHostLabel;
- (IBAction)joinGameAction:(id)sender;

@end

@implementation LLSJoinGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)sendJoinRequestWithID:(NSNumber*)idNumber{

    NSLog(@"login with id:%@",idNumber);

}
- (IBAction)joinGameAction:(id)sender {
    [self sendJoinRequestWithID:[NSNumber numberWithLong:self.beconIDField.text.longLongValue]];
}
@end
