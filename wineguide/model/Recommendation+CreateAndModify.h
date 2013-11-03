//
//  Recommendation+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/3/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Recommendation.h"

@interface Recommendation (CreateAndModify)

+(Recommendation *)recommendationWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
