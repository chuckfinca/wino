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
#import "RestaurantDataHelper.h"

#define WINE_UNIT_ENTITY @"WineUnit"

#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_SERVER_UPDATE @"lastServerUpdate"
#define DELETED_ENTITY @"deletedEntity"
#define PRICE @"price"
#define QUANTITY @"quantity"
#define VERSION_NUMBER @"versionNumber"

#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"
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
    
    if(!wineUnit.lastServerUpdate || [wineUnit.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            wineUnit.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            wineUnit.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            // ATTRIBUTES
            
            // wineUnit.lastAccessed
            wineUnit.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            wineUnit.isPlaceholderForFutureObject = @NO;
            wineUnit.lastServerUpdate = dictionaryLastUpdatedDate;
            wineUnit.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            wineUnit.price = [dictionary sanitizedValueForKey:PRICE];
            wineUnit.quantity = [dictionary sanitizedStringForKey:QUANTITY];
            wineUnit.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            NSString *restaurantIdentifier = [dictionary sanitizedStringForKey:RESTAURANT_IDENTIFIER];
            wineUnit.restaurantIdentifier = restaurantIdentifier;
            if(restaurantIdentifier) [identifiers setObject:restaurantIdentifier forKey:RESTAURANT_IDENTIFIER];
            
            NSString *wineIdentifier = [dictionary sanitizedStringForKey:WINE_IDENTIFIER];
            wineUnit.wineIdentifier = wineIdentifier;
            if(wineIdentifier) [identifiers setObject:wineIdentifier forKey:WINE_IDENTIFIER];
        }
        
        [wineUnit updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        
    } else if([wineUnit.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
        [wineUnit updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    // [wineUnit logDetails];
    
    return wineUnit;
}

-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // Restaurants
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[RESTAURANT_IDENTIFIER]];
    [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_IDENTIFIER]];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINE inDictionary:dictionary];
}


-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"price = %@",self.price);
    NSLog(@"quantity = %@",self.quantity);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"wineIdentifier = %@",self.wineIdentifier);
    
    NSLog(@"restaurant = %@",self.restaurant);
    
    NSLog(@"wine = %@",self.wine);
    NSLog(@"\n\n\n");
}








@end
