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
#import "TastingRecordHelper.h"
#import "TastingRecord2.h"

#define RESTAURANT_WINE_UNITS @"wine_units"
#define RESTAURANT_GROUPS @"groups"
#define RESTAURANT_FLIGHTS @"flights"
#define RESTAURANT_TASTING_RECORDS @"tasting_records"  ////////////////////////

@implementation RestaurantHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Restaurant2 *restaurant = (Restaurant2 *)[self findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY usingDictionary:dictionary];
    [restaurant modifyAttributesWithDictionary:dictionary];
    
    return restaurant;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Restaurant2 *restaurant = (Restaurant2 *)managedObject;
    
    if([self.relatedObject class] == [Flight2 class]){
        restaurant.flights = [self addRelationToSet:restaurant.flights];
        
    } else if ([self.relatedObject class] == [Group2 class]){
        restaurant.groups = [self addRelationToSet:restaurant.groups];
        
    } else if ([self.relatedObject class] == [WineUnit2 class]){
        restaurant.wineUnits = [self addRelationToSet:restaurant.wineUnits];
        
    } else if ([self.relatedObject class] == [TastingRecord2 class]){
        restaurant.tastingRecords = [self addRelationToSet:restaurant.tastingRecords];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Restaurant2 *restaurant = (Restaurant2 *)managedObject;
    
    // Flights
    FlightHelper *fh = [[FlightHelper alloc] init];
    [fh processJSON:dictionary[RESTAURANT_FLIGHTS] withRelatedObject:restaurant];
    
    // Groups
    GroupHelper *gh = [[GroupHelper alloc] init];
    [gh processJSON:dictionary[RESTAURANT_GROUPS] withRelatedObject:restaurant];
    
    
    // Tasting Records
    TastingRecordHelper *trh = [[TastingRecordHelper alloc] init];
    [trh processJSON:dictionary[RESTAURANT_TASTING_RECORDS] withRelatedObject:restaurant];
    
    // Wine Units
    WineUnitHelper *wuh = [[WineUnitHelper alloc] init];
    [wuh processJSON:dictionary[RESTAURANT_WINE_UNITS] withRelatedObject:restaurant];
}




















@end
