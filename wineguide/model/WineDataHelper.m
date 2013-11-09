//
//  WineDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDataHelper.h"
#import "Wine+CreateAndModify.h"

@implementation WineDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Wine wineFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Wine *wine in managedObjectSet){
        wine.groupings = [self updateManagedObject:wine relationshipSet:wine.groupings withIdentifiersString:wine.groupIdentifiers];
        wine.flights = [self updateManagedObject:wine relationshipSet:wine.flights withIdentifiersString:wine.flightIdentifiers];
        wine.wineUnits = [self updateManagedObject:wine relationshipSet:wine.wineUnits withIdentifiersString:wine.wineUnitIdentifiers];
        wine.tastingNotes = [self updateManagedObject:wine relationshipSet:wine.tastingNotes withIdentifiersString:wine.tastingNoteIdentifers];
        wine.varietals   = [self updateManagedObject:wine relationshipSet:wine.varietals withIdentifiersString:wine.varietalIdentifiers];
    }
}

@end
