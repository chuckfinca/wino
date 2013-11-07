//
//  Varietal+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Varietal+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"

#define VARIETAL_ENTITY @"Varietal"

#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define NAME @"name"
#define IDENTIFIER @"identifier"

@implementation Varietal (CreateAndModify)

+(Varietal *)varietalForWine:(Wine *)wine foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary

{
    Varietal *varietal = nil;
    
    varietal = (Varietal *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:VARIETAL_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(varietal){
        
        // ATTRIBUTES
        
        varietal.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
        // varietal.lastAccessed
        varietal.markForDeletion = [dictionary objectForKeyNotNull:MARK_FOR_DELETION];
        varietal.name = [dictionary objectForKeyNotNull:NAME];
        varietal.version = [dictionary objectForKeyNotNull:VERSION];
        
        
        // RELATIONSHIPS
        
        NSMutableSet *wines = [varietal.wines mutableCopy];
        if(![wines containsObject:wine]) [wines addObject:wine];
        varietal.wines = wines;
    }
    
    return varietal;
}

@end
