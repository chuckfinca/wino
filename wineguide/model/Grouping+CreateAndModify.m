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
#import "WineDataHelper.h"
#import "RestaurantDataHelper.h"

#define GROUPING_ENTITY @"Grouping"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define VERSION @"version"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINES @"wines"

#define DIVIDER @"/"

@implementation Grouping (CreateAndModify)

+(Grouping *)groupFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
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
        grouping.wineIdentifiers = [grouping addIdentifiers:[dictionary sanatizedStringForKey:WINE_IDENTIFIERS] toCurrentIdentifiers:grouping.wineIdentifiers];
        
        
        // RELATIONSHIPS
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Restaurants
        RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context];
        rdh.parentManagedObject = restaurant;
        [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
        
        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context];
        wdh.parentManagedObject = grouping;
        [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
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
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"restaurant = %@",self.restaurant.description);
    
    NSLog(@"wines count = %i",[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}


@end
