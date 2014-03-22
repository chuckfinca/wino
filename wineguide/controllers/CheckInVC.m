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
#import "MotionEffects.h"
#import "FriendListVC.h"
#import "TransitionAnimator_CheckInFriends.h"

#define CORNER_RADIUS 4
#define CHECK_IN_VC_VIEW_HEIGHT 230

@interface CheckInVC () <UITextViewDelegate, UIViewControllerTransitioningDelegate, FriendListVcDelegate>

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

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.noteTV.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupUserRatingsController];
    [self.noteTV becomeFirstResponder];
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
    
    [self setupPrompt];
    [self setupRestaurantText];
}



-(void)setup
{
    self.view.backgroundColor = [ColorSchemer sharedInstance].customWhite;
    self.headerBackgroundView.backgroundColor = [ColorSchemer sharedInstance].baseColor;
    [self setupBackground];
    [self setupUserRatingView];
    [self setupRestaurantButton];
    [self setupDateButton];
    [self setupCancelButton];
    [self setupCheckInButton];
}

-(void)setupBackground
{
    CALayer *layer = self.view.layer;
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setShadowColor:[ColorSchemer sharedInstance].shadowColor.CGColor];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.2];
    
    [self addBorderToLayer:layer];
    
}

-(void)setupUserRatingView
{
    self.userRatingViewContainerView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.userRatingView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupPrompt
{
    NSString *text = [NSString stringWithFormat:@"What did you think about the %@?",[self.wine.name capitalizedString]];
    self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPlaceholder}];
}

-(void)setupRestaurantButton
{
    self.restaurantButton.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    [self addBorderToLayer:self.restaurantButton.layer];
}

-(void)setupRestaurantText
{
    NSString *text;
    if(self.restaurant.name){
        text = [NSString stringWithFormat:@"@ %@",[self.restaurant.name capitalizedString]];
    } else {
        text = @"Select Restaurant";
    }
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    [self.restaurantButton setAttributedTitle:attributed forState:UIControlStateNormal];
}

-(void)addBorderToLayer:(CALayer *)layer
{
    [layer setBorderColor:[ColorSchemer sharedInstance].baseColor.CGColor];
    [layer setBorderWidth:0.25];
}

-(void)setupDateButton
{
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:@"Now" attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    [self.dateButton setAttributedTitle:attributed forState:UIControlStateNormal];
    
    self.dateButton.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    [self addBorderToLayer:self.dateButton.layer];
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
    [self addBorderToLayer:self.userRatingViewContainerView.layer];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier  isEqual: @"AddFriends"]){
        NSLog(@"Add friends segue");
        FriendListVC *friendListVC = segue.destinationViewController;
        friendListVC.transitioningDelegate = self;
        friendListVC.modalTransitionStyle = UIModalPresentationCustom;
        friendListVC.delegate = self;
    }
}



#pragma mark - Target Action

- (IBAction)createTastingRecord:(UIButton *)sender
{
    if(self.userRatingsController.rating > 0){
        NSLog(@"createTastingRecord...");
        Review *review = [self createReview];
        [self createTastingRecordWithReview:review];
        
        [self.delegate dismissAfterTastingRecordCreation];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please provide a wine glass rating." delegate:self cancelButtonTitle:nil  otherButtonTitles:@"Ok", nil];
        alert.tintColor = [ColorSchemer sharedInstance].clickable;
        
        [MotionEffects addMotionEffectsToView:alert];
        [alert show];
    }
}

- (IBAction)changeDate:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Date changing coming soon." delegate:self cancelButtonTitle:nil  otherButtonTitles:@"Ok", nil];
    alert.tintColor = [ColorSchemer sharedInstance].clickable;
    
    [MotionEffects addMotionEffectsToView:alert];
    [alert show];}

- (IBAction)changeRestaurant:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant changing coming soon." delegate:self cancelButtonTitle:nil  otherButtonTitles:@"Ok", nil];
    alert.tintColor = [ColorSchemer sharedInstance].clickable;
    
    [MotionEffects addMotionEffectsToView:alert];
    [alert show];
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
    
    if([[self.noteTV.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0){
        review.reviewText = self.noteTV.text;
    }
    
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
}


- (IBAction)segueToDateAndRestaurantEditVC:(id)sender
{
    NSLog(@"segueToDateAndRestaurantEditVC...");
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)txtView
{
    self.promptLabel.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.promptLabel.hidden = ([txtView.text length] > 0);
}


#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                 presentingController:(UIViewController *)presenting
                                                                     sourceController:(UIViewController *)source
{
    TransitionAnimator_CheckInFriends *animator = [TransitionAnimator_CheckInFriends new];
    animator.presenting = YES;
    return animator;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [TransitionAnimator_CheckInFriends new];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FriendListVcDelegate

-(void)checkIn
{
    NSLog(@"checkIn...");
}

-(void)backFromVC:(UIViewController *)dismissed
{
    NSLog(@"backToDetails...");
    [self dismissViewControllerAnimated:YES completion:^{}];
}



@end
