//
//  RestaurantDetailsViewController.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDetailsVC.h"
#import "RestaurantDetailsVHTV.h"
#import "Group.h"

#define GROUP_ENTITY @"Group"

@interface RestaurantDetailsVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet RestaurantDetailsVHTV *restaurantDetailsVHTV;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation RestaurantDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 127);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:GROUP_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"restaurantIdentifier = %@",self.restaurant.identifier];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.restaurant.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    // [self logFetchResultsForController:self.fetchedResultsController];
}

-(void)logFetchResultsForController:(NSFetchedResultsController *)frc
{
    NSLog(@"fetchedResultCount = %lu",(unsigned long)[frc.fetchedObjects count]);
    for(NSObject *fetchedResult in frc.fetchedObjects){
        NSLog(@"fetchedResult = %@",fetchedResult.description);
    }
}


-(void)setupSegmentedControl
{
    int index = 0;
    for(Group *group in self.fetchedResultsController.fetchedObjects){
        [self.segmentedControl setTitle:group.name forSegmentAtIndex:index];
        if(index < 3){
            index++;
        } else {
            break;
        }
    }
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:10.0]} forState:UIControlStateNormal];
    [self.delegate loadWineList:[self.segmentedControl selectedSegmentIndex]];
}


#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self setupSegmentedControl];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupWithRestaurant:(Restaurant *)restaurant
{
    [self.restaurantDetailsVHTV setupTextViewWithRestaurant:restaurant];
    self.restaurant = restaurant;
    [self setupFetchedResultsController];
    [self setupSegmentedControl];
}


- (IBAction)refreshList:(UISegmentedControl *)sender {
    [self.delegate loadWineList:sender.selectedSegmentIndex];
}

@end
