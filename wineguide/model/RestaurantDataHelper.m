//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDataHelper.h"
#import "Restaurant+CreateAndModify.h"
#import "Grouping.h"

#define GROUPING @"Grouping"
#define FLIGHT @"Flight"
#define WINE_UNIT @"WineUnit"


@implementation RestaurantDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Restaurant restaurantFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Restaurant *r in managedObjectSet){
        NSLog(@"groupings -------------------------");
        NSLog(@"groupings = %@",r.groupings);
        NSLog(@"groupIdentifiers = %@",r.groupIdentifiers);
        r.groupings = [self updateManagedObject:r relationshipSet:r.groupings withIdentifiersString:r.groupIdentifiers];
        NSLog(@"flights -------------------------");
        NSLog(@"flights = %@",r.flights);
        NSLog(@"flightIdentifiers = %@",r.flightIdentifiers);
        r.flights = [self updateManagedObject:r relationshipSet:r.flights withIdentifiersString:r.flightIdentifiers];
        NSLog(@"wineUnits -------------------------");
        NSLog(@"wineUnits = %@",r.wineUnits);
        NSLog(@"wineUnitIdentifiers = %@",r.wineUnitIdentifiers);
        r.wineUnits = [self updateManagedObject:r relationshipSet:r.wineUnits withIdentifiersString:r.wineUnitIdentifiers];
    }
}




@end
