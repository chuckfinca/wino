//
//  Brand+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Brand+CreateAndModify.h"
#import "ManagedObjectHandler.h"

@implementation Brand (CreateAndModify)

#define ENTITY_NAME @"Brand"
#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define IDENTIFIER @"identifier"
#define TYPE @"type"

+(Brand *)brandWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    Brand *brand = nil;
    
    brand = (Brand *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:ENTITY_NAME andNameAttribute:name inContext:context];
    
    if(brand){
        brand.name = name;
        brand.markForDeletion = @NO;
        brand.version = 0;
        brand.identifier = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return brand;
}

@end
