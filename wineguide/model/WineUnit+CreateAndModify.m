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
#import "GroupingDataHelper.h"
#import "FlightDataHelper.h"

#define WINE_UNIT_ENTITY @"WineUnit"

#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define PRICE @"price"
#define QUANTITY @"quantity"
#define VERSION @"version"

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
    
    if(wineUnit){
        
        // ATTRIBUTES
        
        wineUnit.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
        // wineUnit.lastAccessed
        wineUnit.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
        wineUnit.price = [dictionary sanitizedValueForKey:PRICE];
        wineUnit.quantity = [dictionary sanatizedStringForKey:QUANTITY];
        wineUnit.version = [dictionary sanitizedValueForKey:VERSION];
        
        // store any information about relationships provided
        
        wineUnit.groupIdentifiers = [dictionary sanatizedStringForKey:GROUP_IDENTIFIERS];
        wineUnit.flightIdentifiers = [dictionary sanatizedStringForKey:FLIGHT_IDENTIFIERS];
        wineUnit.wineIdentifier = [dictionary sanatizedStringForKey:WINE_IDENTIFIER];
        
        // RELATIONSHIPS
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context];
        [wdh updateNestedManagedObjectsLocatedAtKey:WINE inDictionary:dictionary];
        
        // Flights
        FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context];
        [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
        
        // Groupings
        GroupingDataHelper *gdh = [[GroupingDataHelper alloc] initWithContext:context];
        [gdh updateNestedManagedObjectsLocatedAtKey:GROUPS inDictionary:dictionary];
    }
    
    //[wineUnit logDetails];
    
    return wineUnit;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"price = %@",self.price);
    NSLog(@"quantity = %@",self.quantity);
    NSLog(@"version = %@",self.version);
    NSLog(@"flightIdentifiers = %@",self.flightIdentifiers);
    NSLog(@"groupIdentifiers = %@",self.groupIdentifiers);
    NSLog(@"wineIdentifier = %@",self.wineIdentifier);
    
    NSLog(@"flights count = %i",[self.flights count]);
    for(NSObject *obj in self.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groupings count = %i",[self.groups count]);
    for(NSObject *obj in self.groups){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wine = %@",self.wine);
    NSLog(@"\n\n\n");
}








@end
