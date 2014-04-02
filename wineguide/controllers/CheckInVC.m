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
#import "FriendListVC.h"
#import "TransitionAnimator_CheckInFriends.h"
#import "FacebookSessionManager.h"
#import "ReviewDataHelper.h"
#import "TastingRecordDataHelper.h"

#define CORNER_RADIUS 4
#define CHECK_IN_VC_VIEW_HEIGHT 230

#define ADDED_DATE @"addedDate"
#define CLAIMED_BY_USER @"claimedByUser"
#define DELETED_ENTITY @"deletedEntity"
#define IDENTIFIER @"identifier"
#define RATING @"rating"
#define REVIEW_TEXT @"reviewText"
#define REVIEW_DATE @"reviewDate"
#define UPDATED_DATE @"updatedDate"
#define RESTAURANT @"restaurant"

#define TASTING_DATE @"tastingDate"

@interface CheckInVC () <UITextViewDelegate, UIViewControllerTransitioningDelegate, FriendListVcDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelCheckInButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTV;
@property (weak, nonatomic) IBOutlet UIView *userRatingView;
@property (weak, nonatomic) IBOutlet UIView *userRatingViewContainerView;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) Wine *wine;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) UserRatingCVController *userRatingsController;
@property (nonatomic, strong) NSArray *selectedFriends;
@property (nonatomic) BOOL datePickerVisible;
@property (nonatomic, strong) NSDate *selectedDate;

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
    [self setupContinueButton];
}

-(void)setupBackground
{
    CALayer *layer = self.view.layer;
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setShadowColor:[ColorSchemer sharedInstance].shadowColor.CGColor];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.2];
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
    NSAttributedString *attributed;
    
    NSString *text;
    if(self.restaurant.name){
        text = [NSString stringWithFormat:@"@ %@",[self.restaurant.name capitalizedString]];
    } else {
        text = @"Select Restaurant";
    }
    attributed = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    
    [self.restaurantButton setAttributedTitle:attributed forState:UIControlStateNormal];
}

-(void)addBorderToLayer:(CALayer *)layer
{
    [layer setBorderColor:[ColorSchemer sharedInstance].gray.CGColor];
    [layer setBorderWidth:0.25];
}

-(void)setupDateButton
{
    NSAttributedString *attributed;
    
    if(self.datePickerVisible){
        attributed  = [[NSAttributedString alloc] initWithString:@"Save" attributes:@{NSFontAttributeName : [FontThemer sharedInstance].headline, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].clickable}];
    } else {
        if(self.selectedDate){
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, yy"];
            NSString *newDate = [formatter stringFromDate:self.selectedDate];
            
            if([[formatter stringFromDate:[NSDate date]] isEqualToString:newDate]){
                attributed  = [[NSAttributedString alloc] initWithString:@"Now" attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
                
            } else {
                attributed  = [[NSAttributedString alloc] initWithString:newDate attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
            }
            
            
        } else {
            attributed  = [[NSAttributedString alloc] initWithString:@"Now" attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
        }
    }
    
    [self.dateButton setAttributedTitle:attributed forState:UIControlStateNormal];
    
    self.dateButton.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    [self addBorderToLayer:self.dateButton.layer];
}

-(void)setupCancelButton
{
    NSLog(@"setup cancel button");
}

-(void)setupContinueButton
{
    [self.continueButton setAttributedTitle:[[NSAttributedString alloc] initWithString:self.continueButton.titleLabel.text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].headline}] forState:UIControlStateNormal];
}

-(void)setupUserRatingsController
{
    self.userRatingsController.wine = self.wine;
    self.userRatingsController.collectionView.frame = self.userRatingView.bounds;
    [self.userRatingView addSubview:self.userRatingsController.collectionView];
    [self addBorderToLayer:self.userRatingViewContainerView.layer];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqual:@"CancelCheckIn"]){
        if(self.datePickerVisible){
            [self showHideDatePicker];
            return NO;
        }
    }
    
    if([identifier isEqualToString:@"AddFriends"]){
        if(!self.userRatingsController.rating){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please provide a wine glass rating." delegate:self cancelButtonTitle:nil  otherButtonTitles:@"Ok", nil];
            alert.tintColor = [ColorSchemer sharedInstance].clickable;
            
            [alert show];
            return NO;
        }
    }
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual: @"AddFriends"]){
        NSLog(@"Add friends segue");
        FriendListVC *friendListVC = segue.destinationViewController;
        friendListVC.transitioningDelegate = self;
        friendListVC.modalTransitionStyle = UIModalPresentationCustom;
        
        friendListVC.delegate = self;
        friendListVC.wineName = [self.wine.name capitalizedString];
        friendListVC.selectedFriends = [self.selectedFriends mutableCopy];
    }
}



