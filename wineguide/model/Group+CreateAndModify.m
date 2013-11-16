//
//  Group+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/12/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Group+CreateAndModify.h"

#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "WineUnitDataHelper.h"
#import "RestaurantDataHelper.h"
#import "Restaurant.h"

#define GROUP_ENTITY @"Group"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define VERSION @"version"
#define WINE_UNIT_IDENTIFIERS @"wineUnitIdentifiers"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINE_UNITS @"wineUnits"

#define DIVIDER @"/"

@implementation Group (CreateAndModify)

+(Group *)groupFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Group *group = nil;
    
    group = (Group *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:GROUP_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(group){
        
        NSLog(@"placeholder - %@",[dictionary sanitizedStringForKey:IS_PLACEHOLDER]);
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            group.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            group.isPlaceholderForFutureObject = @YES;
            
        } else {
            if([group.version intValue] == 0 || group.version < dictionary[VERSION]){
                // ATTRIBUTES
                
                group.about = [dictionary sanitizedStringForKey:ABOUT];
                group.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
                group.isPlaceholderForFutureObject = @NO;
                // group.lastAccessed
                group.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
                group.name = [dictionary sanitizedStringForKey:NAME];
                group.version = [dictionary sanitizedValueForKey:VERSION];
                
                // store any information about relationships provided
                
                group.restaurantIdentifier = [dictionary sanitizedStringForKey:RESTAURANT_IDENTIFIER];
                group.wineUnitIdentifiers = [group addIdentifiers:[dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS] toCurrentIdentifiers:group.wineUnitIdentifiers];
                
                // RELATIONSHIPS
                // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
                
                // Restaurants
                RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context];
                [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
                
                // WineUnits
                WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context];
                [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
            }
        }
        
        
    }
    
    [group logDetails];
    
    return group;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
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
