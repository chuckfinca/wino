//
//  TastingNote+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingNote.h"
#import "Wine.h"

@interface TastingNote (CreateAndModify)

+(TastingNote *)tastingNoteForWine:(Wine *)wine foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary;

@end
