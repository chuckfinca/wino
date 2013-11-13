//
//  Group+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/12/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Group.h"

@interface Group (CreateAndModify)

+(Group *)groupFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary;

@end
