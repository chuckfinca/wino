//
//  Wine+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine.h"
#import "Restaurant.h"

@interface Wine (CreateAndModify)

+(Wine *)wineFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary;

@end
