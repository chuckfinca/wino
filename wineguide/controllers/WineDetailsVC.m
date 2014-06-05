//
//  WineDetailsVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDetailsVC.h"
#import "WineDetailsVHTV.h"
#import "WineNameVHTV.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "GetMe.h"
#import "OutBox.h"
#import "TalkingHeadsLabel.h"
#import "ReviewsLabel.h"
#import "FacebookProfileImageGetter.h"
#import "RatingPreparer.h"
#import "UIView+BorderDrawer.h"

@interface WineDetailsVC ()

@property (nonatomic, weak) IBOutlet WineNameVHTV *wineNameVHTV;
@property (nonatomic, weak) IBOutlet WineDetailsVHTV *wineDetailsVHTV;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *glassRatingImageViewArray;

@property (weak, nonatomic) IBOutlet UIButton *talkingHeadButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *talkingHeadButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *talkingHeadButtonThree;

@property (weak, nonatomic) IBOutlet UIButton *cellarButton;
@property (weak, nonatomic) IBOutlet UIButton *triedItButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet TalkingHeadsLabel *talkingHeadsLabel;
@property (weak, nonatomic) IBOutlet ReviewsLabel *reviewsLabel;

@property (nonatomic, weak) Wine2 *wine;
@property (nonatomic, weak) Restaurant2 *restaurant;
@property (nonatomic, weak) User2 *me;

@property (nonatomic) NSInteger numberOfRatings; // for testing


// Vertical spacing constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToTalkingHeadsButtonArrayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsButtonArrayToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewsLabelToWineDetailsVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineDetailsVHTVToTriedItButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *triedItButtonToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToTalkingHeadsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsLabelToReviewsLabelConstraint;

// Horizontal spacing constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftToTalkingHeadsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftToReviewsLabelConstraint;

@end

@implementation WineDetailsVC

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

#pragma mark - Getters & Setters

-(User2 *)me
{
    if(!_me){
        _me = [GetMe sharedInstance].me;
    }
    return _me;
}


#pragma mark - Setup

-(void)setupWithWine:(Wine2 *)wine fromRestaurant:(Restaurant2 *)restaurant
{
    self.wine = wine;
    self.restaurant = restaurant;
}

-(void)setup
{
    [self.wineNameVHTV setupTextViewWithWine:self.wine fromRestaurant:nil];
    [self setupTalkingHeadsForWine:self.wine];
    [self.wineDetailsVHTV setupTextViewWithWine:self.wine fromRestaurant:nil];
    [self setupRatingForWine:self.wine];
    [self setupUserActionButtons];
    
    [self setViewHeight];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    [self.view drawBorderWidth:1 withColor:[ColorSchemer sharedInstance].gray onTop:YES bottom:YES left:NO andRight:NO];
}

