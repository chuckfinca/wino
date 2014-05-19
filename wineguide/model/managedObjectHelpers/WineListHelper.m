//
//  WineListHelper.m
//  Corkie
//
//  Created by Charles Feinn on 5/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineListHelper.h"
#import "WineList+Modify.h"
#import "Flight2.h"
#import "FlightHelper.h"
#import "Group2.h"
#import "GroupHelper.h"
#import "WineUnit2.h"
#import "WineUnitHelper.h"
#import "Restaurant2.h"
#import "RestaurantHelper.h"
#import "Wine2.h"
#import "WineHelper.h"


#define WINE_LIST_ENTITY @"WineList"

#define WINE_LIST_FLIGHTS @"flights"
#define WINE_LIST_GROUPS @"groups"
#define WINE_LIST_WINE_UNITS @"wine_units"
#define WINE_LIST_RESTAURANT @"restaurant"
#define WINE_LIST_WINES @"wines"

@implementation WineListHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    WineList *wineList = (WineList *)[self findOrCreateManagedObjectEntityType:WINE_LIST_ENTITY usingDictionary:dictionary];
    [wineList modifyAttributesWithDictionary:dictionary];
    
    return wineList;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    WineList *wineList = (WineList *)managedObject;
    
    if([self.relatedObject class] == [Flight2 class]){
        wineList.flights = [self addRelationToSet:wineList.flights];
        
    } else if ([self.relatedObject class] == [Group2 class]){
        wineList.groups = [self addRelationToSet:wineList.groups];
        
    } else if ([self.relatedObject class] == [WineUnit2 class]){
        wineList.wineUnits = [self addRelationToSet:wineList.wineUnits];
        
    } else if ([self.relatedObject class] == [Wine2 class]){
        wineList.wines = [self addRelationToSet:wineList.wines];
        
    } else if ([self.relatedObject class] == [Restaurant2 class]){
        wineList.restaurant = (Restaurant2 *)self.relatedObject;
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    WineList *wineList = (WineList *)managedObject;
    
    // Flights
    FlightHelper *fh = [[FlightHelper alloc] init];
    [fh processJSON:dictionary[WINE_LIST_FLIGHTS] withRelatedObject:wineList];
    
    // Groups
    GroupHelper *gh = [[GroupHelper alloc] init];
    [gh processJSON:dictionary[WINE_LIST_GROUPS] withRelatedObject:wineList];
    
    
    // Tasting Records
    WineHelper *wh = [[WineHelper alloc] init];
    [wh processJSON:dictionary[WINE_LIST_WINES] withRelatedObject:wineList];
    
    // Wine Units
    WineUnitHelper *wuh = [[WineUnitHelper alloc] init];
    [wuh processJSON:dictionary[WINE_LIST_WINE_UNITS] withRelatedObject:wineList];
    
    // Restaurant
    RestaurantHelper *rh = [[RestaurantHelper alloc] init];
    [rh processJSON:dictionary[WINE_LIST_RESTAURANT] withRelatedObject:wineList];
}






@end
