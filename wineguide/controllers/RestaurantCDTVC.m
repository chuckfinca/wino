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
#import "Varietal.h"
#import "TastingNote.h"
#import "ColorSchemer.h"
#import "WineCell.h"
#import "CollectionViewWithIndex.h"
#import "RatingsReusableView.h"

#define JSON @"json"
#define GROUP_ENTITY @"Group"
#define WINE_ENTITY @"Wine"
#define WINE_CELL @"WineCell"
#define RATINGS_COLLECTION_VIEW_CELL @"RatingsCollectionViewCell"
#define REVIEWS_COLLECTION_VIEW_CELL @"ReviewersCollectionViewCell"

typedef enum {
    MostPopular,
    HighestRated,
    BestValue,
    All,
    ExcellentVintages,
    RareFinds,
} WineList;

@interface RestaurantCDTVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, RestaurantDetailsVC_WineSelectionDelegate>

@property (nonatomic, strong) RestaurantDetailsVC *restaurantDetailsViewController;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL restaurantWineListCached;
@property (nonatomic, strong) NSString *listName;
@property (nonatomic, strong) NSFetchedResultsController *restaurantGroupsFRC;
@property (nonatomic, strong) NSString *selectedGroupIdentifier;


@property (nonatomic, strong) NSArray *tEMPORARYratings;

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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"color"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"varietalIdentifiers"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY groups.identifier = %@",self.selectedGroupIdentifier];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"color"
                                                                                   cacheName:nil];
    [self setTEMPORARYratings];
}

-(void)setTEMPORARYratings
{
    NSMutableArray *temporaryRatings = [[NSMutableArray alloc] init];
    for(id obj in self.fetchedResultsController.fetchedObjects){
        // temporary rating generator
        float rating = arc4random_uniform(11) + 1;
        rating = rating/2;
        [temporaryRatings addObject:@(rating)];
    }
    self.tEMPORARYratings = temporaryRatings;
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
    WineCell *cell = [tableView dequeueReusableCellWithIdentifier:WINE_CELL forIndexPath:indexPath];
    
    cell.ratingsCollectionView.delegate = self;
    cell.ratingsCollectionView.dataSource = self;
    cell.ratingsCollectionView.index = indexPath.row;
    [cell.ratingsCollectionView registerNib:[UINib nibWithNibName:@"RatingsCVC" bundle:nil] forCellWithReuseIdentifier:RATINGS_COLLECTION_VIEW_CELL];
    
    cell.reviewersCollectionView.delegate = self;
    cell.reviewersCollectionView.dataSource = self;
    cell.reviewersCollectionView.index = indexPath.row;
    [cell.reviewersCollectionView registerNib:[UINib nibWithNibName:@"ReviewerCVC" bundle:nil] forCellWithReuseIdentifier:REVIEWS_COLLECTION_VIEW_CELL];
    
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setupCellForWine:wine];
    
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
    return 300;
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
                Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [wineCDTVC setupWithWine:wine fromRestaurant:self.restaurant];
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


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItemsInSection = 0;
    
    if([collectionView isKindOfClass:[CollectionViewWithIndex class]]){
        CollectionViewWithIndex *collectionViewWithIndex = (CollectionViewWithIndex *)collectionView;
        
        if(collectionViewWithIndex.tag == RatingsCollectionView){
            numberOfItemsInSection = 6;
            
        } else if (collectionViewWithIndex.tag == ReviewersCollectionView){
            
            // the number below needs to be replaced with the number of friend reviews (up to 3 or 4) once we have users set up
            numberOfItemsInSection = 3;
            
            
        } else {
            NSLog(@"unknown collection view with tag = %i is asking for numberOfItemsInSection",collectionViewWithIndex.tag);
        }
    } else {
        NSLog(@"collection view asking for numberOfItemsInSection is not of class CollectionViewWithIndex");
    }
    
    return numberOfItemsInSection;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if(collectionView.tag == RatingsCollectionView){
        
        RatingsReusableView *ratingsCell = (RatingsReusableView *)[collectionView dequeueReusableCellWithReuseIdentifier:RATINGS_COLLECTION_VIEW_CELL forIndexPath:indexPath];
        
        CollectionViewWithIndex *cvwi = (CollectionViewWithIndex *)collectionView;
        float rating = [self.tEMPORARYratings[cvwi.index] floatValue];
        NSLog(@"rating = %f",rating);
        
        [ratingsCell setupImageViewForGlassNumber:indexPath.row andRating:rating];
        
        cell = (UICollectionViewCell *)ratingsCell;
        
    } else if (collectionView.tag == ReviewersCollectionView){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:REVIEWS_COLLECTION_VIEW_CELL forIndexPath:indexPath];
        cell.backgroundColor = [UIColor purpleColor];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate



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







-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
