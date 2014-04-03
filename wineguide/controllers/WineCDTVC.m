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
#import "FacebookSessionManager.h"


#define WINE_CELL @"WineCell"
#define REVIEW_CELL @"ReviewCell"

@interface WineCDTVC () <WineDetailsVcDelegate, UIViewControllerTransitioningDelegate, CheckInVcDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) WineDetailsVC *wineDetailsViewController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Wine *wine;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) ReviewTVC *reviewTvcSizingCell;

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
    
    // allows the tableview to load faster
    self.tableView.estimatedRowHeight = 200;
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

-(ReviewTVC *)reviewTvcSizingCell
{
    if(!_reviewTvcSizingCell){
        _reviewTvcSizingCell = [[[NSBundle mainBundle] loadNibNamed:@"WineReview" owner:self options:nil] firstObject];
    }
    return _reviewTvcSizingCell;
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
    [cell setupReviewForWineColor:self.wine.color];
    
    [cell.userImageButton addTarget:self action:@selector(userProfileButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.userImageButton.tag = indexPath.row;
    
    [cell.userNameButton addTarget:self action:@selector(userProfileButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.userNameButton.tag = indexPath.row;
    
    [cell.followUserButton addTarget:self action:@selector(followUser:) forControlEvents:UIControlEventTouchUpInside];
    cell.userNameButton.tag = indexPath.row;
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WineSectionHeader"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.reviewTvcSizingCell setupReviewForWineColor:self.wine.color];
    return self.reviewTvcSizingCell.bounds.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewTVC *cell = (ReviewTVC *)[tableView cellForRowAtIndexPath:indexPath];
    
    CGPoint touchLocation = [tableView.panGestureRecognizer locationInView:cell];
    //[tableView.panGestureRecognizer locationInView:cell.userRatingsController.collectionView];
    
    if(CGRectContainsPoint(cell.userImageButton.frame, touchLocation) || CGRectContainsPoint(cell.userNameButton.frame, touchLocation)){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"User profiles coming soon!" delegate:nil cancelButtonTitle:nil  otherButtonTitles:@"Ok", nil];
        alert.tintColor = [ColorSchemer sharedInstance].clickable;
        
        [alert show];
    } else if(CGRectContainsPoint(cell.followUserButton.frame, touchLocation)){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Following/followers coming soon!" delegate:nil cancelButtonTitle:nil  otherButtonTitles:@"Ok", nil];
        alert.tintColor = [ColorSchemer sharedInstance].clickable;
        
        [alert show];
    }
}


#pragma mark - WineDetailsVcDelegate

-(void)performTriedItSegue
{
    // Check to make sure we know which user is about to make the Tasting Record
    if([[FacebookSessionManager sharedInstance].user.isMe boolValue]){
        
        // WHEN DO I CHECK IF INTERNET IS AVAILABLE??
            // probably should wait until the check in is made
            // then send to to the 'outbox' script
            // and then notify the user that the message will be sent when internet becomes available (if necessary)
        
        [self performSegueWithIdentifier:@"CheckInSegue" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect with Facebook" message:@"Corkie needs to be connected to Facebook for you to check wines into your timeline." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect", nil];
        [alert show];
    }
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    CheckInVC *checkInVC = (CheckInVC *)segue.destinationViewController;
    [checkInVC setupWithWine:self.wine andRestaurant:self.restaurant];
    checkInVC.transitioningDelegate = self;
    checkInVC.modalPresentationStyle = UIModalPresentationCustom;
    checkInVC.delegate = self;
}


#pragma mark - CheckInVcDelegate

-(void)dismissAfterTastingRecordCreation
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Wine has been added to your timeline!" delegate:nil cancelButtonTitle:nil  otherButtonTitles:@"Ok", nil];
    alert.tintColor = [ColorSchemer sharedInstance].clickable;
    
    [alert show];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        __weak WineCDTVC *weakSelf = self;
        [[FacebookSessionManager sharedInstance] logInWithCompletion:^(BOOL loggedIn) {
            NSLog(@"logged in? %@",loggedIn == YES ? @"y" : @"n");
            if(loggedIn){
                [weakSelf performSegueWithIdentifier:@"CheckInSegue" sender:self];
            } else {
                NSLog(@"LOGIN FAILED");
            }
     }];
    }
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


#pragma mark - Target Action

-(IBAction)userProfileButton:(UIButton *)sender
{
    NSLog(@"userProfileButton");
    NSLog(@"button tag = %ld",(long)sender.tag);
}

-(IBAction)followUser:(UIButton *)sender
{
    NSLog(@"followUser");
    NSLog(@"button tag = %ld",(long)sender.tag);
}




@end

