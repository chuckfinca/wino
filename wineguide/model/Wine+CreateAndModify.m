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
#define BRAND @"brand"
#define NAME @"name"
#define REGION @"region"
#define COUNTRY @"country"
#define TYPE @"type"
#define SPARKLING @"sparkling"
#define VARIETALS @"varietals"
#define PRICE @"price"
#define TASTING_NOTES @"tastingNotes"
#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define IDENTIFIER @"identifier"

@implementation Wine (CreateAndModify)

+(Wine *)wineWithInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    Wine *wine = nil;
    
    wine = (Wine *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:ENTITY_NAME inContext:context usingDictionary:dictionary];
    
    if(wine){
        if([wine.version intValue] == 0 || wine.version < dictionary[VERSION]){
            
            wine.brand = dictionary[BRAND];
            wine.name = dictionary[NAME];
            wine.type = dictionary[TYPE];
            wine.varietals = dictionary[VARIETALS];
            wine.sparkling = dictionary[SPARKLING];
            wine.region = dictionary[REGION];
            wine.country = dictionary[COUNTRY];
            wine.price = dictionary[PRICE];
            wine.tastingNotes = dictionary[TASTING_NOTES];
            wine.markForDeletion = dictionary[MARK_FOR_DELETION] ? dictionary[MARK_FOR_DELETION] : @NO;
            wine.identifier = dictionary[IDENTIFIER];
            wine.version = dictionary[VERSION];
            
        }
    }
    
    return wine;
}

@end
