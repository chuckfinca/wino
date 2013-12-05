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
    
    NSString *flightIdentifiers;
    NSString *groupIdentifiers;
    NSString *wineIdentifier;
    
    NSLog(@"self = %@",self);
    NSLog(@"lastUpdated = %@",wineUnit.lastUpdated);
    NSLog(@"dictionary[LAST_UPDATED] = %@",dictionary[LAST_UPDATED]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss Z"];
    NSDate *serverDate = [dateFormatter dateFromString:dictionary[LAST_UPDATED]];
    
    NSLog(@"serverDate = %@",serverDate);
    if(!wineUnit.lastUpdated || [wineUnit.lastUpdated laterDate:serverDate] == serverDate){
        NSLog(@"inside");
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            wineUnit.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            wineUnit.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            // ATTRIBUTES
            
            // wineUnit.lastAccessed
            wineUnit.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            wineUnit.isPlaceholderForFutureObject = @NO;
            wineUnit.lastUpdated = [NSDate date];
            wineUnit.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            wineUnit.price = [dictionary sanitizedValueForKey:PRICE];
            wineUnit.quantity = [dictionary sanitizedStringForKey:QUANTITY];
            wineUnit.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            flightIdentifiers = [dictionary sanitizedStringForKey:FLIGHT_IDENTIFIERS];
            wineUnit.flightIdentifiers = [wineUnit addIdentifiers:flightIdentifiers toCurrentIdentifiers:wineUnit.flightIdentifiers];
            
            groupIdentifiers = [dictionary sanitizedStringForKey:GROUP_IDENTIFIERS];
            wineUnit.groupIdentifiers = [wineUnit addIdentifiers:groupIdentifiers toCurrentIdentifiers:wineUnit.groupIdentifiers];
            
            wineIdentifier = [dictionary sanitizedStringForKey:WINE_IDENTIFIER];
            wineUnit.wineIdentifier = wineIdentifier;
        }
    }
    
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    // Flights
    FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context andRelatedObject:wineUnit andNeededManagedObjectIdentifiersString:flightIdentifiers];
    [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
    
    // Groupings
    GroupDataHelper *gdh = [[GroupDataHelper alloc] initWithContext:context andRelatedObject:wineUnit andNeededManagedObjectIdentifiersString:groupIdentifiers];
    [gdh updateNestedManagedObjectsLocatedAtKey:GROUPS inDictionary:dictionary];
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:wineUnit andNeededManagedObjectIdentifiersString:wineIdentifier];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINE inDictionary:dictionary];
    
    //[wineUnit logDetails];
    
    return wineUnit;
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
