//
//  HomeViewController.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *findWinesButton;
@property (weak, nonatomic) IBOutlet UITextView *appDescriptionTV;

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
    [self setupText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup

-(void)setupText
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *buttonText = @"Find restaurants near me";
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:buttonText attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.findWinesButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
    
    NSString *appDescriptionText = @"The quick and easy way to find a perfect wine off that menu.";
    self.appDescriptionTV.attributedText = [[NSAttributedString alloc] initWithString:appDescriptionText attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline], NSParagraphStyleAttributeName : paragraphStyle}];
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
