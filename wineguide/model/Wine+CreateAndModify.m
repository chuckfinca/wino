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
#import "FlightDataHelper.h"
#import "GroupDataHelper.h"
#import "WineUnitDataHelper.h"

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
#define LAST_SERVER_UPDATE @"lastServerUpdate"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define REGION @"region"
#define SPARKLING @"sparkling"
#define STATE_GEO @"state"
#define VARIETALS @"varietals"
#define VERSION_NUMBER @"versionNumber"
#define VINEYARD @"vineyard"

#define VINTAGE @"vintage"
#define BRAND @"brand"
#define TASTING_NOTES @"tastingnotes"
#define WINE_UNITS @"wineUnits"
#define GROUPS @"groups"
#define FLIGHTS @"flights"

#define BRAND_IDENTIFIER @"brandIdentifier"
#define VARIETAL_IDENTIFIERS @"varietalIdentifiers"
#define TASTING_NOTE_IDENTIFIERS @"tastingNoteIdentifiers"
#define FLIGHT_IDENTIFIERS @"flightIdentifiers"
#define GROUP_IDENTIFIERS @"groupIdentifiers"
#define WINE_UNIT_IDENTIFIERS @"wineUnitIdentifiers"

#define DIVIDER @"/"


@implementation Wine (CreateAndModify)

+(Wine *)wineFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Wine *wine = nil;
    
    wine = (Wine *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:WINE_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [wine lastUpdatedDateFromDictionary:dictionary];
    
    if(!wine.lastServerUpdate || [wine.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        // ATTRIBUTES
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            wine.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            wine.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            wine.alcoholPercentage = [dictionary sanitizedValueForKey:ALCOHOL];
            wine.color = [dictionary sanitizedStringForKey:COLOR];
            wine.country = [dictionary sanitizedStringForKey:COUNTRY];
            wine.dessert = [dictionary sanitizedValueForKey:DESSERT];
            // wine.favorite
            wine.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            wine.isPlaceholderForFutureObject = @NO;
            wine.lastServerUpdate = dictionaryLastUpdatedDate;
            wine.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            wine.name = [dictionary sanitizedStringForKey:NAME];
            wine.region = [dictionary sanitizedStringForKey:REGION];
            wine.sparkling = [dictionary sanitizedValueForKey:SPARKLING];
            wine.state = [dictionary sanitizedStringForKey:STATE_GEO];
            wine.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            wine.vineyard = [dictionary sanitizedStringForKey:VINEYARD];
            wine.vintage = [dictionary sanitizedValueForKey:VINTAGE];
            
            // store any information about relationships provided
            
            NSString *brandIdentifier = [dictionary sanitizedStringForKey:BRAND_IDENTIFIER];
            wine.brandIdentifier = brandIdentifier;
            if(brandIdentifier) [identifiers setObject:brandIdentifier forKey:BRAND_IDENTIFIER];
            
            NSString *tastingNoteIdentifiers = [dictionary sanitizedStringForKey:TASTING_NOTE_IDENTIFIERS];
            wine.tastingNoteIdentifers = [wine addIdentifiers:tastingNoteIdentifiers toCurrentIdentifiers:wine.tastingNoteIdentifers];
            if(tastingNoteIdentifiers) [identifiers setObject:tastingNoteIdentifiers forKey:TASTING_NOTE_IDENTIFIERS];
            
            NSString *varietalIdentifiers = [dictionary sanitizedStringForKey:VARIETAL_IDENTIFIERS];
            wine.varietalIdentifiers = [wine addIdentifiers:varietalIdentifiers toCurrentIdentifiers:wine.varietalIdentifiers];
            if(varietalIdentifiers) [identifiers setObject:varietalIdentifiers forKey:VARIETAL_IDENTIFIERS];
            
            NSString *flightIdentifiers = [dictionary sanitizedStringForKey:FLIGHT_IDENTIFIERS];
            wine.flightIdentifiers = [wine addIdentifiers:flightIdentifiers toCurrentIdentifiers:wine.flightIdentifiers];
            if(flightIdentifiers) [identifiers setObject:flightIdentifiers forKey:FLIGHT_IDENTIFIERS];
            
            NSString *groupIdentifiers = [dictionary sanitizedStringForKey:GROUP_IDENTIFIERS];
            wine.groupIdentifiers = [wine addIdentifiers:groupIdentifiers toCurrentIdentifiers:wine.groupIdentifiers];
            if(groupIdentifiers) [identifiers setObject:groupIdentifiers forKey:GROUP_IDENTIFIERS];
            
            NSString *wineUnitIdentifiers = [dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS];
            wine.wineUnitIdentifiers = [wine addIdentifiers:wineUnitIdentifiers toCurrentIdentifiers:wine.wineUnitIdentifiers];
            if(wineUnitIdentifiers) [identifiers setObject:wineUnitIdentifiers forKey:WINE_UNIT_IDENTIFIERS];
        }
        
        if([wine.isPlaceholderForFutureObject boolValue] == NO){
            [wine updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        }
        
    } else if([wine.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
        [wine updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    //[wine logDetails];
    
    return wine;
}



-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Brand
    BrandDataHelper *bdh = [[BrandDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[BRAND_IDENTIFIER]];
    [bdh updateNestedManagedObjectsLocatedAtKey:BRAND inDictionary:dictionary];
    if(!self.name) self.name = self.brand.name;
    
    // Tasting Notes
    TastingNoteDataHelper *tndh = [[TastingNoteDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[TASTING_NOTE_IDENTIFIERS]];
    [tndh updateNestedManagedObjectsLocatedAtKey:TASTING_NOTES inDictionary:dictionary];
    
    // Varietals
    VarietalDataHelper *vdh = [[VarietalDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[VARIETAL_IDENTIFIERS]];
    [vdh updateNestedManagedObjectsLocatedAtKey:VARIETALS inDictionary:dictionary];
    
    // Flights
    FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[FLIGHT_IDENTIFIERS]];
    [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
    
    // Groupings
    GroupDataHelper *gdh = [[GroupDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[GROUP_IDENTIFIERS]];
    [gdh updateNestedManagedObjectsLocatedAtKey:GROUPS inDictionary:dictionary];
    
    // WineUnits
    WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_UNIT_IDENTIFIERS]];
    [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
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
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"region = %@",self.region);
    NSLog(@"sparkling = %@",self.sparkling);
    NSLog(@"state = %@",self.state);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"vineyard = %@",self.vineyard);
    NSLog(@"vintage = %@",self.vintage);
    
    NSLog(@"brandIdentifier = %@",self.brandIdentifier);
    NSLog(@"wineUnitIdentifiers = %@",self.wineUnitIdentifiers);
    NSLog(@"tastingNoteIdentifers = %@",self.tastingNoteIdentifers);
    NSLog(@"varietalIdentifiers = %@",self.varietalIdentifiers);
    
    NSLog(@"brand = %@",self.brand.description);
    
    
    NSLog(@"groups count = %lu", (unsigned long)[self.groups count]);
    for(NSObject *obj in self.groups){
        NSLog(@"  %@",obj.description);
    }
    
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
