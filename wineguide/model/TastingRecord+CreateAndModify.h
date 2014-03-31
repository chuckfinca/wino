//
//  TastingRecord+CreateAndModify.h
//  Corkie
//
//  Created by Charles Feinn on 1/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecord.h"

@interface TastingRecord (CreateAndModify)

+(TastingRecord *)foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary;

@end
