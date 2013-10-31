//
//  Wine+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine+CreateAndModify.h"
#import "ManagedObjectHandler.h"


#define ENTITY_NAME @"Wine"
#define COUNTRY @"country"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define LONGITUDE @"longitude"
#define LATITUDE @"latitude"
#define ADDRESS @"address"
#define CITY @"city"
#define STATE @"state"
#define VERSION @"version"
#define IDENTIFIER @"identifier"
#define WINES @"wines"
#define BRANDS @"brands"
#define VARIETALS @"varietals"

@implementation Wine (CreateAndModify)

+(Wine *)wineWithInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    Wine *wine = nil;
    
    wine = (Wine *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:@"Wine" inContext:context usingDictionary:dictionary];
    
    if(wine){
        NSLog(@"success! = %@", [wine class]);
        
    }
    
    return wine;
}

@end
