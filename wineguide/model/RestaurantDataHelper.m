//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDataHelper.h"
#import "Restaurant+CreateAndModify.h"

#define GROUPING @"Grouping"
#define FLIGHT @"Flight"


@implementation RestaurantDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Restaurant restaurantFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Restaurant *r in managedObjectSet){
        //NSLog(@"groupings = %@",r.groupings);
        //NSLog(@"groupIdentifiers = %@",r.groupIdentifiers);
        r.groups = [self updateRelationshipSet:r.groups ofEntitiesNamed:GROUPING withIdentifiersString:r.groupIdentifiers];
        //NSLog(@"flightIdentifiers = %@",r.flightIdentifiers);
        r.flights = [self updateRelationshipSet:r.flights ofEntitiesNamed:FLIGHT withIdentifiersString:r.flightIdentifiers];
    }
}




@end
