//
//  RestaurantTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantCDTVC.h"
#import "RestaurantDetailsVC.h"
#import "WineCDTVC.h"
#import "RestaurantDataHelper.h"
#import "GroupingDataHelper.h"
#import "Wine.h"
#import "Brand.h"
#import "Group.h"
#import "WineUnit.h"

#define JSON @"json"

typedef enum {
    MostPopular,
    HighestRated,
    RareFinds,
    ExcellentVintages,
    All
} WineList;

@interface RestaurantCDTVC () <UITableViewDelegate, UITableViewDataSource, RestaurantDetailsVC_WineSelectionDelegate>

@property (nonatomic, strong) RestaurantDetailsVC *restaurantDetailsViewController;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL restaurantWineListCached;
@property (nonatomic, strong) NSString *listName;



@end

@implementation RestaurantCDTVC

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.tableHeaderView = self.restaurantDetailsViewController.view;
    self.debug = YES;
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

-(NSString *)listName
{
    if(!_listName) _listName = @"popular";
    return _listName;
}


#pragma mark - Setup

-(void)setupWithRestaurant:(Restaurant *)restaurant
{
    // get the winelist for that restaurant
    [self.restaurantDetailsViewController setupWithRestaurant:restaurant];
    self.restaurantDetailsViewController.delegate = self;
    self.restaurant = restaurant;
    
    // [self logDetails];
    
    self.context = restaurant.managedObjectContext;
    [self refreshWineList];
    self.title = nil;
}

-(void)refreshWineList
{
    // if we have cached data about the restaurant's wine list then display that, if not get it from the server
    if(self.restaurantWineListCached == NO){
        [self getWineList];
    }
}

-(void)getWineList
{
    // ask for a restaurant specific info inncluding groupings and flights
    NSURL *restaurantUrl = [[NSBundle mainBundle] URLForResource:self.restaurant.identifier withExtension:JSON];
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [rdh updateCoreDataWithJSONFromURL:restaurantUrl];
    
    // grouping.identifiers should be restaurant.identifies with the amended group name, that way I can assume I know the all group identifier to make the appropriate call.
    // call the server and ask for the all group, including all wineUnits, wines and brands
    
    
    NSString *urlString = [NSString stringWithFormat:@"group.%@.all",self.restaurant.identifier];
    NSURL *allGroupUrl = [[NSBundle mainBundle] URLForResource:urlString withExtension:JSON];
    GroupingDataHelper *gdh = [[GroupingDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [gdh updateCoreDataWithJSONFromURL:allGroupUrl];
    
    [self setupFetchedResultsController];
}


#define WINE_UNIT_ENTITY @"WineUnit"

-(void)setupFetchedResultsController
{
    // NSLog(@"setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_UNIT_ENTITY];
    request.sortDescriptors = @[
                                [NSSortDescriptor sortDescriptorWithKey:@"wine.color"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"wine.name"
                                                              ascending:YES]];
    
    NSString *groupIdentifier = [NSString stringWithFormat:@"group.%@.%@",self.restaurant.identifier,self.listName];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY groups.identifier = %@",groupIdentifier];
    
    request.shouldRefreshRefetchedObjects = YES;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"wine.color"
                                                                                   cacheName:nil];
    NSLog(@"fetchedResultCount = %i",[self.fetchedResultsController.fetchedObjects count]);
    for(NSObject *fetchedResult in self.fetchedResultsController.fetchedObjects){
        NSLog(@"fetchedResult = %@",fetchedResult.description);
    }
    self.title = @"";
}

#pragma mark - Getters & Setters

-(RestaurantDetailsVC *)restaurantDetailsViewController
{
    if(!_restaurantDetailsViewController){
        _restaurantDetailsViewController = [[RestaurantDetailsVC alloc] initWithNibName:@"RestaurantDetails" bundle:nil];
    }
    return _restaurantDetailsViewController;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    WineUnit *wineUnit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:wineUnit.wine.name attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];

    return cell;
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WineSectionHeader"];
    return view;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // NSLog(@"prepareForSegue...");
    if([sender isKindOfClass:[UITableViewCell class]]){
        
        UITableViewCell *tvc = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
        
        if(indexPath){
            if([segue.destinationViewController isKindOfClass:[WineCDTVC class]]){
                
                // Get the new view controller using [segue destinationViewController].
                WineCDTVC *wineCDTVC = (WineCDTVC *)segue.destinationViewController;
                
                // Pass the selected object to the new view controller.
                WineUnit *wineUnit = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [wineCDTVC setupWithWine:wineUnit.wine];
            }
        }
    }
}


#pragma mark - RestaurantDetailsVC_WineSelectionDelegate

-(void)loadWineList:(int)listNumber
{
    switch (listNumber) {
        case MostPopular:
            // fetch
            self.listName = @"mostpopular";
            break;
        case HighestRated:
            // fetch
            self.listName = @"highestrated";
            break;
        case RareFinds:
            // fetch
            self.listName = @"rarefinds";
            break;
        case ExcellentVintages:
            // fetch
            self.listName = @"excellentvintages";
            break;
        case All:
            // fetch
            self.listName = @"all";
            break;
            
        default:
            break;
    }
    self.fetchedResultsController = nil;
    [self setupFetchedResultsController];
}





#pragma mark - Restaurant Details

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.restaurant.identifier);
    NSLog(@"address = %@",self.restaurant.address);
    NSLog(@"city = %@",self.restaurant.city);
    NSLog(@"country = %@",self.restaurant.country);
    NSLog(@"lastAccessed = %@",self.restaurant.lastAccessed);
    NSLog(@"latitude = %@",self.restaurant.latitude);
    NSLog(@"longitude = %@",self.restaurant.longitude);
    NSLog(@"markForDeletion = %@",self.restaurant.markForDeletion);
    NSLog(@"menuNeedsUpdating = %@",self.restaurant.menuNeedsUpdating);
    NSLog(@"name = %@",self.restaurant.name);
    NSLog(@"state = %@",self.restaurant.state);
    NSLog(@"version = %@",self.restaurant.version);
    NSLog(@"zip = %@",self.restaurant.zip);
    NSLog(@"flightIdentifiers = %@",self.restaurant.flightIdentifiers);
    NSLog(@"groupIdentifiers = %@",self.restaurant.groupIdentifiers);
    
    NSLog(@"flights count = %i",[self.restaurant.flights count]);
    for(NSObject *obj in self.restaurant.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groups count = %i",[self.restaurant.groups count]);
    for(NSObject *obj in self.restaurant.groups){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"\n\n\n");
}



@end
