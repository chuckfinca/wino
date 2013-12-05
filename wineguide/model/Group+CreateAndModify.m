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
#define LAST_UPDATED @"lastUpdated"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define VERSION_NUMBER @"versionNumber"
#define WINE_UNIT_IDENTIFIERS @"wineUnitIdentifiers"
#define RESTAURANT_IDENTIFIER @"restaurantIdentifier"

#define WINE_UNITS @"wineUnits"

#define DIVIDER @"/"

@implementation Group (CreateAndModify)

+(Group *)groupFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Group *group = nil;
    
    group = (Group *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:GROUP_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSString *restaurantIdentifier;
    NSString *wineUnitIdentifiers;
    
    NSLog(@"self = %@",self);
    NSLog(@"lastUpdated = %@",group.lastUpdated);
    NSLog(@"dictionary[LAST_UPDATED] = %@",dictionary[LAST_UPDATED]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss Z"];
    NSDate *serverDate = [dateFormatter dateFromString:dictionary[LAST_UPDATED]];
    
    NSLog(@"serverDate = %@",serverDate);
    if(!group.lastUpdated || [group.lastUpdated laterDate:serverDate] == serverDate){
        NSLog(@"inside");
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            group.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            group.isPlaceholderForFutureObject = @YES;
            
        } else {
            // ATTRIBUTES
            
            group.about = [dictionary sanitizedStringForKey:ABOUT];
            group.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            group.isPlaceholderForFutureObject = @NO;
            group.lastUpdated = [NSDate date];
            group.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            group.name = [dictionary sanitizedStringForKey:NAME];
            group.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            restaurantIdentifier = [dictionary sanitizedStringForKey:RESTAURANT_IDENTIFIER];
            group.restaurantIdentifier = restaurantIdentifier;
            
            wineUnitIdentifiers = [dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS];
            group.wineUnitIdentifiers = [group addIdentifiers:wineUnitIdentifiers toCurrentIdentifiers:group.wineUnitIdentifiers];
        }
    }
    
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Restaurants
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context andRelatedObject:group andNeededManagedObjectIdentifiersString:restaurantIdentifier];
    [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
    
    // WineUnits
    WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context andRelatedObject:group andNeededManagedObjectIdentifiersString:wineUnitIdentifiers];
    [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
    
    // [group logDetails];
    
    return group;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"address = %@",self.about);
    NSLog(@"lastUpdated = %@",self.lastUpdated);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"wineUnitIdentifiers = %@",self.wineUnitIdentifiers);
    
    NSLog(@"restaurant = %@",self.restaurant.description);
    
    NSLog(@"wineUnits count = %lu",(unsigned long)[self.wineUnits count]);
    for(NSObject *obj in self.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}


@end
