//
//  ServerCaller.h
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerCommunicator : NSObject

-(void)getRestaurantsNearLatitude:(double)latitude longitude:(double)longitude;
-(void)getAllWinesFromRestaurantIdentifier:(NSInteger)restaurantIdentifier;

@end
