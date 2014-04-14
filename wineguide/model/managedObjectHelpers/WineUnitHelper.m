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

@implementation WineUnitHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    WineUnit2 *wineUnit = (WineUnit2 *)[self findOrCreateManagedObjectEntityType:WINE_UNIT_ENTITY andIdentifier:dictionary[ID_KEY]];
    [wineUnit modifyAttributesWithDictionary:dictionary];
    
    return wineUnit;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[WineUnit2 class]]){
        WineUnit2 *wineUnit = (WineUnit2 *)managedObject;
        
        if([self.relatedObject class] == [Restaurant2 class]){
            wineUnit.restaurant = (Restaurant2 *)self.relatedObject;
            
        } else if ([self.relatedObject class] == [Wine2 class]){
            wineUnit.wine = (Wine2 *)self.relatedObject;
        }
    }
}

-(void)addAdditionalRelativesToManagedObject:(NSManagedObject *)managedObject fromDictionary:(NSDictionary *)dictionary
{
    WineUnit2 *wineUnit = (WineUnit2 *)managedObject;
    
    // restaurant
    if(!wineUnit.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        wineUnit.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[RESTAURANT_ID]];
    }
    
    if(!wineUnit.wine){
        WineHelper *wh = [[WineHelper alloc] init];
        wineUnit.wine = (Wine2 *)[wh findOrCreateManagedObjectEntityType:WINE_ENTITY andIdentifier:dictionary[WINE_ID]];
    }
}

@end
