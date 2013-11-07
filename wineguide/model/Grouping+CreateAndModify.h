//
//  Grouping+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/4/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Grouping.h"

@interface Grouping (CreateAndModify)

+(Grouping *)groupFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary;

@end
