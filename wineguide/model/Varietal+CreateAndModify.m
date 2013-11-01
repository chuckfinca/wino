//
//  Varietal+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Varietal+CreateAndModify.h"
#import "ManagedObjectHandler.h"

#define ENTITY_NAME @"Varietal"
#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define IDENTIFIER @"identifier"

@implementation Varietal (CreateAndModify)

+(Varietal *)varietalWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    Varietal *varietal = nil;
    
    varietal = (Varietal *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:ENTITY_NAME andNameAttribute:name inContext:context];
    
    if(varietal){
        varietal.name = name;
        varietal.markForDeletion = @NO;
        varietal.version = 0;
    }
    
    return varietal;
}

@end
