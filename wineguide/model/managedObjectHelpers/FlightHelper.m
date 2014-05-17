//
//  FlightHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FlightHelper.h"
#import "Flight2+Modify.h"
#import "WineList.h"
#import "WineListHelper.h"
#import "WineHelper.h"
#import "Wine2.h"

#define FLIGHT_WINES @"wine"
#define FLIGHT_WINE_LIST @"wine_list"

@implementation FlightHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Flight2 *flight = (Flight2 *)[self findOrCreateManagedObjectEntityType:FLIGHT_ENTITY usingDictionary:dictionary];
    [flight modifyAttributesWithDictionary:dictionary];
    
    return flight;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Flight2 *flight = (Flight2 *)managedObject;
    
    if([self.relatedObject class] == [WineList class]){
        flight.wineList = (WineList *)self.relatedObject;
        
    } else if ([self.relatedObject class] == [Wine2 class]){
        flight.wines = [self addRelationToSet:flight.wines];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Flight2 *flight = (Flight2 *)managedObject;
    
    // Restaurant
    if(!flight.wineList){
        WineListHelper *wlh = [[WineListHelper alloc] init];
        [wlh processJSON:dictionary[FLIGHT_WINE_LIST] withRelatedObject:flight];
    }
    
    // Wines
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[FLIGHT_WINES] withRelatedObject:flight];
}














@end
