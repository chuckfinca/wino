//
//  RestaurantTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantCDTVC.h"
#import "RestaurantDetailsVC.h"
#import "Wine+CreateAndModify.h"
#import "WineDataHelper.h"
#import "Brand.h"
#import "WineCDTVC.h"

@interface RestaurantCDTVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RestaurantDetailsVC *restaurantDetailsViewController;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL restaurantWineListCached;

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
    
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

-(void)setupWithRestaurant:(Restaurant *)restaurant
{
    // get the winelist for that restaurant
    [self.restaurantDetailsViewController setupWithRestaurant:restaurant];
    self.restaurant = restaurant;
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
    NSString *restaurantName = self.restaurant.name;
    NSString *nameWithoutSpaces = [restaurantName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // this will be replaced with a server url when available
    NSURL *url = [[NSBundle mainBundle] URLForResource:nameWithoutSpaces withExtension:@"json"];
    
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:self.context];
    wdh.restaurant = self.restaurant;
    
    [wdh updateCoreDataWithJSONFromURL:url];
    [self setupFetchedResultsController];
}

-(void)setupFetchedResultsController
{
    // NSLog(@"setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Wine"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"color"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)],
                                [NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"restaurants CONTAINS %@",self.restaurant];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"color"
                                                                                   cacheName:nil];
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
    
    // Configure the cell...
    
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:wine.brand.name attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
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
                Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [wineCDTVC setupWithWine:wine];
            }
        }
    }
}



@end
