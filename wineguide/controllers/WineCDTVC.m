//
//  WineCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineCDTVC.h"
#import "WineDetailsVC.h"
#import "ColorSchemer.h"
#import "ReviewTVC.h"
#import "TriedItVC.h"


#define WINE_CELL @"WineCell"
#define REVIEW_CELL @"ReviewCell"

@interface WineCDTVC () <WineDetailsVcDelegate>

@property (nonatomic, strong) WineDetailsVC *wineDetailsViewController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Wine *wine;
@property (nonatomic, strong) Restaurant *restaurant;

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
    self.tableView.tableHeaderView = self.wineDetailsViewController.view;
    [self.tableView registerNib:[UINib nibWithNibName:@"WineReview" bundle:nil] forCellReuseIdentifier:REVIEW_CELL];
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
        _wineDetailsViewController.delegate = self;
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
    ReviewTVC *cell = [tableView dequeueReusableCellWithIdentifier:REVIEW_CELL forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setupReview];
    //cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:@"review" attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WineSectionHeader"];
    return view;
}


#pragma mark - WineDetailsVcDelegate

-(void)performTriedItSegue
{
    NSLog(@"performTriedItSegue");
    
    TriedItVC *triedItVC = [[TriedItVC alloc]initWithNibName:@"TriedIt" bundle:nil];
    [triedItVC setupWithWine:self.wine andRestaurant:self.restaurant];
    [self.navigationController pushViewController:triedItVC animated:YES];
}








@end

