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
#import "Flight2.h"
#import "Group2.h"
#import "WineUnit2.h"

#define RESTAURANT_WINE_UNITS @"wine_units"
#define RESTAURANT_GROUPS @"groups"
#define RESTAURANT_FLIGHTS @"flights"

@implementation RestaurantHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Restaurant2 *restaurant = (Restaurant2 *)[self findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[SERVER_IDENTIFIER]];
    [restaurant modifyAttributesWithDictionary:dictionary];
    
    
    // wine units
    WineUnitHelper *wuh = [[WineUnitHelper alloc] init];
    [wuh createOrUpdateObjectsWithJsonInArray:dictionary[RESTAURANT_WINE_UNITS]
                              andRelatedObject:restaurant];
    
    // groups
    GroupHelper *gh = [[GroupHelper alloc] init];
    [gh createOrUpdateObjectsWithJsonInArray:dictionary[RESTAURANT_GROUPS]
                             andRelatedObject:restaurant];
    
    // flights
    NSArray *flightDictionaries = dictionary[RESTAURANT_FLIGHTS];
    
    // tasting records
    
    return restaurant;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Restaurant2 class]]){
        Restaurant2 *restaurant = (Restaurant2 *)managedObject;
        
        if([self.relatedObject isKindOfClass:[Flight2 class]]){
            restaurant.flights = [self addRelationToSet:restaurant.flights];
            
        } else if ([self.relatedObject class] == [Group2 class]){
            restaurant.groups = [self addRelationToSet:restaurant.groups];
            
        } else if ([self.relatedObject class] == [WineUnit2 class]){
            restaurant.wineUnits = [self addRelationToSet:restaurant.wineUnits];
            
        }
    }
}

@end
