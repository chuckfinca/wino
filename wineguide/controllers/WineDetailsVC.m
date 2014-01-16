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
#import "UserActionCVC.h"
#import "ReviewersAndRatingsVC.h"
#import "MotionEffects.h"

#define USER_ACTION_CELL @"UserActionCell"

@interface WineDetailsVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) Wine *wine;
@property (nonatomic, weak) Restaurant *restaurant;
@property (nonatomic, weak) IBOutlet WineDetailsVHTV *wineDetailsVHTV;
@property (nonatomic, weak) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet UIView *ratingsAndReviewsView;
@property (weak, nonatomic) IBOutlet UICollectionView *userActionsCollectionView;
@property (nonatomic, strong) ReviewersAndRatingsVC *reviewersAndRatingsVC;
@property (nonatomic, strong) UILabel *cellarLabel;

@end

@implementation WineDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.userActionsCollectionView registerNib:[UINib nibWithNibName:@"UserActionCell" bundle:nil] forCellWithReuseIdentifier:USER_ACTION_CELL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

-(ReviewersAndRatingsVC *)reviewersAndRatingsVC
{
    if(!_reviewersAndRatingsVC){
        _reviewersAndRatingsVC = [[ReviewersAndRatingsVC alloc] initWithNibName:@"RatingsAndReviews" bundle:nil];
    }
    return _reviewersAndRatingsVC;
}


#pragma mark - Setup

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    self.wine = wine;
    self.restaurant = restaurant;
    
    // [self logDetails];
    
    [self setupTextForWine:wine];
    
    [self.ratingsAndReviewsView addSubview:self.reviewersAndRatingsVC.view];
    self.reviewersAndRatingsVC.favorite = [self.wine.favorite boolValue];
    [self.reviewersAndRatingsVC setupForWine:self.wine];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupTextForWine:(Wine *)wine
{
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:self.restaurant];
    [self.wineDetailsVHTV setupTextViewWithWine:wine fromRestaurant:self.restaurant];
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserActionCVC *cell = (UserActionCVC *)[collectionView dequeueReusableCellWithReuseIdentifier:USER_ACTION_CELL forIndexPath:indexPath];
    
    [cell setupCellForWine:self.wine atIndex:indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.delegate performTriedItSegue];
            break;
        case 1:
            [self favoriteWine];
            [self.userActionsCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            self.reviewersAndRatingsVC.favorite = [self.wine.favorite boolValue];
            [self.reviewersAndRatingsVC setupForWine:self.wine];
            
            [self displayCellarMessage];
            
            break;
        case 2:
            [self purchaseWine];
            
        default:
            break;
    }
}

-(void)displayCellarMessage
{
    NSString *message;
    
    if([self.wine.favorite boolValue]){
        message = @"Wine added to cellar";
    } else {
        message = @"Wine removed from cellar";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:message otherButtonTitles: nil];
    
    [MotionEffects addMotionEffectsToView:alert];
    [alert show];
    
    NSArray *arguments = @[@1,@1];
    [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:arguments afterDelay:1.5f];
    
}

#pragma mark - UserActions

-(void)favoriteWine
{
    BOOL favorite = ![self.wine.favorite boolValue];
    self.wine.favorite = @(favorite);
}

- (void)purchaseWine
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Bottle purchases coming soon!" delegate:nil cancelButtonTitle:nil otherButtonTitles: @"Ok",nil];
    [MotionEffects addMotionEffectsToView:alert];
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
    NSLog(@"favorite = %@",self.wine.favorite);
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


@end
