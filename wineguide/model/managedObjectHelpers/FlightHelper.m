//
//  FlightHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FlightHelper.h"
#import "Flight2+Modify.h"
#import "RestaurantHelper.h"
#import "Restaurant2.h"
#import "WineHelper.h"
#import "Wine2.h"

#define FLIGHT_WINES @"wine"
#define FLIGHT_RESTAURANT @"restaurant"      //////////////////////

@implementation FlightHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Flight2 *flight = (Flight2 *)[self findOrCreateManagedObjectEntityType:FLIGHT_ENTITY usingDictionary:dictionary];
    [flight modifyAttributesWithDictionary:dictionary];
    
    return flight;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Flight2 *flight = (Flight2 *)managedObject;
    
    if([self.relatedObject class] == [Restaurant2 class]){
        flight.restaurant = (Restaurant2 *)self.relatedObject;
        
    } else if ([self.relatedObject class] == [Wine2 class]){
        flight.wines = [self addRelationToSet:flight.wines];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Flight2 *flight = (Flight2 *)managedObject;
    
    // Restaurant
    if(!flight.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        [rh processJSON:dictionary[FLIGHT_RESTAURANT] withRelatedObject:flight];
    }
    
    // Wines
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[FLIGHT_WINES] withRelatedObject:flight];
}














@end
