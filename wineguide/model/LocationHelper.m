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

@implementation LocationHelper

+(LocationHelper *)sharedInstance
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
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
            locationAuthorizationStatus = YES;
            break;
            
        default:
            break;
    }
    
    return locationServicesEnabled;
}

-(void)getUserLocation
{
    
}

@end
