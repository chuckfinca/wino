//
//  TastingNote+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingNote.h"

@interface TastingNote (CreateAndModify)

+(TastingNote *)tastingNoteWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
