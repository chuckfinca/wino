//
//  TastingNote+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingNote+CreateAndModify.h"
#import "ManagedObjectHandler.h"

@implementation TastingNote (CreateAndModify)


#define ENTITY_NAME @"TastingNote"
#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define IDENTIFIER @"identifier"
#define TYPE @"type"

+(TastingNote *)tastingNoteWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    TastingNote *tastingNote = nil;
    
    tastingNote = (TastingNote *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:ENTITY_NAME andNameAttribute:name inContext:context];
    
    if(tastingNote){
        tastingNote.name = name;
        tastingNote.markForDeletion = @NO;
        tastingNote.version = 0;
        tastingNote.type = nil;
    }
    
    return tastingNote;
}

@end