#pragma mark - Target Action

- (IBAction)changeDate:(UIButton *)sender
{
    if(self.datePickerVisible){
        // Save the new date
        self.selectedDate = self.datePicker.date;
    }
    
    [self showHideDatePicker];
}

-(void)showHideDatePicker
{
    float animationTime = 0.3;
    NSInteger viewHeightAdjustment = 200;
    
    if(self.datePickerVisible){
        self.datePickerVisible = NO;
        [UIView animateWithDuration:animationTime animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-viewHeightAdjustment);
            [self.noteTV becomeFirstResponder];
            [self setupDateButton];
            [self setupRestaurantButton];
            
            self.continueButton.enabled = YES;
            self.continueButton.alpha = 1.0;
            
        }];
    } else {
        self.datePickerVisible = YES;
        [UIView animateWithDuration:animationTime animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+viewHeightAdjustment);
            [self.noteTV resignFirstResponder];
            [self setupDateButton];
            [self setupRestaurantButton];
            
            self.continueButton.enabled = NO;
            self.continueButton.alpha = 0.5;
        }];
    }
}




- (IBAction)changeRestaurant:(UIButton *)sender
{
    NSLog(@"change restaurant");
}



#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.datePickerVisible){
        [self showHideDatePicker];
    }
}

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




#pragma mark - FriendListVcDelegate

-(void)backFromVC:(UIViewController *)dismissed withFriends:(NSArray *)selectedFriendsArray
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.noteTV becomeFirstResponder];
    }];
    self.selectedFriends = selectedFriendsArray;
}

-(void)checkInWithFriends:(NSArray *)selectedFriendsArray
{
    self.selectedFriends = selectedFriendsArray;
    [self createTastingRecord];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.noteTV resignFirstResponder];
        [self.delegate dismissAfterTastingRecordCreation];
    }];
}

-(void)createTastingRecord
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSDate *now = [NSDate date];
    
    if(!self.selectedDate){
        self.selectedDate = now;
    }
    
    NSString *dateString = [now.description stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *identifier = [NSString stringWithFormat:@"%@%@",self.restaurant.identifier,dateString];
    
    [dictionary setObject:now forKey:ADDED_DATE];
    [dictionary setObject:@NO forKey:DELETED_ENTITY];
    [dictionary setObject:identifier forKey:IDENTIFIER];
    [dictionary setObject:self.selectedDate forKey:TASTING_DATE];
    [dictionary setObject:now forKey:UPDATED_DATE];
    
    TastingRecordDataHelper *trdh = [[TastingRecordDataHelper alloc] init];
    TastingRecord *tastingRecord = (TastingRecord *)[trdh updateManagedObjectWithDictionary:dictionary];
    
    tastingRecord.restaurant = self.restaurant;
    
    NSMutableSet *reviews = [[NSMutableSet alloc] init];
    User *user = [FacebookSessionManager sharedInstance].user;
    Review *userReview = [self createClaimed:YES reviewForUser:user];
    [reviews addObject:userReview];
    
    if(self.selectedFriends){
        for(User *friend in self.selectedFriends){
            Review *friendReview = [self createClaimed:NO reviewForUser:friend];
            [reviews addObject:friendReview];
        }
        tastingRecord.reviews = reviews;
    }
}

-(Review *)createClaimed:(BOOL)claimed reviewForUser:(User *)user
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSString *dateString = [self.selectedDate.description stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *identifier = [NSString stringWithFormat:@"%@%@",dateString,user.identifier];
    
    [dictionary setObject:self.selectedDate forKey:ADDED_DATE];
    [dictionary setObject:@(claimed) forKey:CLAIMED_BY_USER];
    [dictionary setObject:@NO forKey:DELETED_ENTITY];
    [dictionary setObject:identifier forKey:IDENTIFIER];
    
    if(claimed){
        
        [dictionary setObject:@(self.userRatingsController.rating) forKey:RATING];
        NSString *reviewText;
        if([[self.noteTV.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0){
            reviewText = self.noteTV.text;
            [dictionary setObject:reviewText forKey:REVIEW_TEXT];
        }
        
        [dictionary setObject:self.selectedDate forKey:REVIEW_DATE];
    }
    
    [dictionary setObject:self.selectedDate forKey:UPDATED_DATE];
    
    ReviewDataHelper *rdh = [[ReviewDataHelper alloc] init];
    Review *review = (Review *)[rdh updateManagedObjectWithDictionary:dictionary];
    review.wine = self.wine;
    review.user = user;
    
    return review;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
