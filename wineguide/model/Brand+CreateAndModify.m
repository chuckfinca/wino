//
//  Brand+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Brand+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"

@implementation Brand (CreateAndModify)

#define BRAND_ENTITY @"Brand"

#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define VERSION @"version"

+(Brand *)brandForWine:(Wine *)wine foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Brand *brand = nil;
    
    brand = (Brand *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:BRAND_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(brand){
        
        // ATTRIBUTES
        
        brand.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
        // brand.lastAccessed
        brand.markForDeletion = [dictionary objectForKeyNotNull:MARK_FOR_DELETION];
        brand.name = [dictionary objectForKeyNotNull:NAME];
        brand.version = [dictionary objectForKeyNotNull:VERSION];
        
        
        // RELATIONSHIPS
        
        NSMutableSet *wines = [brand.wines mutableCopy];
        if(![wines containsObject:wine]) [wines addObject:wine];
        brand.wines = wines;
    }
    return brand;
}

@end
