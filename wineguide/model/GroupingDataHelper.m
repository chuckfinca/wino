//
//  GroupingDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "GroupingDataHelper.h"
#import "Group+CreateAndModify.h"

#define WINE_UNIT @"WineUnit"

@implementation GroupingDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Group groupFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Group *group in managedObjectSet){
        group.wineUnits = [self updateRelationshipSet:group.wineUnits ofEntitiesNamed:WINE_UNIT usingIdentifiersString:group.wineUnitIdentifiers];
    }
}

@end
