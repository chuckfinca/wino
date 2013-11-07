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
#import "WineDataHelper.h"

#define WINE_UNIT_ENTITY @"WineUnit"

#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define PRICE @"price"
#define QUANTITY @"quantity"
#define VERSION @"version"

#define WINES @"wines"

@implementation WineUnit (CreateAndModify)

+(WineUnit *)wineUnitFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    WineUnit *wineUnit = nil;
    
    wineUnit = (WineUnit *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:WINE_UNIT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(wineUnit){
        
        // ATTRIBUTES
        
        wineUnit.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
        // wineUnit.lastAccessed
        wineUnit.markForDeletion = [dictionary objectForKeyNotNull:MARK_FOR_DELETION];
        wineUnit.price = [dictionary objectForKeyNotNull:PRICE];
        wineUnit.quantity = [dictionary objectForKeyNotNull:QUANTITY];
        wineUnit.version = [dictionary objectForKeyNotNull:VERSION];
        
        
        // RELATIONSHIPS
        
        // Restaurant
        wineUnit.restaurant = restaurant;
        
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] init];
        wdh.restaurant = restaurant;
        wdh.parentManagedObject = wineUnit;
        [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    }
    
    return wineUnit;
}


-(NSString *)description
{
    return self.identifier;
}








@end
