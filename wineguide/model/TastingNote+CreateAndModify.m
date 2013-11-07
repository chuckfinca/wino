//
//  TastingNote+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingNote+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"

@implementation TastingNote (CreateAndModify)

#define TASTING_NOTE_ENTITY @"TastingNote"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define TASTING_STAGE @"tastingStage"
#define VERSION @"version"

+(TastingNote *)tastingNoteForWine:(Wine *)wine foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    TastingNote *tastingNote = nil;
    
    tastingNote = (TastingNote *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:TASTING_NOTE_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(tastingNote){
        
        // ATTRIBUTES
        
        tastingNote.about = [dictionary objectForKeyNotNull:ABOUT];
        tastingNote.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
        // tastingNote.lastAccessed
        tastingNote.markForDeletion = [dictionary objectForKeyNotNull:MARK_FOR_DELETION];
        tastingNote.name = [dictionary objectForKeyNotNull:NAME];
        tastingNote.tastingStage = [dictionary objectForKeyNotNull:TASTING_STAGE]; // appearance, in glass, in mouth, finish
        tastingNote.version = [dictionary objectForKeyNotNull:VERSION];
        
        
        // RELATIONSHIPS
        
        NSMutableSet *wines = [tastingNote.wines mutableCopy];
        if(![wines containsObject:wine]) [wines addObject:wine];
        tastingNote.wines = wines;
    }
    
    return tastingNote;
}

@end
