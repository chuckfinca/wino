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
#import "RestaurantDataHelper.h"

#define FLIGHT_ENTITY @"Flight"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define PRICE @"price"
#define VERSION @"version"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINES @"wines"

#define DIVIDER @"/"

@implementation Flight (CreateAndModify)

+(Flight *)flightFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Flight *flight = nil;
    
    flight = (Flight *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:FLIGHT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(flight){
        
        // ATTRIBUTES
        
        flight.about = [dictionary sanitizedValueForKey:ABOUT];
        flight.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
        // flight.lastAccessed
        flight.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
        flight.name = [dictionary sanitizedValueForKey:NAME];
        flight.price = [dictionary sanitizedValueForKey:PRICE];
        flight.version = [dictionary sanitizedValueForKey:VERSION];
        
        // store any information about relationships provided
        
        flight.restaurantIdentifier = [dictionary sanitizedValueForKey:RESTAURANT_IDENTIFIER];
        [flight addIdentifiers:[dictionary sanitizedValueForKey:WINE_IDENTIFIERS] toCurrentIdentifiers:restaurant.wineUnitIdentifiers];
        
        
        // RELATIONSHIPS
        
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Restaurants
        RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context];
        rdh.parentManagedObject = restaurant;
        [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];

        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context];
        wdh.parentManagedObject = flight;
        [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    }
    
    [flight logDetails];
    
    return flight;
}

-(NSString *)description
{
    return self.identifier;
}

-(void)addIdentifiers:(NSString *)newIdentifiers toCurrentIdentifiers:(NSString *)currentIdentifiers
{
    if(!currentIdentifiers){
        currentIdentifiers = newIdentifiers;
    } else {
        currentIdentifiers = [currentIdentifiers stringByAppendingString:[NSString stringWithFormat:@"%@%@",DIVIDER,newIdentifiers]];
    }
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
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"restaurant = %@",self.restaurant.description);
    
    NSLog(@"wines count = %i",[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}

@end
