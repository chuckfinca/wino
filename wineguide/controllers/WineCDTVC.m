//
//  WineCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineCDTVC.h"
#import "WineDetailsVC.h"
#import "ColorSchemer.h"
#import "ReviewTVC.h"
#import "CheckInVC.h"
#import "TransitionAnimator_CheckInVC.h"
#import "MotionEffects.h"


#define WINE_CELL @"WineCell"
#define REVIEW_CELL @"ReviewCell"

@interface WineCDTVC () <WineDetailsVcDelegate, UIViewControllerTransitioningDelegate, CheckInVcDelegate>

@property (nonatomic, strong) WineDetailsVC *wineDetailsViewController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Wine *wine;
@property (nonatomic, strong) Restaurant *restaurant;

@end

@implementation WineCDTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.wineDetailsViewController.view;
    [self.tableView registerNib:[UINib nibWithNibName:@"WineReview" bundle:nil] forCellReuseIdentifier:REVIEW_CELL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

-(WineDetailsVC *)wineDetailsViewController
{
    if(!_wineDetailsViewController){
        _wineDetailsViewController = [[WineDetailsVC alloc] initWithNibName:@"WineDetails" bundle:nil];
        _wineDetailsViewController.delegate = self;
    }
    return _wineDetailsViewController;
}

#pragma mark - Setup

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    [self.wineDetailsViewController setupWithWine:wine fromRestaurant:(Restaurant *)restaurant];
    self.wine = wine;
    self.restaurant = restaurant;
    self.context = wine.managedObjectContext;
    
    // get the reviews for that wine
    [self refreshReviewList];
}

-(void)refreshReviewList
{
    // if we have cached wine review data then display that while checking to see if there is newer information on the server
    [self getReviewList];
}

-(void)getReviewList
{
    /* placeholder for future code
     
     NSString *restaurantName = self.restaurant.name;
     NSString *nameWithoutSpaces = [restaurantName stringByReplacingOccurrencesOfString:@" " withString:@""];
     
     // this will be replaced with a server url when available
     NSURL *url = [[NSBundle mainBundle] URLForResource:nameWithoutSpaces withExtension:@"json"];
     
     WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:self.context];
     wdh.restaurant = self.restaurant;
     
     [wdh updateCoreDataWithJSONFromURL:url];
     [self setupFetchedResultsController];
     */
}

-(void)setupFetchedResultsController
{
    // NSLog(@"setupFetchedResultsController...");
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewTVC *cell = [tableView dequeueReusableCellWithIdentifier:REVIEW_CELL forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setupReview];
    //cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:@"review" attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WineSectionHeader"];
    return view;
}


#pragma mark - WineDetailsVcDelegate

-(void)performTriedItSegue
{
    NSLog(@"performTriedItSegue");
    
    [self performSegueWithIdentifier:@"CheckInSegue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    [super prepareForSegue:segue sender:sender];
    
    CheckInVC *checkInVC = segue.destinationViewController;
    [checkInVC setupWithWine:self.wine andRestaurant:self.restaurant];
    checkInVC.transitioningDelegate = self;
    checkInVC.modalPresentationStyle = UIModalPresentationCustom;
    checkInVC.delegate = self;
}


#pragma mark - CheckInVcDelegate

-(void)dismissAfterTastingRecordCreation
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wine has been added to your timeline!" message:nil delegate:self cancelButtonTitle:nil  otherButtonTitles:@"Ok", nil];
    alert.tintColor = [ColorSchemer sharedInstance].textLink;
    
    [MotionEffects addMotionEffectsToView:alert];
    [alert show];
}



#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                 presentingController:(UIViewController *)presenting
                                                                     sourceController:(UIViewController *)source
{
    TransitionAnimator_CheckInVC *animator = [TransitionAnimator_CheckInVC new];
    animator.presenting = YES;
    return animator;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [TransitionAnimator_CheckInVC new];
}

-(IBAction)dismissCheckInVC:(UIStoryboardSegue *)unwindSegue
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


@end

