//
//  RestaurantTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant_SICDTVC.h"
#import "RestaurantDetailsVC.h"
#import "Wine_TRSICDTVC.h"
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
#define WINE_CELL_WITH_RATING @"WineCell_withRating"
#define WINE_CELL_WITH_RATING_AND_TALKING_HEADS @"WineCell_withRatingAndTalkingHeads"

typedef enum {
    MostPopular,
    HighestRated,
    BestValue,
    All,
    ExcellentVintages,
    RareFinds,
} WineList;

@interface Restaurant_SICDTVC () <UITableViewDelegate, UITableViewDataSource, RestaurantDetailsVC_WineSelectionDelegate>

@property (nonatomic, strong) RestaurantDetailsVC *restaurantDetailsViewController;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic) BOOL restaurantWineListCached;
@property (nonatomic, strong) NSString *listName;
@property (nonatomic, strong) NSFetchedResultsController *restaurantGroupsFRC;
@property (nonatomic, strong) NSString *selectedGroupIdentifier;

@property (nonatomic, strong) WineCell *sizingCell;
@property (nonatomic, strong) WineCell *sizingCellWithRating;
@property (nonatomic, strong) WineCell *sizingCellWithRatingAndTalkingHeads;

@property (nonatomic, strong) NSArray *testingArray;

@end

@implementation Restaurant_SICDTVC

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
    
    [self.tableView registerNib:[UINib nibWithNibName:WINE_CELL bundle:nil] forCellReuseIdentifier:WINE_CELL];
    [self.tableView registerNib:[UINib nibWithNibName:WINE_CELL_WITH_RATING bundle:nil] forCellReuseIdentifier:WINE_CELL_WITH_RATING];
    [self.tableView registerNib:[UINib nibWithNibName:WINE_CELL_WITH_RATING_AND_TALKING_HEADS bundle:nil] forCellReuseIdentifier:WINE_CELL_WITH_RATING_AND_TALKING_HEADS];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"TableViewSectionHeaderViewIdentifier"];
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

-(WineCell *)sizingCell
{
    if(!_sizingCell){
        _sizingCell = [[[NSBundle mainBundle] loadNibNamed:WINE_CELL owner:self options:nil] firstObject];
    }
    return _sizingCell;
}

-(WineCell *)sizingCellWithRating
{
    if(!_sizingCellWithRating){
        _sizingCellWithRating = [[[NSBundle mainBundle] loadNibNamed:WINE_CELL_WITH_RATING owner:self options:nil] firstObject];
    }
    return _sizingCellWithRating;
}

-(WineCell *)sizingCellWithRatingAndTalkingHeads
{
    if(!_sizingCellWithRatingAndTalkingHeads){
        _sizingCellWithRatingAndTalkingHeads = [[[NSBundle mainBundle] loadNibNamed:WINE_CELL_WITH_RATING_AND_TALKING_HEADS owner:self options:nil] firstObject];
    }
    return _sizingCellWithRatingAndTalkingHeads;
}

-(NSArray *)testingArray
{
    if(!_testingArray){
        _testingArray = @[@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2];
    }
    return _testingArray;
}

-(NSString *)selectedGroupIdentifier
{
    if(!_selectedGroupIdentifier){
        _selectedGroupIdentifier = [NSString stringWithFormat:@"group.%@.all",self.restaurant.identifier];
    }
    return _selectedGroupIdentifier;
}

#pragma mark - Setup

-(void)setupWithRestaurant:(Restaurant *)restaurant
{
    // get the winelist for that restaurant
    self.restaurant = restaurant;
    [self.restaurantDetailsViewController setupWithRestaurant:restaurant];
    self.tableView.tableHeaderView = self.restaurantDetailsViewController.view;
    
    [self refreshWineList];
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
    NSLog(@"self.selectedGroupIdentifier = %@",self.selectedGroupIdentifier);
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    WineCell *cell = [self testCellForIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell setupCellForWine:wine];
    
    return cell;
}

-(WineCell *)testCellForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger typeOfCell = [self.testingArray[indexPath.row] integerValue];
    switch (typeOfCell) {
        case 1:
            return [self.tableView dequeueReusableCellWithIdentifier:WINE_CELL_WITH_RATING forIndexPath:indexPath];
            break;
        case 2:
            return [self.tableView dequeueReusableCellWithIdentifier:WINE_CELL_WITH_RATING_AND_TALKING_HEADS forIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    return [self.tableView dequeueReusableCellWithIdentifier:WINE_CELL forIndexPath:indexPath];
}

-(WineCell *)testSizingCellForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger typeOfCell = [self.testingArray[indexPath.row] integerValue];
    switch (typeOfCell) {
        case 1:
            return self.sizingCellWithRating;
            break;
        case 2:
            return self.sizingCellWithRatingAndTalkingHeads;
            break;
            
        default:
            break;
    }
    return self.sizingCell;
}

#pragma mark - UITableViewDelegate

-(NSString *)titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [[theSection name] capitalizedString];
}

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    WineCell *cell = [self testSizingCellForIndexPath:indexPath];
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupCellForWine:wine];
    
    return cell.bounds.size.height;
}


-(UIView *)viewForHeaderInSection:(NSInteger)section
{
    Wine *wine = (Wine *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    
    UITableViewHeaderFooterView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableViewSectionHeaderViewIdentifier"];
    
    if(wine.color){
        [sectionHeaderView.textLabel setTextColor:[ColorSchemer sharedInstance].textPrimary];
    }
    sectionHeaderView.contentView.backgroundColor = [ColorSchemer sharedInstance].gray;
    return sectionHeaderView;
}

-(CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"userDidSelectRowAtIndexPath");
    Wine_TRSICDTVC *wineCDTVC = [[Wine_TRSICDTVC alloc] initWithStyle:UITableViewStylePlain];
    
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
