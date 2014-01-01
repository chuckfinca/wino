//
//  TriedItVC.m
//  Corkie
//
//  Created by Charles Feinn on 12/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TriedItVC.h"
#import "WineNameVHTV.h"
#import "ColorSchemer.h"
#import "UserRatingCVController.h"

@interface TriedItVC ()

@property (weak, nonatomic) IBOutlet UILabel *wineHeaderLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet UIButton *changeWineButton;
@property (weak, nonatomic) IBOutlet UILabel *restaurantHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeRestaurantButton;
@property (weak, nonatomic) IBOutlet UILabel *dateHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeDateButton;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIView *userRatingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingHeaderLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *glassOrBottleSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *segmentedControlLabel;
@property (nonatomic, strong) Wine *wine;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) UserRatingCVController *userRatingsController;
@end

@implementation TriedItVC

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
    [self setup];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userRatingsController.wine = self.wine;
    self.userRatingsController.collectionView.frame = self.userRatingView.bounds;
    [self.userRatingView addSubview:self.userRatingsController.collectionView];
}

#pragma mark - Getters & Setters

-(UserRatingCVController *)userRatingsController
{
    if(!_userRatingsController) {
        _userRatingsController = [[UserRatingCVController alloc] initWithCollectionViewLayout:[[UICollectionViewLayout alloc] init]];
    }
    return _userRatingsController;
}

#pragma mark - Setup

-(void)setupWithWine:(Wine *)wine andRestaurant:(Restaurant *)restaurant
{
    self.wine = wine;
    self.restaurant = restaurant;
    
    [self setup];
}

-(void)setup
{
    self.title = @"Tried It";
    [self setupHeaderLabels];
    [self setupEditButtons];
    [self setupWineNameLabel];
    [self setupRestaurantLabel];
    [self setupDateLabel];
    [self setupCancelButton];
    [self setupCheckInButton];
    [self setupSegmentedControlLabel];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupHeaderLabels
{
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary};
    self.wineHeaderLabel.attributedText = [[NSAttributedString alloc] initWithString:@"WINE" attributes:attributes];
    
    self.ratingHeaderLabel.attributedText = [[NSAttributedString alloc] initWithString:@"RATING" attributes:attributes];
    self.restaurantHeaderLabel.attributedText = [[NSAttributedString alloc] initWithString:@"RESTAURANT" attributes:attributes];
    self.dateHeaderLabel.attributedText = [[NSAttributedString alloc] initWithString:@"DATE" attributes:attributes];
}

-(void)setupEditButtons
{
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"edit" attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textLink}];
    [self.changeWineButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [self.changeRestaurantButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [self.changeDateButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

-(void)setupWineNameLabel
{
    if(self.wine.name){
        [self.wineNameVHTV setupTextViewWithWine:self.wine fromRestaurant:nil];
    }
}

-(void)setupRestaurantLabel
{
    if(self.restaurant.name){
        self.restaurantNameLabel.attributedText = [[NSAttributedString alloc] initWithString:[self.restaurant.name capitalizedString] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    }
}

-(void)setupDateLabel
{
    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Today" attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
}

-(void)setupSegmentedControlLabel
{
    int index = self.glassOrBottleSegmentedControl.selectedSegmentIndex;
    
    NSString *text;
    if(index == 0){
        text = @"glass";
    } else {
        text = @"bottle";
    }
    self.segmentedControlLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
}

-(void)setupCancelButton
{
    NSLog(@"setup cancel button");
}

-(void)setupCheckInButton
{
    NSLog(@"setup check in button");
}

#pragma mark - Target Action

- (IBAction)dismissVC:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated complete");
    }];
}

- (IBAction)checkWineIntoTimeline:(UIButton *)sender
{
    NSLog(@"wine checked in!");
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    [self setupSegmentedControlLabel];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
