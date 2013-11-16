//
//  TastingNoteDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingNoteDataHelper.h"
#import "TastingNote+CreateAndModify.h"
#import "WineDataHelper.h"

#define WINE @"Wine"

@implementation TastingNoteDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [TastingNote tastingNoteFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(TastingNote *tastingNote in managedObjectSet){
        tastingNote.wines = [self updateRelationshipSet:tastingNote.wines ofEntitiesNamed:WINE usingIdentifiersString:tastingNote.wineIdentifiers];
    }
}


-(void)updateManagedObjectsWithEntityName:(NSString *)entityName withDictionariesInArray:(NSArray *)managedObjectDictionariesArray
{
    if([entityName isEqualToString:WINE]){
        
        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:self.context];
        [wdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
    }
}

@end
