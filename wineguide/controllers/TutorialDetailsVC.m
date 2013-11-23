//
//  TutorialDetailsVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TutorialDetailsVC.h"
#import "ColorSchemer.h"

@interface TutorialDetailsVC ()

@end

@implementation TutorialDetailsVC

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
    
    NSString *text;
    
    switch (self.index) {
        case 0:
            text = @"Welcome to Gimmee, the best way to find the perfect wine off that menu!";
            break;
        case 1:
            text = @"Browse wines at restaurants nearby";
            break;
        case 2:
            text = @"Search for specific wines";
            break;
        case 3:
            text = @"Favorite wines you want to remember";
            break;
        case 4:
            text = @"Some more instructions";
            break;
        default:
            break;
    }
    
    self.screenInstructionText.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    self.screenInstructionText.numberOfLines = 0;
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissTutorial:(UIButton *)sender
{
    NSLog(@"dismissTutorial...");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss Tutorial" object:nil];
}

@end