-(void)setupUserActionButtons
{
    [self.triedItButton setBackgroundImage:[[UIImage imageNamed:@"button_triedIt.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.triedItButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Tried It" attributes:[FontThemer sharedInstance].linkCaption1TextAttributes] forState:UIControlStateNormal];
    
    [self.purchaseButton setBackgroundImage:[[UIImage imageNamed:@"button_purchase.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.purchaseButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Purchase" attributes:[FontThemer sharedInstance].linkCaption1TextAttributes] forState:UIControlStateNormal];
    
    [self setupCellarButton];
}

-(void)setupCellarButton
{
    BOOL favorited = [self.me.wines containsObject:self.wine];
    UIImage *image;
    if(favorited){
        image = [UIImage imageNamed:@"button_cellar.png"];
        [self.cellarButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Stored" attributes:[FontThemer sharedInstance].linkCaption1TextAttributes] forState:UIControlStateNormal];
    } else {
        image = [UIImage imageNamed:@"button_cellarUnstored.png"];
        [self.cellarButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cellar" attributes:[FontThemer sharedInstance].linkCaption1TextAttributes] forState:UIControlStateNormal];
    }
    [self.cellarButton setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}

-(void)setupTalkingHeadsForWine:(Wine2 *)wine
{
    self.numberOfRatings = arc4random_uniform(8)+1;
    
    NSInteger numberOfTalkingHeads = self.numberOfRatings / 2;
    BOOL youLikeThis = [wine.user_favorite boolValue];
    
    NSMutableArray *talkingHeadsArray = [[NSMutableArray alloc] init];
    
    if(numberOfTalkingHeads < 1){
        self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonOne.frame.origin.x;
        [self.talkingHeadButtonOne removeFromSuperview];
        self.talkingHeadButtonOne = nil;
    } else {
        [talkingHeadsArray addObject:self.talkingHeadButtonOne];
    }
    
    if(numberOfTalkingHeads < 2){
        if(self.talkingHeadButtonTwo.frame.origin.x < self.leftToTalkingHeadsLabelConstraint.constant){
            self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonTwo.frame.origin.x;
        }
        [self.talkingHeadButtonTwo removeFromSuperview];
        self.talkingHeadButtonTwo = nil;
    } else {
        [talkingHeadsArray addObject:self.talkingHeadButtonTwo];
    }
    
    if(numberOfTalkingHeads < 3){
        if(self.talkingHeadButtonThree.frame.origin.x < self.leftToTalkingHeadsLabelConstraint.constant){
            self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonThree.frame.origin.x;
        }
        [self.talkingHeadButtonThree removeFromSuperview];
        self.talkingHeadButtonThree = nil;
    } else {
        [talkingHeadsArray addObject:self.talkingHeadButtonThree];
    }
    
    if(numberOfTalkingHeads > 3 || youLikeThis){
        NSInteger additionalPeople = numberOfTalkingHeads - 3 > 0 ? numberOfTalkingHeads - 3 : 0;
        [self.talkingHeadsLabel setupLabelWithNumberOfAdditionalPeople:additionalPeople andYou:youLikeThis];
        
    } else {
        [self.talkingHeadsLabel removeFromSuperview];
        self.talkingHeadsLabel = nil;
    }
    
    FacebookProfileImageGetter *facebookProfileImageGetter = [[FacebookProfileImageGetter alloc] init];
    
    for(UIButton *talkingHeadButton in talkingHeadsArray){
        
        talkingHeadButton.tintColor = [ColorSchemer sharedInstance].baseColor;
        
        [facebookProfileImageGetter setProfilePicForUser:nil inButton:talkingHeadButton completion:^(BOOL success) {
            if(success){
                [talkingHeadButton setImage:[UIImage imageWithData:nil] forState:UIControlStateNormal];
            }
        }];
    }
    
}

-(void)setupRatingForWine:(Wine2 *)wine
{
    if(self.numberOfRatings > 0){
        
        float rating = arc4random_uniform(50) + 1;
        rating /= 10;
        NSLog(@"rating = %f",rating);
        
        [RatingPreparer setupRating:rating inImageViewArray:self.glassRatingImageViewArray withWineColor:wine.color_code];
        [self.reviewsLabel setupForNumberOfReviews:self.numberOfRatings];
        
    } else {
        [self.reviewsLabel removeFromSuperview];
        self.reviewsLabel = nil;
    }
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToWineNameVHTVConstraint.constant;
    height += [self.wineNameVHTV height];
    
    if(self.talkingHeadButtonOne){
        height += self.wineNameVHTVToTalkingHeadsButtonArrayConstraint.constant;
        height += self.talkingHeadButtonOne.bounds.size.height;
        if(self.reviewsLabel){
            height += self.talkingHeadsButtonArrayToReviewsLabelConstraint.constant;
        }
    } else if(self.talkingHeadsLabel){
        height += self.wineNameVHTVToTalkingHeadsLabelConstraint.constant;
        height += self.talkingHeadsLabel.bounds.size.height;
        if(self.reviewsLabel){
            height += self.talkingHeadsLabelToReviewsLabelConstraint.constant;
        }
    }
    height += self.reviewsLabel.bounds.size.height;
    height += self.reviewsLabelToWineDetailsVHTVConstraint.constant;
    height += [self.wineDetailsVHTV height];
    height += self.wineDetailsVHTVToTriedItButtonConstraint.constant;
    height += self.triedItButton.bounds.size.height;
    height += self.triedItButtonToBottomConstraint.constant;
    
    self.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, height);
}


-(void)displayCellarMessage
{
    NSString *message;
    
    if([self.me.wines containsObject:self.wine]){
        message = @"Wine added to cellar";
    } else {
        message = @"Wine removed from cellar";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:message otherButtonTitles: nil];
    
    [alert show];
    
    NSArray *arguments = @[@1,@1];
    [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:arguments afterDelay:1.5f];
    
}


#pragma mark - Target action

-(IBAction)cellarPressed:(id)sender
{
    [self cellarWine];
    [self displayCellarMessage];
}

-(IBAction)triedItPressed:(id)sender
{
    [self.delegate performTriedItSegue];
}

-(IBAction)purchasePressed:(id)sender
{
    [self purchaseWine];
}

-(IBAction)pushUserProfile:(UIButton *)sender
{
    NSLog(@"push user profile for button %ld",(long)sender.tag);
}
#pragma mark - UserActions

-(void)cellarWine
{
    NSMutableSet *winesInCellar = [self.me.wines mutableCopy];
    
    if([winesInCellar containsObject:self.wine]){
        [winesInCellar removeObject:self.wine];
    } else {
        [winesInCellar addObject:self.wine];
    }
    self.me.wines = winesInCellar;
    
    [self setupCellarButton];
    
    OutBox *outBox = [[OutBox alloc] init];
    [outBox userDidCellarWine:self.wine];
}

- (void)purchaseWine
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Bottle purchases coming soon!" delegate:nil cancelButtonTitle:nil otherButtonTitles: @"Ok",nil];
    [alert show];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
