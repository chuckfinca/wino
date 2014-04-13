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

#define RESTAURANT_ENTITY @"Restaurant2"
#define WINE_UNIT_ENTITY @"WineUnit2"

#define SERVER_IDENTIFIER @"id"
#define RESTAURANT_WINE_UNITS @"wine_units"
#define RESTAURANT_GROUPS @"groups"
#define RESTAURANT_FLIGHTS @"flights"

@implementation RestaurantHelper

-(NSManagedObject *)findOrCreateObjectWithDictionary:(NSDictionary *)dictionary
{
    Restaurant2 *restaurant = (Restaurant2 *)[self findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[SERVER_IDENTIFIER]];
    [restaurant modifyAttributesWithDictionary:dictionary];
    
    // wine units
    NSArray *wineUnitDictionariesArray = dictionary[RESTAURANT_WINE_UNITS];
    WineUnitHelper *wuh = [[WineUnitHelper alloc] init];
    wuh.relatedRestaurant = restaurant;
    [wuh createAndUpdateObjectsWithJsonInArray:wineUnitDictionariesArray];
    
    // groups
    NSArray *groupDictionariesArray = dictionary[RESTAURANT_GROUPS];
    GroupHelper *gh = [[GroupHelper alloc] init];
    gh.relatedRestaurant = restaurant;
    [gh createAndUpdateObjectsWithJsonInArray:groupDictionariesArray];
    
    // flights
    NSArray *flightDictionaries = dictionary[RESTAURANT_FLIGHTS];
    
    // tasting records
    
    return restaurant;
}

@end
