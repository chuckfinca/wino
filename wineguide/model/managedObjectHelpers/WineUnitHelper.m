//
//  WineUnitHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineUnitHelper.h"
#import "WineUnit2+CreateOrModify.h"
#import "RestaurantHelper.h"
#import "Restaurant2.h"
#import "WineHelper.h"
#import "Wine2.h"


#define WINE_ID @"wine_id"
#define RESTAURANT_ID @"restaurant_id"

@implementation WineUnitHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    WineUnit2 *wineUnit = (WineUnit2 *)[self findOrCreateManagedObjectEntityType:WINE_UNIT_ENTITY andIdentifier:dictionary[SERVER_IDENTIFIER]];
    [wineUnit modifyAttributesWithDictionary:dictionary];
    
    
    // restaurant
    if(!wineUnit.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        wineUnit.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[RESTAURANT_ID]];
    }
    
    
    // wine
    
    return wineUnit;
}

@end
