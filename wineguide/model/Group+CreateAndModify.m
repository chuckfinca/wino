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
#define LAST_SERVER_UPDATE @"lastServerUpdate"
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
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [group lastUpdatedDateFromDictionary:dictionary];
    
    if(!group.lastServerUpdate || [group.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            group.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            group.isPlaceholderForFutureObject = @YES;
            
        } else {
            // ATTRIBUTES
            
            group.about = [dictionary sanitizedStringForKey:ABOUT];
            group.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            group.isPlaceholderForFutureObject = @NO;
            group.lastServerUpdate = dictionaryLastUpdatedDate;
            group.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            group.name = [dictionary sanitizedStringForKey:NAME];
            group.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            NSString *restaurantIdentifier = [dictionary sanitizedStringForKey:RESTAURANT_IDENTIFIER];
            group.restaurantIdentifier = restaurantIdentifier;
            if(restaurantIdentifier) [identifiers setObject:restaurantIdentifier forKey:RESTAURANT_IDENTIFIER];
            
            NSString *wineUnitIdentifiers = [dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS];
            group.wineUnitIdentifiers = [group addIdentifiers:wineUnitIdentifiers toCurrentIdentifiers:group.wineUnitIdentifiers];
            if(wineUnitIdentifiers) [identifiers setObject:wineUnitIdentifiers forKey:WINE_UNIT_IDENTIFIERS];
        }
        
        [group updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        
    } else if([group.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
        [group updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    // [group logDetails];
    
    return group;
}


-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Restaurants
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[RESTAURANT_IDENTIFIER]];
    [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
    
    // WineUnits
    WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_UNIT_IDENTIFIERS]];
    [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"address = %@",self.about);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
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
