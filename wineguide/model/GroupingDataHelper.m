//
//  GroupingDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "GroupingDataHelper.h"
#import "Group+CreateAndModify.h"
#import "RestaurantDataHelper.h"

#define WINE_UNIT @"WineUnit"
#define GROUP @"Group"

@implementation GroupingDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Group groupFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    NSLog(@"set count = %i",[managedObjectSet count]);
    for(Group *group in managedObjectSet){
        group.wineUnits = [self updateRelationshipSet:group.wineUnits ofEntitiesNamed:WINE_UNIT usingIdentifiersString:group.wineUnitIdentifiers];
    }
    if(self.restaurant) {
        NSLog(@"inside");
        NSLog(@"groups = %@",self.restaurant.groups);
        RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:self.context];
        [rdh updateRelationshipSet:self.restaurant.groups ofEntitiesNamed:GROUP usingIdentifiersString:self.restaurant.groupIdentifiers];
    }
}

@end
