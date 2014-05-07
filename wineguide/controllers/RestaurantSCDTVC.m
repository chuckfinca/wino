//
//  RestaurantTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantSCDTVC.h"
#import "RestaurantDetailsVC.h"
#import "WineTRSCDTVC.h"
#import "RestaurantDataHelper.h"
#import "GroupDataHelper.h"
#import "Wine.h"
#import "Brand.h"
#import "Group.h"
#import "Varietal.h"
#import "TastingNote.h"
#import "ColorSchemer.h"
#import "WineCell.h"

#define JSON @"json"
#define GROUP_ENTITY @"Group"
#define WINE_ENTITY @"Wine"
#define WINE_CELL @"WineCell"

typedef enum {
    MostPopular,
    HighestRated,
    BestValue,
    All,
    ExcellentVintages,
    RareFinds,
} WineList;

@interface RestaurantSCDTVC () <UITableViewDelegate, UITableViewDataSource, RestaurantDetailsVC_WineSelectionDelegate>

@property (nonatomic, strong) RestaurantDetailsVC *restaurantDetailsViewController;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL restaurantWineListCached;
@property (nonatomic, strong) NSString *listName;
@property (nonatomic, strong) NSFetchedResultsController *restaurantGroupsFRC;
@property (nonatomic, strong) NSString *selectedGroupIdentifier;
@property (nonatomic, strong) WineCell *wineSizingCell;

@property (nonatomic, strong) NSArray *testingArray;

@end

@implementation RestaurantSCDTVC

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
    
    self.title = @"Wine List";
    [self.tableView registerNib:[UINib nibWithNibName:@"WineCell" bundle:nil] forCellReuseIdentifier:WINE_CELL];
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"TableViewSectionHeaderViewIdentifier"];
    
    // allows the tableview to load faster
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
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

-(WineCell *)wineSizingCell
{
    if(!_wineSizingCell){
        _wineSizingCell = [[[NSBundle mainBundle] loadNibNamed:@"WineCell" owner:self options:nil] firstObject];
    }
    return _wineSizingCell;
}

-(NSArray *)testingArray
{
    if(!_testingArray){
        _testingArray = @[@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3,@2,@0,@1,@2,@3];
    }
    return _testingArray;
}

#pragma mark - Setup

-(void)setupWithRestaurant:(Restaurant *)restaurant
{
    // get the winelist for that restaurant
    self.restaurant = restaurant;
    self.context = restaurant.managedObjectContext;
    [self.restaurantDetailsViewController setupWithRestaurant:restaurant];
    self.tableView.tableHeaderView = self.restaurantDetailsViewController.view;
    
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
    if(self.restaurant.identifier){
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
}

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"color"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY groups.identifier = %@",self.selectedGroupIdentifier];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"color"
                                                                                   cacheName:nil];
    // NSLog(@"%@",self.fetchedResultsController.fetchedObjects);
}

-(void)logFetchResultsForController:(NSFetchedResultsController *)frc
{
    NSLog(@"fetchedResultCount = %lu",(unsigned long)[frc.fetchedObjects count]);
    for(NSObject *fetchedResult in frc.fetchedObjects){
        NSLog(@"fetchedResult = %@",fetchedResult.description);
    }
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    WineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:WINE_CELL forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSNumber *num = self.testingArray[indexPath.row];
    [cell setupCellForWine:wine numberOfTalkingHeads:[num integerValue]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(NSString *)titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [[theSection name] capitalizedString];
}

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSNumber *num = self.testingArray[indexPath.row];
    [self.wineSizingCell setupCellForWine:wine numberOfTalkingHeads:[num integerValue]];
    
    return self.wineSizingCell.bounds.size.height;
}


-(UIView *)viewForHeaderInSection:(NSInteger)section
{
    Wine *wine = (Wine *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    
    UITableViewHeaderFooterView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableViewSectionHeaderViewIdentifier"];
    
    if(wine.color){
        [sectionHeaderView.textLabel setTextColor:[ColorSchemer sharedInstance].textPrimary];
    }
    return sectionHeaderView;
}

-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"userDidSelectRowAtIndexPath");
    WineTRSCDTVC *wineCDTVC = [[WineTRSCDTVC alloc] initWithStyle:UITableViewStylePlain];
    
    // Pass the selected object to the new view controller.
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [wineCDTVC setupWithWine:wine fromRestaurant:self.restaurant];
    
    [self.navigationController pushViewController:wineCDTVC animated:YES];
}

#pragma mark - RestaurantDetailsVC_WineSelectionDelegate

-(void)loadWineList:(NSUInteger)listNumber
{
    if(self.restaurant.identifier){
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
    }
    
    self.fetchedResultsController = nil;
    [self setupAndSearchFetchedResultsControllerWithText:nil];
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







-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
