//
//  TastingNoteDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingNoteDataHelper.h"
#import "TastingNote+CreateAndModify.h"

#define WINE @"Wine"

@implementation TastingNoteDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [TastingNote tastingNoteFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    NSLog(@"set count = %i",[managedObjectSet count]);
    for(TastingNote *tastingNote in managedObjectSet){
        tastingNote.wines = [self updateRelationshipSet:tastingNote.wines ofEntitiesNamed:WINE usingIdentifiersString:tastingNote.wineIdentifiers];
    }
}

@end
