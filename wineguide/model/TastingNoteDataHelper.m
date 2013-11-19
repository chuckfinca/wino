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

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[TastingNote class]]){
        TastingNote *tastingNote = (TastingNote *)managedObject;
        
        if ([self.relatedObject class] == [Wine class]){
            tastingNote.wines = [self addRelationToSet:tastingNote.wines];
        }
    }
}

@end
