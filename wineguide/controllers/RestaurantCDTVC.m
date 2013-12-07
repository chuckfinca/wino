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
#import "GroupDataHelper.h"
#import "Wine.h"
#import "Brand.h"
#import "Group.h"
#import "WineUnit.h"
#import "Varietal.h"
#import "TastingNote.h"
#import "ColorSchemer.h"
#import "WineCell.h"

#define JSON @"json"
#define GROUP_ENTITY @"Group"
#define WINE_UNIT_ENTITY @"WineUnit"
#define WINE_CELL @"WineCell"

typedef enum {
    MostPopular,
    HighestRated,
    BestValue,
    All,
    ExcellentVintages,
    RareFinds,
} WineList;

@interface RestaurantCDTVC () <UITableViewDelegate, UITableViewDataSource, RestaurantDetailsVC_WineSelectionDelegate>

@property (nonatomic, strong) RestaurantDetailsVC *restaurantDetailsViewController;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL restaurantWineListCached;
@property (nonatomic, strong) NSString *listName;
@property (nonatomic, strong) NSFetchedResultsController *restaurantGroupsFRC;
@property (nonatomic, strong) NSString *selectedGroupIdentifier;


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
    self.title = @"Wine List";
    [self.tableView registerNib:[UINib nibWithNibName:@"WineCell" bundle:nil] forCellReuseIdentifier:WINE_CELL];
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

-(RestaurantDetailsVC *)restaurantDetailsViewController
{
    if(!_restaurantDetailsViewController){
        _restaurantDetailsViewController = [[RestaurantDetailsVC alloc] initWithNibName:@"RestaurantDetails" bundle:nil];
        _restaurantDetailsViewController.delegate = self;
    }
    return _restaurantDetailsViewController;
}

#pragma mark - Setup

-(void)setupWithRestaurant:(Restaurant *)restaurant
{
    // get the winelist for that restaurant
    self.restaurant = restaurant;
    self.context = restaurant.managedObjectContext;
    [self.restaurantDetailsViewController setupWithRestaurant:restaurant];
    self.tableView.tableHeaderView = self.restaurantDetailsViewController.view;
    
    // [self logDetails];
    
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
    GroupDataHelper *gdh = [[GroupDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [gdh updateCoreDataWithJSONFromURL:allGroupUrl];
}

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_UNIT_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"wine.color"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"wine.varietalIdentifiers"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"wine.name"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY groups.identifier = %@",self.selectedGroupIdentifier];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"wine.color"
                                                                                   cacheName:nil];
    //[self logFetchResultsForController:self.fetchedResultsController];
}

-(void)logFetchResultsForController:(NSFetchedResultsController *)frc
{
    NSLog(@"fetchedResultCount = %lu",(unsigned long)[frc.fetchedObjects count]);
    for(NSObject *fetchedResult in frc.fetchedObjects){
        NSLog(@"fetchedResult = %@",fetchedResult.description);
    }
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = WINE_CELL;
    WineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    WineUnit *wineUnit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupCellForWineUnit:wineUnit];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"WineDetailsSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [[theSection name] capitalizedString];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 // if this method is used we need to register the appropriate class for use as a reuseable view (probably in viewDidLoad).
 // [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"TableViewSectionHeaderViewIdentifier"];
 
 UITableViewHeaderFooterView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableViewSectionHeaderViewIdentifier"];
 sectionHeaderView.contentView.backgroundColor = [UIColor purpleColor];
 return sectionHeaderView;
 }
 */


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
                [wineCDTVC setupWithWine:wineUnit.wine fromRestaurant:self.restaurant];
            }
        }
    }
}

#pragma mark - RestaurantDetailsVC_WineSelectionDelegate

-(void)loadWineList:(NSUInteger)listNumber
{
    NSNumber *sortOrder = [NSNumber numberWithInteger:listNumber];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:GROUP_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"restaurantIdentifier = %@ AND sortOrder = %@",self.restaurant.identifier,sortOrder];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    
    NSError *error;
    NSArray *match = [self.context executeFetchRequest:request error:&error];
    
    if([match count] == 1){
        Group *group = (Group *)[match firstObject];
        self.selectedGroupIdentifier = group.identifier;
    } else if([match count] > 1){
        [self setSortOrderForGroups];
    } else {
        NSLog(@"Restaurant's wine list Group not found");
        self.selectedGroupIdentifier = nil;
    }
    
    self.fetchedResultsController = nil;
    [self setupFetchedResultsController];
}

-(void)setSortOrderForGroups
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:GROUP_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"restaurantIdentifier = %@",self.restaurant.identifier];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    
    int index = 0;
    for(Group *group in matches){
        group.sortOrder = [NSNumber numberWithInt:index];
        index++;
    }
    [self loadWineList:0];
}





#pragma mark - Restaurant Details

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.restaurant.identifier);
    NSLog(@"address = %@",self.restaurant.address);
    NSLog(@"city = %@",self.restaurant.city);
    NSLog(@"country = %@",self.restaurant.country);
    NSLog(@"lastServerUpdate = %@",self.restaurant.lastServerUpdate);
    NSLog(@"latitude = %@",self.restaurant.latitude);
    NSLog(@"longitude = %@",self.restaurant.longitude);
    NSLog(@"deletedEntity = %@",self.restaurant.deletedEntity);
    NSLog(@"menuNeedsUpdating = %@",self.restaurant.menuNeedsUpdating);
    NSLog(@"name = %@",self.restaurant.name);
    NSLog(@"state = %@",self.restaurant.state);
    NSLog(@"versionNumber = %@",self.restaurant.versionNumber);
    NSLog(@"zip = %@",self.restaurant.zip);
    NSLog(@"flightIdentifiers = %@",self.restaurant.flightIdentifiers);
    NSLog(@"groupIdentifiers = %@",self.restaurant.groupIdentifiers);
    
    NSLog(@"flights count = %lu",(unsigned long)[self.restaurant.flights count]);
    for(NSObject *obj in self.restaurant.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groups count = %lu",(unsigned long)[self.restaurant.groups count]);
    for(NSObject *obj in self.restaurant.groups){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"\n\n\n");
}



@end
