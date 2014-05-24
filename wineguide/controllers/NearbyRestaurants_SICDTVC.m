//
//  RestaurantsTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "NearbyRestaurants_SICDTVC.h"
#import "Restaurant_SICDTVC.h"
#import "Restaurant2.h"
#import "ColorSchemer.h"
#import "ServerCommunicator.h"
#import "DocumentHandler2.h"
#import "InstructionsCell_RequestGPS.h"
#import "LocationHelper.h"
#import "RestaurantCell.h"

#define RESTAURANT_CELL @"RestaurantCell"
#define RESTAURANT_ENTITY @"Restaurant2"

@interface NearbyRestaurants_SICDTVC () <RequestUserLocation>

@property (nonatomic, strong) RestaurantCell *sizingCell;

@end

@implementation NearbyRestaurants_SICDTVC

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
    
    self.navigationItem.title = @"Restaurants Nearby";
    
    self.displaySearchBar = YES;
    self.searchBar.placeholder = @"Search by zipcode...";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RestaurantCell" bundle:nil] forCellReuseIdentifier:RESTAURANT_CELL];
    
    [self checkUserLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestUserLocationUserRequested:NO];
}


#pragma mark - Getters & setters

-(RestaurantCell *)sizingCell
{
    if(!_sizingCell){
        _sizingCell = [[[NSBundle mainBundle] loadNibNamed:@"RestaurantCell" owner:self options:nil] firstObject];
    }
    return _sizingCell;
}

#pragma mark - Setup

-(void)registerInstructionCellNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionsCell_RequestGPS" bundle:nil] forCellReuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
}


-(void)checkUserLocation
{
    BOOL userAlreadyEnabledLocation = [[NSUserDefaults standardUserDefaults] boolForKey:LOCATION_SERVICES_ENABLED];
    if(userAlreadyEnabledLocation == NO){
        InstructionsCell_RequestGPS *cell = (InstructionsCell_RequestGPS *)self.instructionsCell;
        cell.delegate = self;
    }
}


#pragma mark - SearchableCDTVC Required Methods

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    //NSLog(@"Favorites setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:RESTAURANT_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    if(text){
        request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",[text lowercaseString]];
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    RestaurantCell *cell = [self.tableView dequeueReusableCellWithIdentifier:RESTAURANT_CELL forIndexPath:indexPath];
    
    // Configure the cell...
    Restaurant2 *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell setupCellForRestaurant:restaurant];
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Restaurant Segue" sender:cell];
}

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    Restaurant2 *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.sizingCell setupCellForRestaurant:restaurant];
    return CGRectGetHeight(self.sizingCell.bounds);
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // NSLog(@"prepareForSegue...");
    if([sender isKindOfClass:[UITableViewCell class]]){
        
        UITableViewCell *tvc = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
        
        if(indexPath){
            if([segue.destinationViewController isKindOfClass:[Restaurant_SICDTVC class]]){
                
                // Get the new view controller using [segue destinationViewController].
                Restaurant_SICDTVC *restaurantCDTVC = (Restaurant_SICDTVC *)segue.destinationViewController;
                
                // Pass the selected object to the new view controller.
                Restaurant2 *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [restaurantCDTVC setupWithRestaurant:restaurant];
            }
        }
    }
}


#pragma mark - Target Action

- (IBAction)revealLeftPanel:(UIBarButtonItem *)sender
{
    NSLog(@"revealLeftPanel");
}



#pragma mark - RequestUserLocation

-(void)requestUserLocationUserRequested:(BOOL)userRequested
{
    [[LocationHelper sharedInstance] refreshUserLocationBecauseUserRequested:userRequested completionHandler:^(BOOL requestNearbyRestaurants, CLLocation *location) {
        if(requestNearbyRestaurants){
            // Call server with coordinates of the CLLocation
            NSLog(@"Get nearby restaurants from server");
            
            if(self.displayInstructionsCell == YES){
                self.displayInstructionsCell = NO;
            }
            [self getMoreResultsFromTheServer];
            
        } else {
            NSLog(@"Don't request nearby restaurants");
        }
    }];
}




-(void)getMoreResultsFromTheServer
{
    double latitude = 1;
    double longitude = 1;
    ServerCommunicator *caller = [[ServerCommunicator alloc] init];
    [caller getRestaurantsNearLatitude:latitude longitude:longitude];
}









@end
