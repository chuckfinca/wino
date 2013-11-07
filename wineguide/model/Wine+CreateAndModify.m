//
//  Wine+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"

#import "BrandDataHelper.h"
#import "TastingNoteDataHelper.h"
#import "VarietalDataHelper.h"

#import "Flight.h"
#import "Grouping.h"
#import "WineUnit.h"

#define WINE_ENTITY @"Wine"
#define RESTAURANT_ENTITY @"Restaurant"

#define ALCOHOL @"alcoholPercentage"
#define COLOR @"color"
#define COUNTRY @"country"
#define DESSERT @"dessert"
#define FAVORITE @"favorite"
#define IDENTIFIER @"identifier"
#define LAST_ACCESSED @"lastAccessed"
#define DELETE_ENTITY @"markForDeletion"
#define NAME @"name"
#define REGION @"region"
#define SPARKLING @"sparkling"
#define STATE_GEO @"state"
#define VARIETALS @"varietals"
#define VERSION @"version"
#define VINEYARD @"vineyard"
#define VINTAGE @"vintage"
#define BRAND @"brand"
#define GROUPINGS @"groupings"
#define TASTING_NOTES @"tastingnotes"
#define FLIGHTS @"flights"

#define DIVIDER @"/"


@implementation Wine (CreateAndModify)

+(Wine *)wineFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Wine *wine = nil;
    
    wine = (Wine *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:WINE_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(wine){
        if([wine.version intValue] == 0 || wine.version < dictionary[VERSION]){
            
            // ATTRIBUTES
            
            wine.alcoholPercentage = [dictionary objectForKeyNotNull:ALCOHOL];
            wine.color = [dictionary objectForKeyNotNull:COLOR];
            wine.country = [dictionary objectForKeyNotNull:COUNTRY];
            wine.dessert = [dictionary objectForKeyNotNull:DESSERT];
            // wine.favorite
            wine.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
            // wine.lastAccessed
            wine.markForDeletion = [dictionary objectForKeyNotNull:DELETE_ENTITY];
            wine.name = [dictionary objectForKeyNotNull:NAME];
            wine.region = [dictionary objectForKeyNotNull:REGION];
            wine.sparkling = [dictionary objectForKeyNotNull:SPARKLING];
            wine.state = [dictionary objectForKeyNotNull:STATE_GEO];
            wine.version = [dictionary objectForKeyNotNull:VERSION];
            wine.vineyard = [dictionary objectForKeyNotNull:VINEYARD];
            wine.vintage = [dictionary objectForKeyNotNull:VINTAGE];
            
            
            // RELATIONSHIPS
            // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
            
            // Brand
            BrandDataHelper *bdh = [[BrandDataHelper alloc] initWithContext:context];
            bdh.parentManagedObject = wine;
            [bdh updateNestedManagedObjectsLocatedAtKey:BRAND inDictionary:dictionary];
        
            // Tasting Notes
            TastingNoteDataHelper *tndh = [[TastingNoteDataHelper alloc] initWithContext:context];
            tndh.parentManagedObject = wine;
            [tndh updateNestedManagedObjectsLocatedAtKey:TASTING_NOTES inDictionary:dictionary];
            
            // Varietals
            VarietalDataHelper *vdh = [[VarietalDataHelper alloc] init];
            vdh.parentManagedObject = wine;
            [vdh updateNestedManagedObjectsLocatedAtKey:VARIETALS inDictionary:dictionary];
            
            // Groupings
            
            // Flights
            
            // WineUnits
        }
    }
    return wine;
}

@end
