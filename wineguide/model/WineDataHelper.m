//
//  WineDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDataHelper.h"
#import "Wine+CreateAndModify.h"

#define WINE_UNIT @"WineUnit"
#define TASTING_NOTE @"TastingNote"
#define VARIETAL @"Varietal"

@implementation WineDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Wine wineFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    NSLog(@"set count = %i",[managedObjectSet count]);
    for(Wine *wine in managedObjectSet){
        wine.wineUnits = [self updateRelationshipSet:wine.wineUnits ofEntitiesNamed:WINE_UNIT usingIdentifiersString:wine.wineUnitIdentifiers];
        wine.tastingNotes = [self updateRelationshipSet:wine.tastingNotes ofEntitiesNamed:TASTING_NOTE usingIdentifiersString:wine.tastingNoteIdentifers];
        wine.varietals = [self updateRelationshipSet:wine.varietals ofEntitiesNamed:VARIETAL usingIdentifiersString:wine.varietalIdentifiers];
    }
}

@end
