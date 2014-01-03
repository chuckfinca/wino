//
//  RestaurantsTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantsSCDTVC.h"
#import "RestaurantCDTVC.h"
#import "RestaurantDataHelper.h"
#import "Restaurant.h"
#import "ColorSchemer.h"

#define RESTAURANT_ENTITY @"Restaurant"

#define SHOW_OR_HIDE_LEFT_PANEL @"ShowHideLeftPanel"

@interface RestaurantsSCDTVC () <UISearchBarDelegate, UISearchDisplayDelegate>

@end

@implementation RestaurantsSCDTVC

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
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - Getters & Setters

-(NSPredicate *)fetchPredicate
{
    return nil;
}


#pragma mark - Setup

-(void)setupSearchBar
{
    self.searchBar.placeholder = @"Search...";
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
    [self findRestaurantsNearby];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"cellForRowAtIndexPath...");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell" forIndexPath:indexPath];
    cell.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    // Configure the cell...
    [self setupTextForCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // NSLog(@"prepareForSegue...");
    if([sender isKindOfClass:[UITableViewCell class]]){
        
        UITableViewCell *tvc = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
        
        if(indexPath){
            if([segue.destinationViewController isKindOfClass:[RestaurantCDTVC class]]){
                
                // Get the new view controller using [segue destinationViewController].
                RestaurantCDTVC *restaurantCDTVC = (RestaurantCDTVC *)segue.destinationViewController;
                
                // Pass the selected object to the new view controller.
                Restaurant *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [restaurantCDTVC setupWithRestaurant:restaurant];
            }
        }
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
    } else {
        request.predicate = self.fetchPredicate;
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Update Core Data

-(void)findRestaurantsNearby
{
    // this will be replaced with a server url when available
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"restaurants" withExtension:@"json"];
    
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [rdh updateCoreDataWithJSONFromURL:url];
}

#pragma mark - Target Action

- (IBAction)revealLeftPanel:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_OR_HIDE_LEFT_PANEL object:nil];
}





@end
