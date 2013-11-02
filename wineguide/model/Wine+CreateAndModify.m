//
//  Wine+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine+CreateAndModify.h"
#import "TastingNote+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "Varietal+CreateAndModify.h"
#import "NSDictionary+Helper.h"
#import "Brand+CreateAndModify.h"



#define ENTITY_NAME @"Wine"
#define BRAND @"brand"
#define NAME @"name"
#define VINEYARD @"vineyard"
#define REGION @"region"
#define COUNTRY @"country"
#define COLOR @"color"
#define SPARKLING @"sparkling"
#define DESSERT @"dessert"
#define VARIETALS @"varietals"
#define PRICE @"price"
#define TASTING_NOTES @"tastingNotes"
#define DELETE_ENTITY @"markForDeletion"
#define VERSION @"version"
#define IDENTIFIER @"identifier"

@implementation Wine (CreateAndModify)

+(Wine *)wineWithInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    Wine *wine = nil;
    
    wine = (Wine *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:ENTITY_NAME inContext:context usingDictionary:dictionary];
    
    if(wine){
        if([wine.version intValue] == 0 || wine.version < dictionary[VERSION]){
            
            wine.name = [dictionary objectForKeyNotNull:NAME];
            wine.vineyard = [dictionary objectForKeyNotNull:VINEYARD];
            wine.color = [dictionary objectForKeyNotNull:COLOR];
            wine.sparkling = [[dictionary objectForKeyNotNull:SPARKLING] boolValue] == YES ? @1 : @0;
            wine.dessert = [[dictionary objectForKeyNotNull:DESSERT] boolValue] == YES ? @1 : @0;
            wine.region = [dictionary objectForKeyNotNull:REGION];
            wine.country = [dictionary objectForKeyNotNull:COUNTRY];
            wine.price = [dictionary objectForKeyNotNull:PRICE];
            wine.markForDeletion = [[dictionary objectForKeyNotNull:DELETE_ENTITY] boolValue] == YES ? @1 : @0;
            wine.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
            wine.version = [NSNumber numberWithDouble:[[dictionary objectForKeyNotNull:VERSION] doubleValue]];
            
            NSArray *varietals = [dictionary separateNonNullStringLocatedAtKey:VARIETALS];
            NSMutableSet *varietalsSet = [[NSMutableSet alloc] init];
            for(NSString *varietalName in varietals){
                Varietal *varietal = [Varietal varietalWithName:varietalName inContext:context];
                [varietalsSet addObject:varietal];
            }
            wine.varietals = varietalsSet;
            
            NSArray *tastingNotes = [dictionary separateNonNullStringLocatedAtKey:TASTING_NOTES];
            NSMutableSet *tastingNotesSet = [[NSMutableSet alloc] init];
            for(NSString *tastingNoteName in tastingNotes){
                TastingNote *tn = [TastingNote tastingNoteWithName:tastingNoteName inContext:context];
                [tastingNotesSet addObject:tn];
            }
            wine.tastingNotes = tastingNotesSet;
            
            Brand *brand = [Brand brandWithName:dictionary[BRAND] inContext:context];
            wine.brand = brand;
            
        }
    }
    
    return wine;
}

@end
