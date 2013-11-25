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
            text = @"Welcome to Gimme, the best way to find the perfect wine off that menu!";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_logo.png"];
            break;
        case 1:
            text = @"Checkout wines at nearby restaurants";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_nearby.png"];
            break;
        case 2:
            text = @"Browse by value or popularity";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_nearby.png"];
            break;
        case 3:
            text = @"Favorite wines you want to remember";
            self.tutorialImageView.image = [UIImage imageNamed:@"tutorial_favorites.png"];
            break;
        default:
            break;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    if(self.index == 0){
        [attributedString addAttributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].baseColor} range:NSMakeRange(11, 5)];
    }
    self.screenInstructionText.attributedText = attributedString;
    self.screenInstructionText.numberOfLines = 0;
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.97];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
        self.topSpaceLayoutConstraint.constant = 100;
    } else {
        self.topSpaceLayoutConstraint.constant = 0;
    }
    
    [self.view setNeedsLayout];
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
