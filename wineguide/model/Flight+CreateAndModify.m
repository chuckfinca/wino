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
#import "WineDataHelper.h"

#define FLIGHT_ENTITY @"Flight"

#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define PRICE @"price"
#define VERSION @"version"

#define WINES @"wines"

@implementation Flight (CreateAndModify)

+(Flight *)flightFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Flight *flight = nil;
    
    flight = (Flight *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:FLIGHT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(flight){
        
        // ATTRIBUTES
        
        flight.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
        // flight.lastAccessed
        flight.markForDeletion = [dictionary objectForKeyNotNull:MARK_FOR_DELETION];
        flight.name = [dictionary objectForKeyNotNull:NAME];
        flight.price = [dictionary objectForKeyNotNull:PRICE];
        flight.version = [dictionary objectForKeyNotNull:VERSION];
        
        
        // RELATIONSHIPS
        
        // Restaurants
        flight.restaurant = restaurant;
        
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON

        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] init];
        wdh.restaurant = restaurant;
        wdh.parentManagedObject = flight;
        [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    }
    
    return flight;
}

@end
