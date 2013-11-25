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
#import "NSManagedObject+Helper.h"

#import "BrandDataHelper.h"
#import "TastingNoteDataHelper.h"
#import "VarietalDataHelper.h"
#import "GroupingDataHelper.h"
#import "FlightDataHelper.h"
#import "WineUnitDataHelper.h"

#import "Flight.h"
#import "Group.h"
#import "WineUnit.h"
#import "Brand.h"

#define WINE_ENTITY @"Wine"
#define RESTAURANT_ENTITY @"Restaurant"

#define ALCOHOL @"alcoholPercentage"
#define COLOR @"color"
#define COUNTRY @"country"
#define DESSERT @"dessert"
#define FAVORITE @"favorite"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
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
#define TASTING_NOTES @"tastingnotes"
#define WINE_UNITS @"wineUnits"

#define BRAND_IDENTIFIER @"brandIdentifier"
#define WINE_UNIT_IDENTIFIERS @"wineUnitIdentifiers"
#define VARIETAL_IDENTIFIERS @"varietalIdentifiers"
#define TASTING_NOTE_IDENTIFIERS @"tastingNoteIdentifiers"

#define DIVIDER @"/"


@implementation Wine (CreateAndModify)

+(Wine *)wineFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Wine *wine = nil;
    
    wine = (Wine *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:WINE_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(wine){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            wine.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            wine.isPlaceholderForFutureObject = @YES;
            
        } else {
            if([wine.version intValue] == 0 || wine.version < dictionary[VERSION]){
                
                // ATTRIBUTES
                
                wine.alcoholPercentage = [dictionary sanitizedValueForKey:ALCOHOL];
                wine.color = [dictionary sanitizedStringForKey:COLOR];
                wine.country = [dictionary sanitizedStringForKey:COUNTRY];
                wine.dessert = [dictionary sanitizedValueForKey:DESSERT];
                // wine.favorite
                wine.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
                wine.isPlaceholderForFutureObject = @NO;
                // wine.lastAccessed
                wine.markForDeletion = [dictionary sanitizedValueForKey:DELETE_ENTITY];
                wine.name = [dictionary sanitizedStringForKey:NAME];
                wine.region = [dictionary sanitizedStringForKey:REGION];
                wine.sparkling = [dictionary sanitizedValueForKey:SPARKLING];
                wine.state = [dictionary sanitizedStringForKey:STATE_GEO];
                wine.version = [dictionary sanitizedValueForKey:VERSION];
                wine.vineyard = [dictionary sanitizedStringForKey:VINEYARD];
                wine.vintage = [dictionary sanitizedValueForKey:VINTAGE];
                
                // store any information about relationships provided
                
                NSString *brandIdentifier = [dictionary sanitizedStringForKey:BRAND_IDENTIFIER];
                wine.brandIdentifier = brandIdentifier;
                
                NSString *tastingNoteIdentifiers = [dictionary sanitizedStringForKey:TASTING_NOTE_IDENTIFIERS];
                wine.tastingNoteIdentifers = [wine addIdentifiers:tastingNoteIdentifiers toCurrentIdentifiers:wine.tastingNoteIdentifers];
                
                NSString *varietalIdentifiers = [dictionary sanitizedStringForKey:VARIETAL_IDENTIFIERS];
                wine.varietalIdentifiers = [wine addIdentifiers:varietalIdentifiers toCurrentIdentifiers:wine.varietalIdentifiers];
                
                NSString *wineUnitIdentifiers = [dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS];
                wine.wineUnitIdentifiers = [wine addIdentifiers:wineUnitIdentifiers toCurrentIdentifiers:wine.wineUnitIdentifiers];
                
                
                // RELATIONSHIPS
                // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
                
                // Brand
                BrandDataHelper *bdh = [[BrandDataHelper alloc] initWithContext:context andRelatedObject:wine andNeededManagedObjectIdentifiersString:brandIdentifier];
                [bdh updateNestedManagedObjectsLocatedAtKey:BRAND inDictionary:dictionary];
                if(!wine.name) wine.name = wine.brand.name;
                
                // Tasting Notes
                TastingNoteDataHelper *tndh = [[TastingNoteDataHelper alloc] initWithContext:context andRelatedObject:wine andNeededManagedObjectIdentifiersString:tastingNoteIdentifiers];
                [tndh updateNestedManagedObjectsLocatedAtKey:TASTING_NOTES inDictionary:dictionary];
                
                // Varietals
                VarietalDataHelper *vdh = [[VarietalDataHelper alloc] initWithContext:context andRelatedObject:wine andNeededManagedObjectIdentifiersString:varietalIdentifiers];
                [vdh updateNestedManagedObjectsLocatedAtKey:VARIETALS inDictionary:dictionary];
                
                // WineUnits
                WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context andRelatedObject:wine andNeededManagedObjectIdentifiersString:wineUnitIdentifiers];
                [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
            }
        }
    }
    
    // [wine logDetails];
    
    return wine;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"alcoholPercentage = %@",self.alcoholPercentage);
    NSLog(@"color = %@",self.color);
    NSLog(@"country = %@",self.country);
    NSLog(@"dessert = %@",self.dessert);
    NSLog(@"favorite = %@",self.favorite);
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"name = %@",self.name);
    NSLog(@"region = %@",self.region);
    NSLog(@"sparkling = %@",self.sparkling);
    NSLog(@"state = %@",self.state);
    NSLog(@"version = %@",self.version);
    NSLog(@"vineyard = %@",self.vineyard);
    NSLog(@"vintage = %@",self.vintage);
    
    NSLog(@"brandIdentifier = %@",self.brandIdentifier);
    NSLog(@"wineUnitIdentifiers = %@",self.wineUnitIdentifiers);
    NSLog(@"tastingNoteIdentifers = %@",self.tastingNoteIdentifers);
    NSLog(@"varietalIdentifiers = %@",self.varietalIdentifiers);
    
    NSLog(@"brand = %@",self.brand.description);
    
    NSLog(@"tastingNotes count = %lu", (unsigned long)[self.tastingNotes count]);
    for(NSObject *obj in self.tastingNotes){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"varietals count = %lu", (unsigned long)[self.varietals count]);
    for(NSObject *obj in self.varietals){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wineUnits count = %lu", (unsigned long)[self.wineUnits count]);
    for(NSObject *obj in self.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}







@end
