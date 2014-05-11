//
//  LocationHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "LocationHelper.h"

#define RE_REQUEST_NEARYBY_RESTAURANTS_DISTANCE_THRESHOLD 300 // meters

static LocationHelper *sharedInstance;


@interface LocationHelper () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastLocationSentToServer;
@property (nonatomic, strong) RefreshUserLocationCompletionHandler refreshUserLocationCompletionHandler;

@end

@implementation LocationHelper


+(LocationHelper *)sharedInstance
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Getters & setters

-(CLLocationManager *)locationManager
{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 2000;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

-(BOOL)locationServicesEnabled
{
    BOOL locationServicesEnabled = NO;
    
    // check to see if the user has given us access to gps
    NSInteger locationAuthorizationStatus = [CLLocationManager authorizationStatus];
    
    switch (locationAuthorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            locationServicesEnabled = YES;
            break;
            
        default:
            break;
    }
    
    return locationServicesEnabled;
}

-(void)refreshUserLocationBecauseUserRequested:(BOOL)userRequested completionHandler:(RefreshUserLocationCompletionHandler)completionHandler
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || userRequested){
        [self.locationManager startUpdatingLocation];
        self.refreshUserLocationCompletionHandler = completionHandler;
    } else {
        completionHandler(NO,nil);
    }
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    
    double distanceTraveled = [location distanceFromLocation:self.lastLocationSentToServer];
    
    NSLog(@"Lat = %f",location.coordinate.latitude);
    NSLog(@"Long = %f",location.coordinate.longitude);
    
    if(!self.lastLocationSentToServer || distanceTraveled > RE_REQUEST_NEARYBY_RESTAURANTS_DISTANCE_THRESHOLD){
        
        self.refreshUserLocationCompletionHandler(YES,location);
        self.lastLocationSentToServer = location;
    } else {
        self.refreshUserLocationCompletionHandler(NO,nil);
    }
    
    [manager stopUpdatingLocation];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOCATION_SERVICES_ENABLED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager didFailWithError %@",error.localizedDescription);
}




@end
