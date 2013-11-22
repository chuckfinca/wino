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
#import "TastingNoteDataHelper.h"
#import "VarietalDataHelper.h"
#import "ColorSchemer.h"

@interface InitialTabBarController () <UIAlertViewDelegate>

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
    
    [self setupAppColorScheme];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Document Ready" object:nil];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupAppColorScheme
{
    self.view.tintColor = [ColorSchemer sharedInstance].baseColor;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)refresh
{
    NSLog(@"refresh...");
    [self updateTastingNotes];
    [self updateVarietals];
    
    [self checkUserLocation];
    if(self.locationServicesEnabled){
        [self updateRestaurants];
    }
}

-(void)checkUserLocation
{
    if(!self.locationServicesEnabled){
        NSLog(@"locationServicesEnabled");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable location services?" message:@"Wine Guide would like to use your location." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tintColor = [ColorSchemer sharedInstance].textLink;
        [alert show];
    }
}


#pragma mark - Update Core Data


-(void)updateTastingNotes
{
    NSURL *tastingNoteJSONUrl = [[NSBundle mainBundle] URLForResource:@"tastingnotes" withExtension:@"json"];
    TastingNoteDataHelper *tndh = [[TastingNoteDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [tndh updateCoreDataWithJSONFromURL:tastingNoteJSONUrl];
}

-(void)updateVarietals
{
    NSURL *varietalsJSONUrl = [[NSBundle mainBundle] URLForResource:@"varietals" withExtension:@"json"];
    VarietalDataHelper *vdh = [[VarietalDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [vdh updateCoreDataWithJSONFromURL:varietalsJSONUrl];
}


-(void)updateRestaurants
{
    // this will be replaced with a server url when available
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"restaurants" withExtension:@"json"];
    
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [rdh updateCoreDataWithJSONFromURL:url];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        self.locationServicesEnabled = [LocationHelper locationServicesEnabled];
        [self updateRestaurants];
    }
}







@end
