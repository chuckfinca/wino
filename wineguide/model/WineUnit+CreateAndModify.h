//
//  WineUnit+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/5/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineUnit.h"

@interface WineUnit (CreateAndModify)

+(WineUnit *)wineUnitFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary;

@end
