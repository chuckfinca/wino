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
#import "ManagedObjectHandler.h"
#import "TastingRecord.h"
#import "Review.h"

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
        _userRatingsController.userCanEdit = YES;
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
    [self.checkInButton setTitleColor:[ColorSchemer sharedInstance].customWhite forState: UIControlStateNormal];
    [self setupHeaderLabels];
    [self setupEditButtons];
    [self setupWineNameLabel];
    [self setupRestaurantLabel];
    [self setupDateLabel];
    [self setupCancelButton];
    [self setupCheckInButton];
    
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





#define IDENTIFIER @"identifier"
#define DELETED_ENTITY @"deletedEntity"

- (IBAction)checkWineIntoTimeline:(UIButton *)sender
{
    // need to add user identifier!!!!
    
    Review *review = [self createReview];
    [self createTastingRecordWithReview:review];
}

-(Review *)createReview
{
    NSDate *date = [NSDate date];
    NSString *dateString = [date.description stringByReplacingOccurrencesOfString:@" " withString:@"" ];
    
    // need to add user identifier!!!!
    
    NSString *reviewIdentifier = @"userName";
    reviewIdentifier = [reviewIdentifier stringByAppendingString:self.wine.identifier];
    reviewIdentifier = [reviewIdentifier stringByAppendingString:dateString];
    
    NSPredicate *reviewPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",reviewIdentifier];
    
    Review *review = nil;
    review = (Review *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:@"Review" usingPredicate:reviewPredicate inContext:self.wine.managedObjectContext usingDictionary:@{IDENTIFIER : reviewIdentifier, DELETED_ENTITY : @0}];
    review.identifier = reviewIdentifier;
    review.rating = @(self.userRatingsController.rating);
    review.lastLocalUpdate = date;
    review.wine = self.wine;
    review.restaurant = self.restaurant;
    
    NSLog(@"review = %@",review.identifier);
    
    return review;
}

-(void)createTastingRecordWithReview:(Review *)review
{
    NSDate *date = [NSDate date];
    NSString *dateString = [date.description stringByReplacingOccurrencesOfString:@" " withString:@"" ];
    
    // need to add user identifier!!!!
    
    NSString *tastingRecordIdentifier = @"userName";
    tastingRecordIdentifier = [tastingRecordIdentifier stringByAppendingString:dateString];
    tastingRecordIdentifier = [tastingRecordIdentifier stringByAppendingString:self.wine.identifier];
    
    NSPredicate *tastingRecordPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",tastingRecordIdentifier];
    
    TastingRecord *tastingRecord = nil;
    tastingRecord = (TastingRecord *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:@"TastingRecord" usingPredicate:tastingRecordPredicate inContext:self.wine.managedObjectContext usingDictionary:@{IDENTIFIER : tastingRecordIdentifier, DELETED_ENTITY : @0}];
    tastingRecord.identifier = tastingRecordIdentifier;
    tastingRecord.addedDate = [NSDate date];
    tastingRecord.tastingDate = [NSDate date];
    tastingRecord.review = review;
    
    NSLog(@"tastingRecord = %@",tastingRecord.identifier);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
