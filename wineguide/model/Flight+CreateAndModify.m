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
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define PRICE @"price"
#define VERSION @"version"
#define WINE_UNIT_IDENTIFIERS @"wineUnitIdentifiers"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINE_UNITS @"wineUnits"

#define DIVIDER @"/"

@implementation Flight (CreateAndModify)

+(Flight *)flightFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Flight *flight = nil;
    
    flight = (Flight *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:FLIGHT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(flight){
        
        // ATTRIBUTES
        
        flight.about = [dictionary sanitizedStringForKey:ABOUT];
        flight.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
        // flight.lastAccessed
        flight.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
        flight.name = [dictionary sanitizedStringForKey:NAME];
        flight.price = [dictionary sanitizedValueForKey:PRICE];
        flight.version = [dictionary sanitizedValueForKey:VERSION];
        
        // store any information about relationships provided
        
        flight.restaurantIdentifier = [dictionary sanitizedStringForKey:RESTAURANT_IDENTIFIER];
        flight.wineUnitIdentifiers = [flight addIdentifiers:[dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS] toCurrentIdentifiers:flight.wineUnitIdentifiers];
        
        
        // RELATIONSHIPS
        
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Restaurants
        RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context];
        [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];

        // WineUnits
        WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context];
        [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
    }
    
    // [flight logDetails];
    
    return flight;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"address = %@",self.about);
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"name = %@",self.name);
    NSLog(@"price = %@",self.price);
    NSLog(@"version = %@",self.version);
    NSLog(@"wineUnitIdentifiers = %@",self.wineUnitIdentifiers);
    
    NSLog(@"restaurant = %@",self.restaurant.description);
    
    NSLog(@"wineUnits count = %i",[self.wineUnits count]);
    for(NSObject *obj in self.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}

@end
