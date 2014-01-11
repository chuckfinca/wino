//
//  CheckInVC.m
//  Corkie
//
//  Created by Charles Feinn on 1/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "CheckInVC.h"
#import "UserRatingCVController.h"
#import "ManagedObjectHandler.h"
#import "FontThemer.h"
#import "ColorSchemer.h"
#import "Review.h"
#import "TastingRecord.h"

#define CORNER_RADIUS 4
#define CHECK_IN_VC_VIEW_HEIGHT 230

@interface CheckInVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelCheckInButton;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTV;
@property (weak, nonatomic) IBOutlet UIView *userRatingView;
@property (weak, nonatomic) IBOutlet UIView *userRatingViewContainerView;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;

@property (nonatomic, strong) Wine *wine;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) UserRatingCVController *userRatingsController;

@end

@interface CheckInVC ()

@end

@implementation CheckInVC

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
    NSLog(@"CheckInVC viewDidLoad...");
	// Do any additional setup after loading the view.
    [self setup];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupUserRatingsController];
    [self.noteTV becomeFirstResponder];
    self.noteTV.delegate = self;
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

-(void)setupWithWine:(id)wine andRestaurant:(id)restaurant
{
    self.wine = wine;
    self.restaurant = restaurant;
    
    [self setupBackground];
}

-(void)setupBackground
{
    CALayer *layer = self.view.layer;
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setShadowColor:[ColorSchemer sharedInstance].shadowColor.CGColor];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.5];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 300, CHECK_IN_VC_VIEW_HEIGHT)
                                           byRoundingCorners: (UIRectCornerTopLeft | UIRectCornerTopRight)
                                                 cornerRadii: (CGSize){CORNER_RADIUS, CORNER_RADIUS}].CGPath;
    self.headerBackgroundView.layer.mask = maskLayer;
    
    self.view.backgroundColor = [UIColor lightGrayColor];//[ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setup
{
    NSLog(@"asdfasdfasdfasdasdfasd");
    self.title = @"Tried It";
    [self.checkInButton setTitleColor:[ColorSchemer sharedInstance].customWhite forState: UIControlStateNormal];


    [self setupPrompt];
    [self setupRestaurantButton];
    [self setupDateButton];
    [self setupCancelButton];
    [self setupCheckInButton];
    
}



-(void)setupPrompt
{
    NSString *text = [NSString stringWithFormat:@"What did you think about the %@?",[self.wine.name capitalizedString]];
    self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
}

-(void)setupRestaurantButton
{
    NSString *text;
    if(self.restaurant.name){
        text = [self.restaurant.name capitalizedString];
    } else {
        text = @"Select Restaurant";
    }
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body}];
    [self.restaurantButton setAttributedTitle:attributed forState:UIControlStateNormal];
}

-(void)setupDateButton
{
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:@"Now" attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body}];
    [self.dateButton setAttributedTitle:attributed forState:UIControlStateNormal];
}

-(void)setupCancelButton
{
    NSLog(@"setup cancel button");
}

-(void)setupCheckInButton
{
    NSLog(@"setup check in button");
}

-(void)setupUserRatingsController
{
    self.userRatingsController.wine = self.wine;
    self.userRatingsController.collectionView.frame = self.userRatingView.bounds;
    [self.userRatingView addSubview:self.userRatingsController.collectionView];
}


#pragma mark - Target Action

- (IBAction)createTastingRecord:(UIButton *)sender
{
    NSLog(@"createTastingRecord...");
    Review *review = [self createReview];
    [self createTastingRecordWithReview:review];
}

#define IDENTIFIER @"identifier"
#define DELETED_ENTITY @"deletedEntity"

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
    review.reviewText = self.noteTV.text;
    
    NSLog(@"review = %@",review.identifier);
    NSLog(@"reviewText = %@",review.reviewText);
    
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


- (IBAction)segueToDateAndRestaurantEditVC:(id)sender
{
    NSLog(@"segueToDateAndRestaurantEditVC...");
}

#pragma mark

- (void)textViewDidChange:(UITextView *)txtView
{
    self.promptLabel.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.promptLabel.hidden = ([txtView.text length] > 0);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
