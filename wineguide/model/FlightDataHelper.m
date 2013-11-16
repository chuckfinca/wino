//
//  FlightDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "FlightDataHelper.h"
#import "Flight+CreateAndModify.h"
#import "RestaurantDataHelper.h"
#import "WineUnitDataHelper.h"

#define WINE_UNIT @"WineUnit"
#define RESTAURANT @"Restaurant"

@implementation FlightDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Flight flightFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    //NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    //NSLog(@"set count = %i",[managedObjectSet count]);
    for(Flight *flight in managedObjectSet){
        flight.wineUnits = [self updateRelationshipSet:flight.wineUnits ofEntitiesNamed:WINE_UNIT usingIdentifiersString:flight.wineUnitIdentifiers];
    }
}

-(void)updateManagedObjectsWithEntityName:(NSString *)entityName withDictionariesInArray:(NSArray *)managedObjectDictionariesArray
{
    if([entityName isEqualToString:RESTAURANT]){
        
        // Restaurant
        RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:self.context];
        [rdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
    } else if([entityName isEqualToString:WINE_UNIT]){
        
        // WineUnits
        WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:self.context];
        [wudh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
        
    }
}

@end
