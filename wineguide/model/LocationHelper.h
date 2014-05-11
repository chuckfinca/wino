//
//  LocationHelper.h
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define LOCATION_SERVICES_ENABLED @"LocationServicesEnabled"

@interface LocationHelper : NSObject

typedef void(^RefreshUserLocationCompletionHandler)(BOOL requestNearbyRestaurants, CLLocation *location);

+(LocationHelper *)sharedInstance;

-(BOOL)locationServicesEnabled;

-(void)refreshUserLocationBecauseUserRequested:(BOOL)userRequested completionHandler:(RefreshUserLocationCompletionHandler)completionHandler;

@end
