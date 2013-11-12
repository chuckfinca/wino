//
//  GroupingDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "GroupingDataHelper.h"
#import "Grouping+CreateAndModify.h"

#define WINE_UNIT @"WineUnit"

@implementation GroupingDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Grouping groupFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Grouping *grouping in managedObjectSet){
        grouping.wineUnits = [self updateRelationshipSet:grouping.wineUnits ofEntitiesNamed:WINE_UNIT withIdentifiersString:grouping.wineUnitIdentifiers];
    }
}

@end
