//
//  LocationHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "LocationHelper.h"
#import <MapKit/MapKit.h>

static LocationHelper *sharedInstance;

@interface LocationHelper () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

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
    BOOL locationServicesEnabled = [CLLocationManager locationServicesEnabled];
    
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
            break;
            
        default:
            break;
    }
    
    return locationServicesEnabled;
}

-(void)getUserLocation
{
    
}

-(void)requestUserLocationPermission
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"locationManager didUpdateLocations...");
    NSLog(@"%i locations",[locations count]);
    
    CLLocation *location = [locations firstObject];
    NSLog(@"Lat = %f",location.coordinate.latitude);
    NSLog(@"Long = %f",location.coordinate.longitude);
    
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager didFailWithError %@",error.localizedDescription);
}




@end
