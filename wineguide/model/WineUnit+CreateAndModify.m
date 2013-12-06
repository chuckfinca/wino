//
//  WineUnit+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/5/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineUnit+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "WineDataHelper.h"
#import "GroupDataHelper.h"
#import "FlightDataHelper.h"

#define WINE_UNIT_ENTITY @"WineUnit"

#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_UPDATED @"lastUpdated"
#define DELETED_ENTITY @"deletedEntity"
#define PRICE @"price"
#define QUANTITY @"quantity"
#define VERSION_NUMBER @"versionNumber"

#define GROUP_IDENTIFIERS @"groupIdentifiers"
#define FLIGHT_IDENTIFIERS @"flightIdentifiers"
#define WINE_IDENTIFIER @"wineIdentifier"

#define WINE @"wine"
#define FLIGHTS @"flights"
#define GROUPS @"groups"

@implementation WineUnit (CreateAndModify)

+(WineUnit *)wineUnitFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    WineUnit *wineUnit = nil;
    
    wineUnit = (WineUnit *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:WINE_UNIT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [wineUnit lastUpdatedDateFromDictionary:dictionary];
    
    if(!wineUnit.lastUpdated || [wineUnit.lastUpdated laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            wineUnit.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            wineUnit.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            // ATTRIBUTES
            
            // wineUnit.lastAccessed
            wineUnit.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            wineUnit.isPlaceholderForFutureObject = @NO;
            wineUnit.lastUpdated = dictionaryLastUpdatedDate;
            wineUnit.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            wineUnit.price = [dictionary sanitizedValueForKey:PRICE];
            wineUnit.quantity = [dictionary sanitizedStringForKey:QUANTITY];
            wineUnit.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            NSString *flightIdentifiers = [dictionary sanitizedStringForKey:FLIGHT_IDENTIFIERS];
            wineUnit.flightIdentifiers = [wineUnit addIdentifiers:flightIdentifiers toCurrentIdentifiers:wineUnit.flightIdentifiers];
            if(flightIdentifiers) [identifiers setObject:flightIdentifiers forKey:FLIGHT_IDENTIFIERS];
            
            NSString *groupIdentifiers = [dictionary sanitizedStringForKey:GROUP_IDENTIFIERS];
            wineUnit.groupIdentifiers = [wineUnit addIdentifiers:groupIdentifiers toCurrentIdentifiers:wineUnit.groupIdentifiers];
            if(groupIdentifiers) [identifiers setObject:groupIdentifiers forKey:GROUP_IDENTIFIERS];
            
            NSString *wineIdentifier = [dictionary sanitizedStringForKey:WINE_IDENTIFIER];
            wineUnit.wineIdentifier = wineIdentifier;
            if(wineIdentifier) [identifiers setObject:wineIdentifier forKey:WINE_IDENTIFIER];
        }
        
        [wineUnit updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        
    } else if([wineUnit.lastUpdated isEqualToDate:dictionaryLastUpdatedDate]){
        [wineUnit updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    // [wineUnit logDetails];
    
    return wineUnit;
}

-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    // Flights
    FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[FLIGHT_IDENTIFIERS]];
    [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
    
    // Groupings
    GroupDataHelper *gdh = [[GroupDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[GROUP_IDENTIFIERS]];
    [gdh updateNestedManagedObjectsLocatedAtKey:GROUPS inDictionary:dictionary];
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_IDENTIFIER]];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINE inDictionary:dictionary];
}


-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"lastUpdated = %@",self.lastUpdated);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"price = %@",self.price);
    NSLog(@"quantity = %@",self.quantity);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"flightIdentifiers = %@",self.flightIdentifiers);
    NSLog(@"groupIdentifiers = %@",self.groupIdentifiers);
    NSLog(@"wineIdentifier = %@",self.wineIdentifier);
    
    NSLog(@"flights count = %lu",(unsigned long)[self.flights count]);
    for(NSObject *obj in self.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groupings count = %lu",(unsigned long)[self.groups count]);
    for(NSObject *obj in self.groups){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wine = %@",self.wine);
    NSLog(@"\n\n\n");
}








@end
