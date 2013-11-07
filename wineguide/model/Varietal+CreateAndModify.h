//
//  Varietal+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Varietal.h"
#import "Wine.h"

@interface Varietal (CreateAndModify)

+(Varietal *)varietalForWine:(Wine *)wine foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary;

@end
