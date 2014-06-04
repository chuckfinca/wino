//
//  WineCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine_TRSICDTVC.h"
#import "WineDetailsVC.h"
#import "ColorSchemer.h"
#import "CheckInVC.h"
#import "GetMe.h"

#define TASTING_RECORD_ENTITY @"TastingRecord2"
#define REVIEW_CELL @"ReviewCell"

@interface Wine_TRSICDTVC () <WineDetailsVcDelegate, UIViewControllerTransitioningDelegate, CheckInVcDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) WineDetailsVC *wineDetailsViewController;
@property (nonatomic, strong) Wine2 *wine;
@property (nonatomic, strong) Restaurant2 *restaurant;

@property (nonatomic) float tableViewHeaderheight;

@end

@implementation Wine_TRSICDTVC

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
    
    self.displayInstructionsCell = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.wineDetailsViewController.view.frame = CGRectMake(self.wineDetailsViewController.view.frame.origin.x,
                                                           self.wineDetailsViewController.view.frame.origin.y,
                                                           self.wineDetailsViewController.view.frame.size.width,
                                                           self.tableViewHeaderheight);
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

-(void)registerInstructionCellNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionsCell_TriedIt" bundle:nil] forCellReuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
}

-(void)setupWithWine:(Wine2 *)wine fromRestaurant:(Restaurant2 *)restaurant
{
    [self.wineDetailsViewController setupWithWine:wine fromRestaurant:restaurant];
    self.tableView.tableHeaderView = self.wineDetailsViewController.view;
    self.tableViewHeaderheight = self.wineDetailsViewController.view.bounds.size.height;
    
    self.wine = wine;
    self.restaurant = restaurant;
    self.context = wine.managedObjectContext;
    self.displayWineNameOnEachCell = NO;
    
    // get the reviews for that wine
    [self getTastingRecords];
}

-(void)refreshFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TASTING_RECORD_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tasting_date"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"wine.identifier = %@",self.wine.identifier];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    if([self.fetchedResultsController.fetchedObjects count] > 0){
        self.displayInstructionsCell = NO;
    }
    NSLog(@"fetchedObjects = %lu",(unsigned long)[self.fetchedResultsController.fetchedObjects count]);
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







@end

