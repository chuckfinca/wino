//
//  WineCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineCDTVC.h"
#import "WineDetailsVC.h"
#import "InitialTabBarController.h"

@interface WineCDTVC ()

@property (nonatomic, strong) WineDetailsVC *wineDetailsViewController;
@property (nonatomic, strong) Wine *wine;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation WineCDTVC

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.tableHeaderView = self.wineDetailsViewController.view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

-(WineDetailsVC *)wineDetailsViewController
{
    if(!_wineDetailsViewController){
        _wineDetailsViewController = [[WineDetailsVC alloc] initWithNibName:@"WineDetails" bundle:nil];
    }
    return _wineDetailsViewController;
}

#pragma mark - Setup

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    [self.wineDetailsViewController setupWithWine:wine fromRestaurant:(Restaurant *)restaurant];
    self.wine = wine;
    self.restaurant = restaurant;
    self.context = wine.managedObjectContext;
    
    // get the reviews for that wine
    [self refreshReviewList];
}

-(void)refreshReviewList
{
    // if we have cached wine review data then display that while checking to see if there is newer information on the server
    
        [self getReviewList];
}

-(void)getReviewList
{
    /* placeholder for future code
     
    NSString *restaurantName = self.restaurant.name;
    NSString *nameWithoutSpaces = [restaurantName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // this will be replaced with a server url when available
    NSURL *url = [[NSBundle mainBundle] URLForResource:nameWithoutSpaces withExtension:@"json"];
    
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:self.context];
    wdh.restaurant = self.restaurant;
    
    [wdh updateCoreDataWithJSONFromURL:url];
    [self setupFetchedResultsController];
     */
}

-(void)setupFetchedResultsController
{
    // NSLog(@"setupFetchedResultsController...");
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:@"review" attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WineSectionHeader"];
    return view;
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end

