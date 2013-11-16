//
//  WineDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDataHelper.h"
#import "Wine+CreateAndModify.h"
#import "BrandDataHelper.h"
#import "TastingNoteDataHelper.h"
#import "WineUnitDataHelper.h"
#import "VarietalDataHelper.h"

#define WINE_UNIT @"WineUnit"
#define TASTING_NOTE @"TastingNote"
#define VARIETAL @"Varietal"
#define BRAND @"Brand"

@implementation WineDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Wine wineFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    //NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    //NSLog(@"set count = %i",[managedObjectSet count]);
    for(Wine *wine in managedObjectSet){
        wine.wineUnits = [self updateRelationshipSet:wine.wineUnits ofEntitiesNamed:WINE_UNIT usingIdentifiersString:wine.wineUnitIdentifiers];
        wine.tastingNotes = [self updateRelationshipSet:wine.tastingNotes ofEntitiesNamed:TASTING_NOTE usingIdentifiersString:wine.tastingNoteIdentifers];
        wine.varietals = [self updateRelationshipSet:wine.varietals ofEntitiesNamed:VARIETAL usingIdentifiersString:wine.varietalIdentifiers];
    }
}

-(void)updateManagedObjectsWithEntityName:(NSString *)entityName withDictionariesInArray:(NSArray *)managedObjectDictionariesArray
{
    if([entityName isEqualToString:BRAND]){
        
        // Brand
        BrandDataHelper *bdh = [[BrandDataHelper alloc] initWithContext:self.context];
        [bdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
        
    } else if([entityName isEqualToString:TASTING_NOTE]){
        
        // TastingNotes
        TastingNoteDataHelper *tndh = [[TastingNoteDataHelper alloc] initWithContext:self.context];
        [tndh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
        
    } else if([entityName isEqualToString:WINE_UNIT]){
        
        // WineUnits
        WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:self.context];
        [wudh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
        
    } else if([entityName isEqualToString:VARIETAL]){
        
        // Varietals
        VarietalDataHelper *vdh = [[VarietalDataHelper alloc] initWithContext:self.context];
        [vdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
    }
}



@end
