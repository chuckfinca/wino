//
//  RestaurantDetailsViewController.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDetailsVC.h"
#import "RestaurantDetailsVHTV.h"
#import "ColorSchemer.h"
#import <MapKit/MapKit.h>

#define GROUP_ENTITY @"Group"
#define METERS_PER_MILE 1609.344

@interface RestaurantDetailsVC () <NSFetchedResultsControllerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet RestaurantDetailsVHTV *restaurantDetailsVHTV;
@property (nonatomic, strong) Restaurant2 *restaurant;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRestaurantInfoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantInfoVHTVToBottomConstraint;

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
    
    [self setupMap];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customWhite;
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToRestaurantInfoConstraint.constant;
    height += [self.restaurantDetailsVHTV height];
    height += self.restaurantInfoVHTVToBottomConstraint.constant;
    
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
}

#pragma mark - Setup

-(void)setupMap
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = mapView.bounds;
    layer.colors = @[(id)[ColorSchemer sharedInstance].customWhite.CGColor, (id)[UIColor clearColor].CGColor];
    layer.startPoint = CGPointMake(0.7f, 0.0f);
    layer.endPoint = CGPointMake(0.0f, 0.0f);
    mapView.layer.mask = layer;
    
    [self.view insertSubview:mapView atIndex:0];
    
    double latitued = [self.restaurant.latitude doubleValue];
    double longitude = [self.restaurant.longitude doubleValue];
    
    CLLocationCoordinate2D restaurantLocation = CLLocationCoordinate2DMake(latitued, longitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitued, longitude-0.002), 0.*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:YES];
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    [pointAnnotation setCoordinate:restaurantLocation];
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] init];
    pin.pinColor = MKPinAnnotationColorPurple;
    pin.annotation = pointAnnotation;
    
    [mapView addAnnotation:pointAnnotation];
}


#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupWithRestaurant:(Restaurant2 *)restaurant
{
    NSLog(@"setupWithRestaurant... %@",restaurant.name);
    self.restaurant = restaurant;
    [self setupFetchedResultsController];
}


- (IBAction)refreshList:(UISegmentedControl *)sender {
    [self.delegate loadWineList:sender.selectedSegmentIndex];
}

@end
