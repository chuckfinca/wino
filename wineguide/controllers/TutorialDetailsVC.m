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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImageView;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;

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
    [self.mainButton setTitleColor:[ColorSchemer sharedInstance].customWhite forState:UIControlStateNormal];
    
    NSString *text;
    
    switch (self.index) {
        case 0:
            text = @"The best way to find the perfect wine off a restaurant's menu.";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_logo.png"];
            self.mainButton.hidden = NO;
            [self.mainButton addTarget:self action:@selector(continueToNextPage:) forControlEvents:UIControlEventTouchUpInside];
            [self.mainButton setTitle:@"Swipe to see why -❯" forState:UIControlStateNormal];
            break;
        case 1:
            text = @"Within a few taps you'll be browsing the wine list of the restaurant your at, no typing required.";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_nearby.png"];
            self.mainButton.hidden = YES;
            break;
        case 2:
            text = @"The Corkie community makes choosing a wine simple by showing you what your friends like, community ratings and indepth reviews.";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_favorites.png"];
            self.mainButton.hidden = YES;
            break;
        case 3:
            text = @"As you try wines share them with your friends by checking them into your timeline using the Tried It button.";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_triedIt.png"];
            self.mainButton.hidden = NO;
            [self.mainButton addTarget:self action:@selector(dismissTutorial:) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    self.screenInstructionText.attributedText = attributedString;
    self.screenInstructionText.numberOfLines = 0;
    self.view.backgroundColor = [ColorSchemer sharedInstance].customWhite;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
        self.topSpaceLayoutConstraint.constant = 100;
    } else {
        self.topSpaceLayoutConstraint.constant = 0;
    }
    
    [self.view setNeedsUpdateConstraints];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueToNextPage:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Continue To Next Page" object:nil];
}

- (IBAction)dismissTutorial:(UIButton *)sender
{
    NSLog(@"dismissTutorial...");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss Tutorial" object:nil];
}

@end
