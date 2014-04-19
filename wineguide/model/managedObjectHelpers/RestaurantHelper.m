//
//  RestaurantHelper.m
//  Corkie
//
//  Created by Charles Feinn on 2/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RestaurantHelper.h"
#import "Restaurant2+CreateOrModify.h"
#import "WineUnitHelper.h"
#import "GroupHelper.h"
#import "FlightHelper.h"
#import "Flight2.h"
#import "Group2.h"
#import "WineUnit2.h"

#define RESTAURANT_WINE_UNITS @"wine_units"
#define RESTAURANT_GROUPS @"groups"
#define RESTAURANT_FLIGHTS @"flights"

@implementation RestaurantHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Restaurant2 *restaurant = (Restaurant2 *)[self findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[ID_KEY]];
    [restaurant modifyAttributesWithDictionary:dictionary];
    
    return restaurant;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Restaurant2 class]]){
        Restaurant2 *restaurant = (Restaurant2 *)managedObject;
        
        if([self.relatedObject class] == [Flight2 class]){
            restaurant.flights = [self addRelationToSet:restaurant.flights];
            
        } else if ([self.relatedObject class] == [Group2 class]){
            restaurant.groups = [self addRelationToSet:restaurant.groups];
            
        } else if ([self.relatedObject class] == [WineUnit2 class]){
            restaurant.wineUnits = [self addRelationToSet:restaurant.wineUnits];
            
        }
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Restaurant2 *restaurant = (Restaurant2 *)managedObject;
    
    // flights
    FlightHelper *fh = [[FlightHelper alloc] init];
    [fh createOrUpdateObjectsWithJsonInArray:dictionary[RESTAURANT_FLIGHTS] andRelatedObject:restaurant];
    
    // groups
    GroupHelper *gh = [[GroupHelper alloc] init];
    [gh createOrUpdateObjectsWithJsonInArray:dictionary[RESTAURANT_GROUPS] andRelatedObject:restaurant];
    
    
    // tasting records
    
    
    // wine units
    WineUnitHelper *wuh = [[WineUnitHelper alloc] init];
    [wuh createOrUpdateObjectsWithJsonInArray:dictionary[RESTAURANT_WINE_UNITS] andRelatedObject:restaurant];
}

@end
