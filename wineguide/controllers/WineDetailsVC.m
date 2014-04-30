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
#import "Brand.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "User.h"
#import "GetMe.h"
#import "WineRatingAndReviewQuickViewVC.h"

@interface WineDetailsVC ()

@property (nonatomic, weak) IBOutlet WineNameVHTV *wineNameVHTV;
@property (nonatomic, weak) IBOutlet WineDetailsVHTV *wineDetailsVHTV;
@property (weak, nonatomic) IBOutlet UIView *ratingsAndReviewsView;
@property (weak, nonatomic) IBOutlet UIButton *cellarButton;
@property (weak, nonatomic) IBOutlet UIButton *triedItButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;

@property (nonatomic, weak) Wine *wine;
@property (nonatomic, weak) Restaurant *restaurant;
@property (nonatomic, weak) User *me;
@property (nonatomic, strong) WineRatingAndReviewQuickViewVC *wineRatingAndReviewQuickviewVC;
@property (nonatomic, strong) NSDictionary *buttonTextAttributesDictionary;

// Vertical spacing constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVTHVToRatingsAndReviewsViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingsAndReviewsViewToWineDetailsVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineDetailsVHTVToTriedItButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *triedItButtonToBottomConstraint;



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

-(NSDictionary *)buttonTextAttributesDictionary
{
    return @{NSFontAttributeName : [FontThemer sharedInstance].caption1, NSForegroundColorAttributeName : self.view.tintColor};
}

-(User *)me
{
    if(!_me){
        _me = [GetMe sharedInstance].me;
    }
    return _me;
}


#pragma mark - Setup

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    self.wine = wine;
    self.restaurant = restaurant;
}

-(void)setup
{
    [self.wineNameVHTV setupTextViewWithWine:self.wine fromRestaurant:nil];
    [self.wineDetailsVHTV setupTextViewWithWine:self.wine fromRestaurant:nil];
    
    self.wineRatingAndReviewQuickviewVC = [[WineRatingAndReviewQuickViewVC alloc] initWithNibName:@"WineRatingAndReviewQuickviewVC" bundle:nil];
    [self.ratingsAndReviewsView addSubview:self.wineRatingAndReviewQuickviewVC.view];
    [self.wineRatingAndReviewQuickviewVC setupForWine:self.wine];
    
    [self setupUserActionButtons];
    
    [self setViewHeight];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupUserActionButtons
{
    [self.triedItButton setBackgroundImage:[[UIImage imageNamed:@"button_triedIt.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.triedItButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Tried It" attributes:self.buttonTextAttributesDictionary] forState:UIControlStateNormal];
    
    [self.purchaseButton setBackgroundImage:[[UIImage imageNamed:@"button_purchase.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.purchaseButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Purchase" attributes:self.buttonTextAttributesDictionary] forState:UIControlStateNormal];
    
    [self setupCellarButton];
}

-(void)setupCellarButton
{
    BOOL favorited = [self.me.winesInCellar containsObject:self.wine];
    UIImage *image;
    if(favorited){
        image = [UIImage imageNamed:@"button_cellar.png"];
        [self.cellarButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Stored" attributes:self.buttonTextAttributesDictionary] forState:UIControlStateNormal];
    } else {
        image = [UIImage imageNamed:@"button_cellarUnstored.png"];
        [self.cellarButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cellar" attributes:self.buttonTextAttributesDictionary] forState:UIControlStateNormal];
    }
    [self.cellarButton setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToWineNameVHTVConstraint.constant;
    height += [self.wineNameVHTV height];
    height += self.wineNameVTHVToRatingsAndReviewsViewConstraint.constant;
    height += self.ratingsAndReviewsView.bounds.size.height;
    height += self.ratingsAndReviewsViewToWineDetailsVHTVConstraint.constant;
    height += [self.wineDetailsVHTV height];
    height += self.wineDetailsVHTVToTriedItButtonConstraint.constant;
    height += self.triedItButton.bounds.size.height;
    height += self.triedItButtonToBottomConstraint.constant;
    
    self.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, height);
}



-(void)displayCellarMessage
{
    NSString *message;
    
    if([self.me.winesInCellar containsObject:self.wine]){
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

#pragma mark - UserActions

-(void)cellarWine
{
    NSMutableSet *winesInCellar = [self.me.winesInCellar mutableCopy];
    
    if([winesInCellar containsObject:self.wine]){
        [winesInCellar removeObject:self.wine];
    } else {
        [winesInCellar addObject:self.wine];
    }
    self.me.winesInCellar = winesInCellar;
    
    [self setupCellarButton];
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
