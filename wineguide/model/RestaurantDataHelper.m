//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDataHelper.h"
#import "Restaurant+CreateAndModify.h"

#define GROUPING @"Group"
#define FLIGHT @"Flight"


@implementation RestaurantDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Restaurant restaurantFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    NSLog(@"set count = %i",[managedObjectSet count]);
    for(Restaurant *r in managedObjectSet){
        r.groups = [self updateRelationshipSet:r.groups ofEntitiesNamed:GROUPING usingIdentifiersString:r.groupIdentifiers];
        r.flights = [self updateRelationshipSet:r.flights ofEntitiesNamed:FLIGHT usingIdentifiersString:r.flightIdentifiers];
    }
}




@end
