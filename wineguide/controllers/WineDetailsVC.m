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
#import "ReviewersAndRatingsVC.h"
#import "FontThemer.h"
#import "User.h"
#import "GetMe.h"



@interface WineDetailsVC ()

@property (nonatomic, weak) Wine *wine;
@property (nonatomic, weak) Restaurant *restaurant;
@property (nonatomic, weak) User *me;
@property (nonatomic, weak) IBOutlet WineDetailsVHTV *wineDetailsVHTV;
@property (nonatomic, weak) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet UIView *ratingsAndReviewsView;
@property (nonatomic, strong) ReviewersAndRatingsVC *reviewersAndRatingsVC;
@property (weak, nonatomic) IBOutlet UIButton *cellarButton;
@property (weak, nonatomic) IBOutlet UIButton *triedItButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
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

-(ReviewersAndRatingsVC *)reviewersAndRatingsVC
{
    if(!_reviewersAndRatingsVC){
        _reviewersAndRatingsVC = [[ReviewersAndRatingsVC alloc] initWithNibName:@"RatingsAndReviews" bundle:nil];
    }
    return _reviewersAndRatingsVC;
}

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
    
    // [self logDetails];
}

-(void)setup
{
    [self.wineNameVHTV setupTextViewWithWine:self.wine fromRestaurant:self.restaurant];
    
    [self.wineDetailsVHTV setupTextViewWithWine:self.wine fromRestaurant:self.restaurant];
    
    [self.ratingsAndReviewsView addSubview:self.reviewersAndRatingsVC.view];
    self.reviewersAndRatingsVC.favorite = [self.me.winesInCellar containsObject:self.wine];
    [self.reviewersAndRatingsVC setupForWine:self.wine];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    [self setupUserActionButtons];
    
    [self setViewHeight];
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
    self.reviewersAndRatingsVC.favorite = [self.me.winesInCellar containsObject:self.wine];
    [self.reviewersAndRatingsVC setupForWine:self.wine];
    
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
    
    NSLog(@"winesInCellar = %i",[winesInCellar count]);
    
    if([winesInCellar containsObject:self.wine]){
        NSLog(@"aaa");
        [winesInCellar removeObject:self.wine];
    } else {
        NSLog(@"bbb");
        [winesInCellar addObject:self.wine];
    }
    self.me.winesInCellar = winesInCellar;
    
    NSLog(@"winesInCellar = %i",[winesInCellar count]);
    
    [self setupCellarButton];
}

- (void)purchaseWine
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Bottle purchases coming soon!" delegate:nil cancelButtonTitle:nil otherButtonTitles: @"Ok",nil];
    [alert show];
}




-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.wine.identifier);
    NSLog(@"alcoholPercentage = %@",self.wine.alcoholPercentage);
    NSLog(@"color = %@",self.wine.color);
    NSLog(@"country = %@",self.wine.country);
    NSLog(@"dessert = %@",self.wine.dessert);
    NSLog(@"lastServerUpdate = %@",self.wine.lastServerUpdate);
    NSLog(@"deletedEntity = %@",self.wine.deletedEntity);
    NSLog(@"name = %@",self.wine.name);
    NSLog(@"region = %@",self.wine.region);
    NSLog(@"sparkling = %@",self.wine.sparkling);
    NSLog(@"state = %@",self.wine.state);
    NSLog(@"vineyard = %@",self.wine.vineyard);
    NSLog(@"vintage = %@",self.wine.vintage);
    
    NSLog(@"brandIdentifier = %@",self.wine.brandIdentifier);
    NSLog(@"wineUnitIdentifiers = %@",self.wine.wineUnitIdentifiers);
    NSLog(@"tastingNoteIdentifers = %@",self.wine.tastingNoteIdentifers);
    NSLog(@"varietalIdentifiers = %@",self.wine.varietalIdentifiers);
    
    NSLog(@"brand = %@",self.wine.brand.description);
    
    NSLog(@"tastingNotes count = %lu",(unsigned long)[self.wine.tastingNotes count]);
    for(NSObject *obj in self.wine.tastingNotes){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"varietals count = %lu",(unsigned long)[self.wine.varietals count]);
    for(NSObject *obj in self.wine.varietals){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wineUnits = %lu",(unsigned long)[self.wine.wineUnits count]);
    for(NSObject *obj in self.wine.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
