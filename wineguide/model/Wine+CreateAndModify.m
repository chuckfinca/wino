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
#import "GroupingDataHelper.h"
#import "FlightDataHelper.h"
#import "WineUnitDataHelper.h"

#import "Flight.h"
#import "Grouping.h"
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
#define WINE_UNITS @"wineUnits"

#define BRAND_IDENTIFIER @"brandIdentifier"
#define FLIGHT_IDENTIFIERS @"flightIdentifiers"
#define GROUP_IDENTIFIERS @"groupIdentifiers"
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
        if([wine.version intValue] == 0 || wine.version < dictionary[VERSION]){
            
            // ATTRIBUTES
            
            wine.alcoholPercentage = [dictionary sanitizedValueForKey:ALCOHOL];
            wine.color = [dictionary sanitizedValueForKey:COLOR];
            wine.country = [dictionary sanitizedValueForKey:COUNTRY];
            wine.dessert = [dictionary sanitizedValueForKey:DESSERT];
            // wine.favorite
            wine.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            // wine.lastAccessed
            wine.markForDeletion = [dictionary sanitizedValueForKey:DELETE_ENTITY];
            wine.name = [dictionary sanitizedValueForKey:NAME];
            wine.region = [dictionary sanitizedValueForKey:REGION];
            wine.sparkling = [dictionary sanitizedValueForKey:SPARKLING];
            wine.state = [dictionary sanitizedValueForKey:STATE_GEO];
            wine.version = [dictionary sanitizedValueForKey:VERSION];
            wine.vineyard = [dictionary sanitizedValueForKey:VINEYARD];
            wine.vintage = [dictionary sanitizedValueForKey:VINTAGE];
            
            // store any information about relationships provided
            
            wine.brandIdentifier = [dictionary sanitizedValueForKey:BRAND_IDENTIFIER];
            [wine addIdentifiers:[dictionary sanitizedValueForKey:FLIGHT_IDENTIFIERS] toCurrentIdentifiers:wine.flightIdentifiers];
            [wine addIdentifiers:[dictionary sanitizedValueForKey:GROUP_IDENTIFIERS] toCurrentIdentifiers:wine.groupIdentifiers];
            [wine addIdentifiers:[dictionary sanitizedValueForKey:WINE_UNIT_IDENTIFIERS] toCurrentIdentifiers:wine.wineUnitIdentifiers];
            [wine addIdentifiers:[dictionary sanitizedValueForKey:TASTING_NOTE_IDENTIFIERS] toCurrentIdentifiers:wine.tastingNoteIdentifers];
            [wine addIdentifiers:[dictionary sanitizedValueForKey:VARIETAL_IDENTIFIERS] toCurrentIdentifiers:wine.varietalIdentifiers];
            
            
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
            VarietalDataHelper *vdh = [[VarietalDataHelper alloc] initWithContext:context];
            vdh.parentManagedObject = wine;
            [vdh updateNestedManagedObjectsLocatedAtKey:VARIETALS inDictionary:dictionary];
            
            // Groupings
            GroupingDataHelper *gdh = [[GroupingDataHelper alloc] initWithContext:context];
            gdh.parentManagedObject = wine;
            [gdh updateNestedManagedObjectsLocatedAtKey:GROUPINGS inDictionary:dictionary];
            
            // Flights
            FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context];
            fdh.parentManagedObject = wine;
            [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
            
            // WineUnits
            WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context];
            wudh.parentManagedObject = wine;
            [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
        }
    }
    
    [wine logDetails];
    
    return wine;
}

-(void)addIdentifiers:(NSString *)newIdentifiers toCurrentIdentifiers:(NSString *)currentIdentifiers
{
    if(!currentIdentifiers){
        currentIdentifiers = newIdentifiers;
    } else {
        currentIdentifiers = [currentIdentifiers stringByAppendingString:[NSString stringWithFormat:@"%@%@",DIVIDER,newIdentifiers]];
    }
}


-(NSString *)description
{
    return self.identifier;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
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
    
    NSLog(@"vintage = %@",self.brandIdentifier);
    NSLog(@"vintage = %@",self.flightIdentifiers);
    NSLog(@"vintage = %@",self.groupIdentifiers);
    NSLog(@"vintage = %@",self.wineUnitIdentifiers);
    NSLog(@"vintage = %@",self.tastingNoteIdentifers);
    NSLog(@"vintage = %@",self.varietalIdentifiers);
    
    NSLog(@"brand = %@",self.brand.description);
    
    NSLog(@"tastingNotes count = %i",[self.tastingNotes count]);
    for(NSObject *obj in self.tastingNotes){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"varietals count = %i",[self.varietals count]);
    for(NSObject *obj in self.varietals){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groupings count = %i",[self.groupings count]);
    for(NSObject *obj in self.groupings){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groupings flights = %i",[self.flights count]);
    for(NSObject *obj in self.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wineUnits flights = %i",[self.wineUnits count]);
    for(NSObject *obj in self.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}







@end
