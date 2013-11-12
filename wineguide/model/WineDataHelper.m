//
//  WineDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDataHelper.h"
#import "Wine+CreateAndModify.h"

#define GROUPING @"Grouping"
#define FLIGHT @"Flight"
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
    for(Wine *wine in managedObjectSet){
        wine.wineUnits = [self updateRelationshipSet:wine.wineUnits ofEntitiesNamed:WINE_UNIT withIdentifiersString:wine.wineUnitIdentifiers];
        wine.tastingNotes = [self updateRelationshipSet:wine.tastingNotes ofEntitiesNamed:TASTING_NOTE withIdentifiersString:wine.tastingNoteIdentifers];
        wine.varietals = [self updateRelationshipSet:wine.varietals ofEntitiesNamed:VARIETAL withIdentifiersString:wine.varietalIdentifiers];
    }
}

@end
