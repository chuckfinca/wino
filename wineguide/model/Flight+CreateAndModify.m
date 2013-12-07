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
#import "WineDataHelper.h"
#import "RestaurantDataHelper.h"
#import "Restaurant.h"

#define FLIGHT_ENTITY @"Flight"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_SERVER_UPDATE @"lastServerUpdate"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define PRICE @"price"
#define VERSION_NUMBER @"versionNumber"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINES @"wines"

#define DIVIDER @"/"

@implementation Flight (CreateAndModify)

+(Flight *)flightFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Flight *flight = nil;
    
    flight = (Flight *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:FLIGHT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [flight lastUpdatedDateFromDictionary:dictionary];
    
    if(!flight.lastServerUpdate || [flight.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            flight.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            flight.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            // ATTRIBUTES
            
            flight.about = [dictionary sanitizedStringForKey:ABOUT];
            flight.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            flight.isPlaceholderForFutureObject = @NO;
            flight.lastServerUpdate = dictionaryLastUpdatedDate;
            flight.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            flight.name = [dictionary sanitizedStringForKey:NAME];
            flight.price = [dictionary sanitizedValueForKey:PRICE];
            flight.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            NSString *restaurantIdentifier = [dictionary sanitizedStringForKey:RESTAURANT_IDENTIFIER];
            flight.restaurantIdentifier = restaurantIdentifier;
            if(restaurantIdentifier) [identifiers setObject:restaurantIdentifier forKey:RESTAURANT_IDENTIFIER];
            
            NSString *wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
            flight.wineIdentifiers = [flight addIdentifiers:wineIdentifiers toCurrentIdentifiers:flight.wineIdentifiers];
            if(wineIdentifiers) [identifiers setObject:wineIdentifiers forKey:WINE_IDENTIFIERS];
        }
        
        [flight updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        
    } else if([flight.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
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
    NSString *restaurantIdentifier = identifiers[RESTAURANT_IDENTIFIER];
    if(restaurantIdentifier){
        RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:restaurantIdentifier];
        [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
    }
    
    // Wines
    NSString *wineIdentifiers = identifiers[WINE_IDENTIFIERS];
    if(wineIdentifiers){
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:wineIdentifiers];
        [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    }
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"address = %@",self.about);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"price = %@",self.price);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"restaurant = %@",self.restaurant.description);
    
    NSLog(@"wines count = %lu", (unsigned long)[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}

@end
