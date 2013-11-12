//
//  Grouping+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/4/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Grouping+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "WineUnitDataHelper.h"
#import "RestaurantDataHelper.h"
#import "Restaurant.h"

#define GROUPING_ENTITY @"Grouping"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define VERSION @"version"
#define WINE_UNIT_IDENTIFIERS @"wineUnitIdentifiers"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINE_UNITS @"wineUnits"

#define DIVIDER @"/"

@implementation Grouping (CreateAndModify)

+(Grouping *)groupFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Grouping *grouping = nil;
    
    grouping = (Grouping *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:GROUPING_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(grouping){
        
        // ATTRIBUTES
        
        grouping.about = [dictionary sanatizedStringForKey:ABOUT];
        grouping.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
        // grouping.lastAccessed
        grouping.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
        grouping.name = [dictionary sanatizedStringForKey:NAME];
        grouping.version = [dictionary sanitizedValueForKey:VERSION];
        
        // store any information about relationships provided
        
        grouping.restaurantIdentifier = [dictionary sanatizedStringForKey:RESTAURANT_IDENTIFIER];
        grouping.wineUnitIdentifiers = [grouping addIdentifiers:[dictionary sanatizedStringForKey:WINE_UNIT_IDENTIFIERS] toCurrentIdentifiers:grouping.wineUnitIdentifiers];
        
        
        // RELATIONSHIPS
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Restaurants
        RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context];
        [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
        
        // WineUnits
        WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context];
        [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
    }
    
    // [grouping logDetails];
    
    return grouping;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"address = %@",self.about);
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"name = %@",self.name);
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
