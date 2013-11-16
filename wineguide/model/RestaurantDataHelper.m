//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDataHelper.h"
#import "Restaurant+CreateAndModify.h"
#import "GroupingDataHelper.h"
#import "FlightDataHelper.h"

#define GROUP @"Group"
#define FLIGHT @"Flight"


@implementation RestaurantDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Restaurant restaurantFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    //NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    //NSLog(@"set count = %i",[managedObjectSet count]);
    for(Restaurant *r in managedObjectSet){
        
        // if i can add additional identifiers to the String needed for the below method then all the relationships should be created...
        
        r.groups = [self updateRelationshipSet:r.groups ofEntitiesNamed:GROUP usingIdentifiersString:r.groupIdentifiers];
        r.flights = [self updateRelationshipSet:r.flights ofEntitiesNamed:FLIGHT usingIdentifiersString:r.flightIdentifiers];
    }
}


-(void)updateManagedObjectsWithEntityName:(NSString *)entityName withDictionariesInArray:(NSArray *)managedObjectDictionariesArray
{
    NSLog(@"updateManagedObjectsWithEntityName:withDictionariesInArray:...");
    NSLog(@"entityName = %@", entityName);
    
    if([entityName isEqualToString:GROUP]){
        NSLog(@"aaa");
        // Groupings
        GroupingDataHelper *gdh = [[GroupingDataHelper alloc] initWithContext:self.context];
        [gdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
        
    } else if([entityName isEqualToString:FLIGHT]){
        
        NSLog(@"bbb");
        // Flights
        FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:self.context];
        [fdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
    }
}


@end
