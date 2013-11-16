//
//  WineUnitDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineUnitDataHelper.h"
#import "WineUnit+CreateAndModify.h"
#import "Group.h"
#import "Flight.h"
#import "GroupingDataHelper.h"
#import "FlightDataHelper.h"
#import "WineDataHelper.h"

#define GROUP @"Group"
#define FLIGHT @"Flight"
#define WINE @"Wine"

@implementation WineUnitDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [WineUnit wineUnitFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(WineUnit *wu in managedObjectSet){
        wu.groups = [self updateRelationshipSet:wu.groups ofEntitiesNamed:GROUP usingIdentifiersString:wu.groupIdentifiers];
        wu.flights = [self updateRelationshipSet:wu.flights ofEntitiesNamed:FLIGHT usingIdentifiersString:wu.flightIdentifiers];
    }
}



-(void)updateManagedObjectsWithEntityName:(NSString *)entityName withDictionariesInArray:(NSArray *)managedObjectDictionariesArray
{
    if([entityName isEqualToString:GROUP]){
        
        // Groupings
        GroupingDataHelper *gdh = [[GroupingDataHelper alloc] initWithContext:self.context];
        [gdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
        
    } else if([entityName isEqualToString:FLIGHT]){
        
        // Flights
        FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:self.context];
        [fdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
        
    } else if([entityName isEqualToString:WINE]){
        
        // Wine
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:self.context];
        [wdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
    }
}




@end
