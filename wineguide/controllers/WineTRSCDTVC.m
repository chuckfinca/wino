//
//  WineCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineTRSCDTVC.h"
#import "WineDetailsVC.h"
#import "ColorSchemer.h"
#import "CheckInVC.h"
#import "GetMe.h"

#define TASTING_RECORD_ENTITY @"TastingRecord"

#define WINE_CELL @"WineCell"
#define REVIEW_CELL @"ReviewCell"

@interface WineTRSCDTVC () <WineDetailsVcDelegate, UIViewControllerTransitioningDelegate, CheckInVcDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) WineDetailsVC *wineDetailsViewController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Wine *wine;
@property (nonatomic, strong) Restaurant *restaurant;

@end

@implementation WineTRSCDTVC

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

#pragma mark - Setup

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    [self.wineDetailsViewController setupWithWine:wine fromRestaurant:(Restaurant *)restaurant];
    self.tableView.tableHeaderView = self.wineDetailsViewController.view;
    self.wine = wine;
    self.restaurant = restaurant;
    self.context = wine.managedObjectContext;
    self.displayWineNameOnEachCell = NO;
    
    [self setupFetchedResultsController];
    
    // get the reviews for that wine
    [self getTastingRecords];
}

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TASTING_RECORD_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tastingDate"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY reviews.wine.identifier = %@",self.wine.identifier];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    NSLog(@"%@",self.fetchedResultsController.fetchedObjects);
}

-(void)logFetchResultsForController:(NSFetchedResultsController *)frc
{
    NSLog(@"fetchedResultCount = %lu",(unsigned long)[frc.fetchedObjects count]);
    for(NSObject *fetchedResult in frc.fetchedObjects){
        NSLog(@"fetchedResult = %@",fetchedResult.description);
    }
}

-(void)getTastingRecords
{
    // get tasting records from server
}

#pragma mark - WineDetailsVcDelegate

-(void)performTriedItSegue
{
    UINavigationController *navController = [[UIStoryboard storyboardWithName:@"iPhone_CheckIn" bundle:nil] instantiateInitialViewController];
    UIViewController *controller = [navController.viewControllers firstObject];
    
    if([controller isKindOfClass:[CheckInVC class]]){
        CheckInVC *checkInVC = (CheckInVC *)controller;
        [checkInVC setupWithWine:self.wine andRestaurant:self.restaurant];
        checkInVC.delegate = self;
    }
    
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - CheckInVcDelegate

-(void)dismissAfterTastingRecordCreation
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"Tasting Record added to timeline!"  otherButtonTitles:nil];
    [alert show];
    
    NSArray *arguments = @[@1,@1];
    [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:arguments afterDelay:1.5f];
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
