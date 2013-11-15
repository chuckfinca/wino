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

#define GROUPING @"Group"
#define FLIGHT @"Flight"

@implementation WineUnitDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [WineUnit wineUnitFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    NSLog(@"set count = %i",[managedObjectSet count]);
    for(WineUnit *wu in managedObjectSet){
        wu.groups = [self updateRelationshipSet:wu.groups ofEntitiesNamed:GROUPING usingIdentifiersString:wu.groupIdentifiers];
        wu.flights = [self updateRelationshipSet:wu.flights ofEntitiesNamed:FLIGHT usingIdentifiersString:wu.flightIdentifiers];
    }
}

@end
