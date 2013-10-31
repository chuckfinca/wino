//
//  InitialTabBarController.m
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "InitialTabBarController.h"
#import "DocumentHandler.h"
#import "LocationHelper.h"
#import "RestaurantDataHelper.h"

@interface InitialTabBarController ()

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, readwrite) NSManagedObjectContext *context;
@property (nonatomic) BOOL locationServicesEnabled;

@end

@implementation InitialTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.document){
        [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            self.document = document;
            self.context = document.managedObjectContext;
            
            // Do any additional work now that the document is ready
            [self refresh];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh
{
    NSLog(@"refresh...");
    
    [self checkUserLocation];
    
    if(self.locationServicesEnabled){
        [self updateRestaurants];
    }
    
    // if location services have not been enabled yet
    // user enables location
    
    // at start of app OR after location services have been enabled
    // get users location
    // compare location with stored location
    // if no stored location OR stored location is different than user's location then ask server for restaurants in the users area/city
    // once downloaded store the restaurant data in db
    // use local restaurant info to get/display the restaurants near the user
    
    // when on the list page we should download the wine menus for the closest 3? restaurants
    
    
}

-(void)updateRestaurants
{
    // this will be replaced with a server url when available
    NSURL *dataURL = [[NSBundle mainBundle] URLForResource:@"restaurants" withExtension:@"json"];
    
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:self.context];
    [rdh updatedRestaurantsWithJSONDataFromURL:dataURL];
}

-(void)checkUserLocation
{
    if([LocationHelper locationServicesEnabled]){
        NSLog(@"locationServicesEnabled");
        self.locationServicesEnabled = YES;
    }
}











@end
