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
    
    NSString *restaurantIdentifier;
    NSString *wineUnitIdentifiers;
    
    NSLog(@"self = %@",self);
    NSLog(@"lastUpdated = %@",flight.lastUpdated);
    NSLog(@"dictionary[LAST_UPDATED] = %@",dictionary[LAST_UPDATED]);
    
    NSDate *serverDate = [dictionary dateFromString:dictionary[LAST_UPDATED]];
    
    NSLog(@"serverDate = %@",serverDate);
    if(!flight.lastUpdated || [flight.lastUpdated laterDate:serverDate] == serverDate){
        NSLog(@"inside");
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            flight.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            flight.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            // ATTRIBUTES
            
            flight.about = [dictionary sanitizedStringForKey:ABOUT];
            flight.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            flight.isPlaceholderForFutureObject = @NO;
            flight.lastUpdated = [NSDate date];
            flight.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            flight.name = [dictionary sanitizedStringForKey:NAME];
            flight.price = [dictionary sanitizedValueForKey:PRICE];
            flight.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            restaurantIdentifier = [dictionary sanitizedStringForKey:RESTAURANT_IDENTIFIER];
            flight.restaurantIdentifier = restaurantIdentifier;
            
            wineUnitIdentifiers = [dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS];
            flight.wineUnitIdentifiers = [flight addIdentifiers:wineUnitIdentifiers toCurrentIdentifiers:flight.wineUnitIdentifiers];
        }
    }
    
    // RELATIONSHIPS
    
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Restaurants
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context andRelatedObject:flight andNeededManagedObjectIdentifiersString:restaurantIdentifier];
    [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
    
    // WineUnits
    WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context andRelatedObject:flight andNeededManagedObjectIdentifiersString:wineUnitIdentifiers];
    [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
    
    // [flight logDetails];
    
    return flight;
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
