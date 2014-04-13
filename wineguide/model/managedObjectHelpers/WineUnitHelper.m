//
//  WineUnitHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineUnitHelper.h"
#import "WineUnit2+CreateOrModify.h"
#import "WineUnit.h"
#import "RestaurantHelper.h"

#define WINE_UNIT_ENTITY @"WineUnit2"

#define SERVER_IDENTIFIER @"id"

#define WINE_ID @"wine_id"
#define RESTAURANT_ID @"restaurant_id"

@implementation WineUnitHelper

-(NSManagedObject *)findOrCreateObjectWithDictionary:(NSDictionary *)dictionary
{
    WineUnit2 *wineUnit = (WineUnit2 *)[self findOrCreateManagedObjectEntityType:WINE_UNIT_ENTITY andIdentifier:dictionary[SERVER_IDENTIFIER]];
    [wineUnit modifyAttributesWithDictionary:dictionary];
    
    // wine
    NSNumber *wineIdentifier = dictionary[WINE_ID];
    
    // restaurant
    if(self.relatedRestaurant){
        wineUnit.restaurant = self.relatedRestaurant;
    } else {
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        wineUnit.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ID andIdentifier:dictionary[RESTAURANT_ID]];
    }
    
    return wineUnit;
}

@end
