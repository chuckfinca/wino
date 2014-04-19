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

#define FLIGHT_WINES @"flight_wine"

@implementation FlightHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Flight2 *flight = (Flight2 *)[self findOrCreateManagedObjectEntityType:GROUP_ENTITY andIdentifier:dictionary[ID_KEY]];
    [flight modifyAttributesWithDictionary:dictionary];
    
    return flight;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Flight2 class]]){
        Flight2 *flight = (Flight2 *)managedObject;
        
        if([self.relatedObject class] == [Restaurant2 class]){
            flight.restaurant = (Restaurant2 *)self.relatedObject;
            
        } else if ([self.relatedObject class] == [Wine2 class]){
            flight.wines = [self addRelationToSet:flight.wines];
        }
    }
}

-(void)addAdditionalRelativesToManagedObject:(NSManagedObject *)managedObject fromDictionary:(NSDictionary *)dictionary
{
    Flight2 *flight = (Flight2 *)managedObject;
    
    // Restaurant
    if(!flight.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        flight.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[RESTAURANT_ID]];
    }
    
    // Wine
    NSArray *winesArray = dictionary[FLIGHT_WINES];
    WineHelper *wu = [[WineHelper alloc] init];
    [wu createOrUpdateObjectsWithJsonInArray:winesArray andRelatedObject:flight];
}














@end
