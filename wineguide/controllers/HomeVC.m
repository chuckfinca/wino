//
//  HomeViewController.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC () <UIAlertViewDelegate>

@property (nonatomic) BOOL hasAgreedToLocationServices;

@end

@implementation HomeVC

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



#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"FindRestaurantsNearby"]){
        NSLog(@"identifier = %@",identifier);
        if(!self.hasAgreedToLocationServices){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable location services?" message:@"Wine Guide would like to use your location." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}



#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        self.hasAgreedToLocationServices = YES;
        [self performSegueWithIdentifier:@"FindRestaurantsNearby" sender:self];
    }
}

@end
