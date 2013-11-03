//
//  Recommendation+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/3/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Recommendation+CreateAndModify.h"
#import "ManagedObjectHandler.h"

#define ENTITY_NAME @"Recommendation"
#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define IDENTIFIER @"identifier"

@implementation Recommendation (CreateAndModify)

+(Recommendation *)recommendationWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    Recommendation *recommendation = nil;
    
    recommendation = (Recommendation *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:ENTITY_NAME andNameAttribute:name inContext:context];
    
    if(recommendation){
        recommendation.name = name;
        recommendation.markForDeletion = @NO;
        recommendation.version = 0;
    }
    
    return recommendation;
}
@end
