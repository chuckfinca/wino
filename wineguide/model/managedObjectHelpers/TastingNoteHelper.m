//
//  TastingNoteHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingNoteHelper.h"
#import "TastingNote2+Modify.h"
#import "WineHelper.h"
#import "Wine2.h"

#define TASTING_NOTE_WINES @"wines"

@implementation TastingNoteHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    TastingNote2 *tastingNote = (TastingNote2 *)[self findOrCreateManagedObjectEntityType:TASTING_NOTE_ENTITY usingDictionary:dictionary];
    [tastingNote modifyAttributesWithDictionary:dictionary];
    
    return tastingNote;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    TastingNote2 *tastingNote = (TastingNote2 *)managedObject;
    
    if ([self.relatedObject class] == [Wine2 class]){
        tastingNote.wines = [self addRelationToSet:tastingNote.wines];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    TastingNote2 *tastingNote = (TastingNote2 *)managedObject;
    
    // Wine
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[TASTING_NOTE_WINES] withRelatedObject:tastingNote];
}





@end
