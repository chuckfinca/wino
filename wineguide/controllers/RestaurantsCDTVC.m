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
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

#define ENTITY_NAME @"Restaurant"
#define DELETE_BOOL @"delete"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define LONGITUDE @"longitude"
#define LATITUDE @"latitude"
#define CITY @"city"
#define ADDRESS @"address"
#define VERSION @"version"
#define IDENTIFIER @"identifier"
#define WINES @"wines"
#define BRANDS @"brands"
#define VARIETALS @"varietals"

-(void)setupFetchedResultsController
{
    NSLog(@"setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                       managedObjectContext:self.context
                                                                                         sectionNameKeyPath:nil
                                                                                                  cacheName:nil];
    for(NSManagedObject *o in self.fetchedResultsController.fetchedObjects){
        if([o isKindOfClass:[Restaurant class]]){
            
            Restaurant *r = (Restaurant *)o;
            NSLog(@"name = %@",r.name);
        }
    }
}


#pragma mark - Getters & Setters



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
    
    Restaurant *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = restaurant.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue...");
    // Get the new view controller using [segue destinationViewController].
    if([sender isKindOfClass:[UITableViewCell class]]){
        
        UITableViewCell *tvc = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
        
        if(indexPath){
            if([segue.destinationViewController isKindOfClass:[RestaurantCDTVC class]]){
                
                NSLog(@"RestaurantCDTVC");
                
                RestaurantCDTVC *restaurantCDTVC = (RestaurantCDTVC *)segue.destinationViewController;
                
                Restaurant *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
                
                [restaurantCDTVC setupWithRestaurant:restaurant];
            }
        }
    }
    // Pass the selected object to the new view controller.
}


@end
