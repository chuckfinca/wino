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

#define WINE_UNIT_RESTAURANT @"restaurant"
#define WINE_UNIT_WINE @"wine"

@implementation WineUnitHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    WineUnit2 *wineUnit = (WineUnit2 *)[self findOrCreateManagedObjectEntityType:WINE_UNIT_ENTITY usingDictionary:dictionary];
    [wineUnit modifyAttributesWithDictionary:dictionary];
    
    return wineUnit;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    WineUnit2 *wineUnit = (WineUnit2 *)managedObject;
    
    if([self.relatedObject class] == [Restaurant2 class]){
        wineUnit.restaurant = (Restaurant2 *)self.relatedObject;
        
    } else if ([self.relatedObject class] == [Wine2 class]){
        wineUnit.wine = (Wine2 *)self.relatedObject;
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    WineUnit2 *wineUnit = (WineUnit2 *)managedObject;
    
    // restaurant
    if(!wineUnit.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        [rh processJSON:dictionary[WINE_UNIT_RESTAURANT] withRelatedObject:wineUnit];
    }
    
    if(!wineUnit.wine){
        WineHelper *wh = [[WineHelper alloc] init];
        [wh processJSON:dictionary[WINE_UNIT_WINE] withRelatedObject:wineUnit];
    }
}

@end
