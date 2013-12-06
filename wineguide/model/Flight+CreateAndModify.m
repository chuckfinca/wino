//
//  Flight+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/4/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Flight+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "WineUnitDataHelper.h"
#import "RestaurantDataHelper.h"
#import "Restaurant.h"

#define FLIGHT_ENTITY @"Flight"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_UPDATED @"lastUpdated"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define PRICE @"price"
#define VERSION_NUMBER @"versionNumber"
#define WINE_UNIT_IDENTIFIERS @"wineUnitIdentifiers"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINE_UNITS @"wineUnits"

#define DIVIDER @"/"

@implementation Flight (CreateAndModify)

+(Flight *)flightFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Flight *flight = nil;
    
    flight = (Flight *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:FLIGHT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [flight lastUpdatedDateFromDictionary:dictionary];
    
    if(!flight.lastUpdated || [flight.lastUpdated laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            flight.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            flight.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            // ATTRIBUTES
            
            flight.about = [dictionary sanitizedStringForKey:ABOUT];
            flight.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            flight.isPlaceholderForFutureObject = @NO;
            flight.lastUpdated = dictionaryLastUpdatedDate;
            flight.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            flight.name = [dictionary sanitizedStringForKey:NAME];
            flight.price = [dictionary sanitizedValueForKey:PRICE];
            flight.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            NSString *restaurantIdentifier = [dictionary sanitizedStringForKey:RESTAURANT_IDENTIFIER];
            flight.restaurantIdentifier = restaurantIdentifier;
            if(restaurantIdentifier) [identifiers setObject:restaurantIdentifier forKey:RESTAURANT_IDENTIFIER];
            
            NSString *wineUnitIdentifiers = [dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS];
            flight.wineUnitIdentifiers = [flight addIdentifiers:wineUnitIdentifiers toCurrentIdentifiers:flight.wineUnitIdentifiers];
            if(wineUnitIdentifiers) [identifiers setObject:wineUnitIdentifiers forKey:WINE_UNIT_IDENTIFIERS];
        }
        
        [flight updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        
    } else if([flight.lastUpdated isEqualToDate:dictionaryLastUpdatedDate]){
        [flight updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    //[flight logDetails];
    
    return flight;
}

-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // RELATIONSHIPS
    
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Restaurants
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[RESTAURANT_IDENTIFIER]];
    [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
    
    // WineUnits
    WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_UNIT_IDENTIFIERS]];
    [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"address = %@",self.about);
    NSLog(@"lastUpdated = %@",self.lastUpdated);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"price = %@",self.price);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"wineUnitIdentifiers = %@",self.wineUnitIdentifiers);
    
    NSLog(@"restaurant = %@",self.restaurant.description);
    
    NSLog(@"wineUnits count = %lu", (unsigned long)[self.wineUnits count]);
    for(NSObject *obj in self.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}

@end
