//
//  RestaurantsTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantsCDTVC.h"
#import "RestaurantCDTVC.h"
#import "Restaurant.h"
#import "InitialTabBarController.h"

@interface RestaurantsCDTVC ()

@property (nonatomic, weak) NSManagedObjectContext *context;

@end

@implementation RestaurantsCDTVC

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
    
    if([self.tabBarController isKindOfClass:[InitialTabBarController class]]){
        InitialTabBarController *itbc = (InitialTabBarController *)self.tabBarController;
        self.context = itbc.context;
    }
    if (self.context){
        [self setupFetchedResultsController];
    }
    if(self.fetchedResultsController.fetchedObjects > 0){
        self.title = @"Nearby";
    }
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

-(void)setupFetchedResultsController
{
    // NSLog(@"setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                       managedObjectContext:self.context
                                                                                         sectionNameKeyPath:nil
                                                                                                  cacheName:nil];
}

-(void)setupTextForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Restaurant *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(restaurant.name){
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[restaurant.name capitalizedString] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    }
    if(restaurant.address){
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:[restaurant.address capitalizedString] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    }
}


#pragma mark - Getters & Setters



#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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


@end
