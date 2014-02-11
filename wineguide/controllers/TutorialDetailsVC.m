//
//  TutorialDetailsVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TutorialDetailsVC.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

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
    NSRange title = NSMakeRange(0, 0);
    
    switch (self.index) {
        case 0:
            text = @"Wine made easy.\n\n\n";
            // @"The best way to find the perfect wine off a restaurant's menu.";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_logo.png"];
            self.mainButton.hidden = NO;
            [self.mainButton addTarget:self action:@selector(continueToNextPage:) forControlEvents:UIControlEventTouchUpInside];
            [self.mainButton setTitle:@"Learn more -❯" forState:UIControlStateNormal];
            break;
        case 1:
            text = @"Discover";
            title = NSMakeRange(0, [text length]);
            text = [text stringByAppendingString:@"\n\nView summarized wine lists and recommendations from your friends and experts"];
            // @"Within a few taps you'll be browsing the wine list of the restaurant your at, no typing required.";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_nearby.png"];
            self.mainButton.hidden = YES;
            break;
        case 2:
            text = @"Track";
            title = NSMakeRange(0, [text length]);
            text = [text stringByAppendingString:@"\n\nCreate a timeline of wines you try and save your favorites to your cellar"];
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_triedIt.png"];
            self.mainButton.hidden = NO;
            [self.mainButton addTarget:self action:@selector(dismissTutorial:) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    [attributedString addAttributes:@{NSFontAttributeName : [FontThemer sharedInstance].headline} range:title];
    self.screenInstructionText.attributedText = attributedString;
    self.screenInstructionText.numberOfLines = 0;
    self.view.backgroundColor = [ColorSchemer sharedInstance].customWhite;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
        self.topSpaceLayoutConstraint.constant = 70;
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
