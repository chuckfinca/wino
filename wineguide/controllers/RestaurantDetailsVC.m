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
#import "FontThemer.h"
#import "RoundedRectButton.h"

#define METERS_PER_MILE 1609.344
#define MAP_FRAME_OFFSET 200

@interface RestaurantDetailsVC () <NSFetchedResultsControllerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet RestaurantDetailsVHTV *restaurantDetailsVHTV;
@property (strong, nonatomic) IBOutletCollection(RoundedRectButton) NSArray *buttonArray;
@property (nonatomic, strong) Restaurant2 *restaurant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRestaurantInfoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantInfoVHTVToButtonArrayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonArrayToBottomConstraint;

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
    [self setupButtonArray];
    [self setViewHeight];
    [self setupMap];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customWhite;
}

#pragma mark - Setup

-(void)setupWithRestaurant:(Restaurant2 *)restaurant
{
    self.restaurant = restaurant;
}

-(void)setupButtonArray
{
    for(RoundedRectButton *button in self.buttonArray){
        
        NSString *buttonText;
        switch (button.tag) {
            case 0:
                buttonText = @"Popular";
                break;
            case 1:
                buttonText = @"Friends";
                break;
            case 2:
                buttonText = @"Experts";
                break;
            default:
                break;
        }
        NSAttributedString *attributedButtonText = [[NSAttributedString alloc] initWithString:buttonText attributes:[FontThemer sharedInstance].primarySubHeadlineTextAttributes];
        [button setAttributedTitle:attributedButtonText forState:UIControlStateNormal];
        
        NSAttributedString *attributedSelectedButtonText = [[NSAttributedString alloc] initWithString:buttonText attributes:[FontThemer sharedInstance].whiteSubHeadlineTextAttributes];
        [button setAttributedTitle:attributedSelectedButtonText forState:UIControlStateSelected];
        
        [button setFillColor:[ColorSchemer sharedInstance].customBackgroundColor strokeColor:[ColorSchemer sharedInstance].baseColor];
    }
}

-(void)setupMap
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, -MAP_FRAME_OFFSET, self.view.frame.size.width, self.view.frame.size.height+MAP_FRAME_OFFSET)];
    mapView.userInteractionEnabled = NO;
    
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
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitued+0.0019, longitude-0.002), 0, 0.5*METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:YES];
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    [pointAnnotation setCoordinate:restaurantLocation];
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] init];
    pin.pinColor = MKPinAnnotationColorPurple;
    pin.annotation = pointAnnotation;
    
    [mapView addAnnotation:pointAnnotation];
}


-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToRestaurantInfoConstraint.constant;
    height += [self.restaurantDetailsVHTV height];
    height += self.restaurantInfoVHTVToButtonArrayConstraint.constant;
    
    UIButton *button = [self.buttonArray firstObject];
    height += button.bounds.size.height;
    height += self.buttonArrayToBottomConstraint.constant;
    
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
}



#pragma mark - Target action

- (IBAction)filterList:(UIButton *)sender
{
    NSLog(@"tag = %ld",(long)sender.tag);
    // redraw the button in the correct state
    for(RoundedRectButton *button in self.buttonArray){
        NSDictionary *textAttributes;
        if(sender.tag == button.tag){
            button.selected = !button.selected;
            if(button.selected == YES){
                [button setFillColor:[ColorSchemer sharedInstance].baseColor strokeColor:nil];
                textAttributes = [FontThemer sharedInstance].whiteSubHeadlineTextAttributes;
                [self.delegate filterByGroup:nil];
            } else {
                [button setFillColor:[ColorSchemer sharedInstance].customBackgroundColor strokeColor:[ColorSchemer sharedInstance].baseColor];
                textAttributes = [FontThemer sharedInstance].primarySubHeadlineTextAttributes;
                [self.delegate removeFilterForGroup:nil];
            }
        }
    }
    // reload the list with the new filter
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
