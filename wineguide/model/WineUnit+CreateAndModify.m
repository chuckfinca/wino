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
#define MARK_FOR_DELETION @"markForDeletion"
#define PRICE @"price"
#define QUANTITY @"quantity"
#define VERSION @"version"
#define WINE_IDENTIFIER @"wineIdentifier"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINES @"wines"

#define DIVIDER @"/"

@implementation WineUnit (CreateAndModify)

+(WineUnit *)wineUnitFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
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
        
        wineUnit.restaurantIdentifier = [dictionary sanatizedStringForKey:RESTAURANT_IDENTIFIER];
        wineUnit.wineIdentifier = [dictionary sanatizedStringForKey:WINE_IDENTIFIER];
        
        
        // RELATIONSHIPS
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Restaurants
        RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context];
        rdh.parentManagedObject = restaurant;
        [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
        
        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context];
        wdh.parentManagedObject = wineUnit;
        [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    }
    
    // [wineUnit logDetails];
    
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
    NSLog(@"wineIdentifier = %@",self.wineIdentifier);
    
    NSLog(@"restaurant = %@",self.restaurant.description);
    
    NSLog(@"wine = %@",self.wine);
    NSLog(@"\n\n\n");
}








@end
