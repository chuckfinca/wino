//
//  LocationHelper.h
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationHelper : NSObject

typedef void(^RefreshUserLocationCompletionHandler)(BOOL requestNearbyRestaurants, CLLocation *location);

+(LocationHelper *)sharedInstance;

-(void)refreshUserLocationBecauseUserRequested:(BOOL)userRequested completionHandler:(RefreshUserLocationCompletionHandler)completionHandler;
-(void)requestUserLocationPermission;

@end
