//
//  CheckInVC.m
//  Corkie
//
//  Created by Charles Feinn on 1/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "CheckInVC.h"
#import "ManagedObjectHandler.h"
#import "FontThemer.h"
#import "ColorSchemer.h"
#import "Review2.h"
#import "TastingRecord2.h"
#import "FriendListVC.h"
#import "GetMe.h"
#import "SetRatingVC.h"
#import "UIView+BorderDrawer.h"
#import "FacebookSessionManager.h"
#import "LocalTastingRecordCreator.h"
#import "OutBox.h"

#define NOTE_TEXT_INSET 20

@interface CheckInVC () <UITextViewDelegate, UIViewControllerTransitioningDelegate, FriendListVcDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *cancelCheckInButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTV;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;
@property (weak, nonatomic) IBOutlet UIView *ratingContainerView;

@property (nonatomic, strong) Wine2 *wine;
@property (nonatomic, strong) Restaurant2 *restaurant;
@property (nonatomic, strong) NSArray *selectedFriends;
@property (nonatomic) BOOL datePickerVisible;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) SetRatingVC *ratingVC;
@property (nonatomic, strong) UIDatePicker *datePicker;

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

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.noteTV.delegate = self;
    self.scrollView.backgroundColor = [ColorSchemer sharedInstance].gray;
    self.noteTV.backgroundColor = [ColorSchemer sharedInstance].customWhite;
    self.noteTV.textContainerInset = UIEdgeInsetsMake(NOTE_TEXT_INSET, NOTE_TEXT_INSET, NOTE_TEXT_INSET, NOTE_TEXT_INSET);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.noteTV becomeFirstResponder];
}

#pragma mark - Getters & setters

-(UIDatePicker *)datePicker
{
    if(!_datePicker){
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 700, 320, 162)];
        _datePicker.maximumDate = [NSDate date];
        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [ColorSchemer sharedInstance].customWhite;
        [self.view addSubview:_datePicker];
    }
    return _datePicker;
}


#pragma mark - Setup

-(void)setupWithWine:(id)wine andRestaurant:(id)restaurant
{
    self.wine = wine;
    self.restaurant = restaurant;
    
    [self setupPrompt];
    [self setupRestaurantText];
    [self setupRatingView];
}

-(void)setupRatingView
{
    self.ratingVC = [[SetRatingVC alloc] initWithNibName:@"SetRatingVC" bundle:nil];
    [self.ratingContainerView addSubview:self.ratingVC.view];
    
    self.ratingVC.wineColor = [[ColorSchemer sharedInstance] getWineColorFromCode:self.wine.color_code];
    
    self.ratingVC.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    [self.ratingVC.view drawBorderWidth:1 withColor:[ColorSchemer sharedInstance].gray onTop:YES bottom:YES left:NO andRight:NO];
}

-(void)setup
{
    self.view.backgroundColor = [ColorSchemer sharedInstance].customWhite;
    [self setupRestaurantButton];
    [self setupDateButton];
    [self setupContinueButton];
}

-(void)setupPrompt
{
    NSString *text = [NSString stringWithFormat:@"What did you think about the %@?",[self.wine.name capitalizedString]];
    self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPlaceholder}];
}

-(void)setupRestaurantButton
{
    self.restaurantButton.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    [self.restaurantButton drawBorderWidth:1 withColor:[ColorSchemer sharedInstance].gray onTop:NO bottom:YES left:NO andRight:NO];
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
    [self.dateButton drawBorderWidth:1 withColor:[ColorSchemer sharedInstance].gray onTop:NO bottom:YES left:NO andRight:YES];
}


-(void)setupContinueButton
{
    [self.continueButton setAttributedTitle:[[NSAttributedString alloc] initWithString:self.continueButton.titleLabel.text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].headline}] forState:UIControlStateNormal];
    [self.continueButton sizeToFit];
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
        if(!self.ratingVC.rating){
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
        
        FriendListVC *friendListVC = segue.destinationViewController;
        
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
    NSInteger viewHeightAdjustment = 500;
    
    if(self.datePickerVisible){
        self.datePickerVisible = NO;
        [UIView animateWithDuration:animationTime animations:^{
            self.datePicker.frame = CGRectMake(self.datePicker.frame.origin.x, self.datePicker.frame.origin.y+viewHeightAdjustment, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
            [self.noteTV becomeFirstResponder];
            [self setupDateButton];
            [self setupRestaurantButton];
            
            self.continueButton.enabled = YES;
            self.continueButton.alpha = 1.0;
            
        }];
    } else {
        
        self.datePickerVisible = YES;
        [UIView animateWithDuration:animationTime animations:^{
            self.datePicker.frame = CGRectMake(self.datePicker.frame.origin.x, self.datePicker.frame.origin.y-viewHeightAdjustment, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
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



#pragma mark - FriendListVcDelegate

-(void)backFromVC:(UIViewController *)dismissed withFriends:(NSArray *)selectedFriendsArray
{
    [self.noteTV becomeFirstResponder];
    self.selectedFriends = selectedFriendsArray;
}

-(void)checkInWithFriends:(NSArray *)selectedFriendsArray shareToFacebook:(BOOL)shareToFacebook
{
    self.selectedFriends = selectedFriendsArray;
    
    NSString *reviewText;
    if([[self.noteTV.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0){
        reviewText = self.noteTV.text;
    }
    
    LocalTastingRecordCreator *tastingRecordCreator = [[LocalTastingRecordCreator alloc] init];
    TastingRecord2 *tastingRecord = [tastingRecordCreator createTastingRecordAndReviewWithText:reviewText rating:self.ratingVC.rating wine:self.wine restaurant:self.restaurant tastingDate:[NSDate date] andFriends:self.selectedFriends];
    
    if(shareToFacebook){
        [self shareTastingRecordToFacebook:tastingRecord];
    }
    
    OutBox *outBox = [[OutBox alloc] init];
    [outBox userCreatedTastingRecord:tastingRecord];
    
    [self dismissViewController];
}

-(void)shareTastingRecordToFacebook:(TastingRecord2 *)tastingRecord
{
    BOOL canPublishToFacebook = [[FacebookSessionManager sharedInstance] userHasPermission:FACEBOOK_PUBLISH_PERMISSION];
    
    if(canPublishToFacebook){
        NSLog(@"canPublishToFacebook, proceed");
        
    } else {
        [[FacebookSessionManager sharedInstance] requestPermission:FACEBOOK_PUBLISH_PERMISSION withCompletion:^(BOOL success) {
            if(success){
                NSLog(@"success! proceed");
                
            } else {
                NSLog(@"request publish permission failed");
            }
        }];
    }
}

-(void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.noteTV resignFirstResponder];
        [self.delegate dismissAfterTastingRecordCreation];
    }];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
