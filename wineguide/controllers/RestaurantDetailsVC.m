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
#import "ColorSchemer.h"

#define GROUP_ENTITY @"Group"

@interface RestaurantDetailsVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet RestaurantDetailsVHTV *restaurantDetailsVHTV;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRestaurantInfoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantInfoToSegmentedControlConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedControlToBottomConstraint;

@end

@implementation RestaurantDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"initWithNibName...");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.restaurantDetailsVHTV setupTextViewWithRestaurant:self.restaurant];
    [self setViewHeight];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}
-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += [self.restaurantDetailsVHTV height];
    height += self.segmentedControl.bounds.size.height;
    height += self.topToRestaurantInfoConstraint.constant;
    height += self.restaurantInfoToSegmentedControlConstraint.constant;
    height += self.segmentedControlToBottomConstraint.constant;
    
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
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
    [self.segmentedControl removeAllSegments];
    
    int index = 0;
    for(Group *group in self.fetchedResultsController.fetchedObjects){
        [self.segmentedControl insertSegmentWithTitle:[group.name capitalizedString] atIndex:index animated:NO];
        if(index < 3 && index < [self.fetchedResultsController.fetchedObjects count]){
            index++;
        } else {
            break;
        }
    }
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:10.0]} forState:UIControlStateNormal];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.delegate loadWineList:[self.segmentedControl selectedSegmentIndex]];
    self.segmentedControl.backgroundColor = [ColorSchemer sharedInstance].customWhite;
    self.segmentedControl.tintColor = [ColorSchemer sharedInstance].clickable;
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
    NSLog(@"setupWithRestaurant... %@",restaurant.name);
    self.restaurant = restaurant;
    [self setupFetchedResultsController];
    [self setupSegmentedControl];
}


- (IBAction)refreshList:(UISegmentedControl *)sender {
    [self.delegate loadWineList:sender.selectedSegmentIndex];
}

@end
