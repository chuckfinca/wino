//
//  RestaurantsTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "NearbyRestaurants_SICDTVC.h"
#import "Restaurant_SICDTVC.h"
#import "RestaurantDataHelper.h"
#import "Restaurant.h"
#import "ColorSchemer.h"
#import "ServerCommunicator.h"
#import "RestaurantHelper.h"
#import "DocumentHandler2.h"
#import "InstructionsCell_RequestGPS.h"

#define SHOW_OR_HIDE_LEFT_PANEL @"ShowHideLeftPanel"
#define RESTAURANT_ENTITY @"Restaurant"

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
    [self setupSearchBar];
    self.navigationItem.title = @"Restaurants Nearby";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Setup

-(void)registerInstructionCellNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionsCell_RequestGPS" bundle:nil] forCellReuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
}

-(void)setupSearchBar
{
    self.searchBar.placeholder = @"Search for restaurants...";
}

-(void)setupTextForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Restaurant *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(restaurant.name){
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[restaurant.name capitalizedString] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    }
    if(restaurant.address){
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:[restaurant.address capitalizedString] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    }
}

-(void)getMoreResultsFromTheServer
{
    // this will be replaced with a server url when available
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"restaurants" withExtension:@"json"];
    
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [rdh updateCoreDataWithJSONFromURL:url];
    
    
    [[DocumentHandler2 sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
        double latitude = 1;
        double longitude = 1;
        ServerCommunicator *caller = [[ServerCommunicator alloc] init];
        [caller getRestaurantsNearLatitude:latitude longitude:longitude];
        [caller getAllWinesFromRestaurantIdentifier:1];
    }];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RestaurantCell" forIndexPath:indexPath];
    cell.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    // Configure the cell...
    [self setupTextForCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Restaurant Segue" sender:cell];
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
                Restaurant *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [restaurantCDTVC setupWithRestaurant:restaurant];
            }
        }
    }
}


#pragma mark - Target Action

- (IBAction)revealLeftPanel:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_OR_HIDE_LEFT_PANEL object:nil];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
