//
//  Restaurant+Create.m
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "FlightDataHelper.h"
#import "GroupDataHelper.h"
#import "WineUnitDataHelper.h"


#define RESTAURANT_ENTITY @"Restaurant"

#define ADDED_DATE @"addedDate"
#define ADDRESS @"address"
#define ADDRESS_2 @"address2"
#define CITY @"city"
#define COUNTRY @"country"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_SERVER_UPDATE @"lastServerUpdate"
#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define STATE @"state"
#define ZIP @"zip"

#define FLIGHT_IDENTIFIERS @"flightIdentifiers"
#define GROUP_IDENTIFIERS @"groupIdentifiers"
#define WINE_UNIT_IDENTIFIERS @"wineUnitIdentifiers"

#define FLIGHTS @"flights"
#define GROUPS @"groups"
#define WINE_UNITS @"wineUnits"

#define DIVIDER @"/"






#define RESTAURANT_ADDED_AT @"created_at"
#define RESTAURANT_ADDRESS @"restaurant_street_1"
#define RESTAURANT_ADDRESS_2 @"restaurant_street_2"
#define RESTAURANT_CITY @"restaurant_city"
#define RESTAURANT_COUNTRY @"restaurant_country"
#define RESTAURANT_ID @"id"
#define RESTAURANT_LATITUDE @"restaurant_lat"
#define RESTAURANT_LONGITUDE @"restaurant_lon"
#define RESTAURANT_NAME @"restaurant_name"
#define RESTAURANT_STATE @"restaurant_state"
#define RESTAURANT_ZIP @"restaurant_zip"
#define RESTAURANT_UPDATED_AT @"updated_at"


#define RESTAURANT_IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define RESTAURANT_LAST_SERVER_UPDATE @"lastServerUpdate"
#define RESTAURANT_DELETED_ENTITY @"deletedEntity"


@implementation Restaurant (CreateAndModify)

+(Restaurant *)restaurantFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Restaurant *restaurant = nil;
    
    restaurant = (Restaurant *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:RESTAURANT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [restaurant lastUpdatedDateFromDictionary:dictionary];
    
    if(!restaurant.lastServerUpdate || [restaurant.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        // EXEPTION: user updates a restaurant group on their iPhone and a restaurant flight on their iPad
        // in that case we need to make sure that the server processes the first change first, then the second, and that the device only hears from the server after it's own changes have been registered.
        
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == NO){
            
            // ATTRIBUTES
            restaurant.addedDate = [dictionary sanitizedStringForKey:ADDED_DATE];
            restaurant.address = [dictionary sanitizedStringForKey:ADDRESS];
            restaurant.address2 = [dictionary sanitizedStringForKey:ADDRESS_2];
            restaurant.city = [dictionary sanitizedStringForKey:CITY];
            restaurant.country = [dictionary sanitizedStringForKey:COUNTRY];
            restaurant.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            restaurant.isPlaceholderForFutureObject = @NO;
            restaurant.lastServerUpdate = dictionaryLastUpdatedDate;
            restaurant.latitude = [dictionary sanitizedValueForKey:LATITUDE];
            restaurant.longitude = [dictionary sanitizedValueForKey:LONGITUDE];
            restaurant.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            // restaurant.menuNeedsUpdating - used to notify server that we need to update a specific restaurant's menu.
            restaurant.name = [dictionary sanitizedStringForKey:NAME];
            restaurant.state = [dictionary sanitizedStringForKey:STATE];
            restaurant.zip = [[dictionary sanitizedValueForKey:ZIP] stringValue];
            
            // store any information about relationships provided
            
            NSString *flightIdentifiers = [dictionary sanitizedStringForKey:FLIGHT_IDENTIFIERS];
            restaurant.flightIdentifiers = [restaurant addIdentifiers:flightIdentifiers toCurrentIdentifiers:restaurant.flightIdentifiers];
            if(flightIdentifiers) [identifiers setObject:flightIdentifiers forKey:FLIGHT_IDENTIFIERS];
            
            NSString *groupIdentifiers = [dictionary sanitizedStringForKey:GROUP_IDENTIFIERS];
            restaurant.groupIdentifiers = [restaurant addIdentifiers:groupIdentifiers toCurrentIdentifiers:restaurant.groupIdentifiers];
            if(groupIdentifiers) [identifiers setObject:groupIdentifiers forKey:GROUP_IDENTIFIERS];
            
            NSString *wineUnitIdentifiers = [dictionary sanitizedStringForKey:WINE_UNIT_IDENTIFIERS];
            restaurant.wineUnitIdentifiers = [restaurant addIdentifiers:wineUnitIdentifiers toCurrentIdentifiers:restaurant.wineUnitIdentifiers];
            if(wineUnitIdentifiers) [identifiers setObject:wineUnitIdentifiers forKey:WINE_UNIT_IDENTIFIERS];
            
            
            [restaurant updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
            
        } else {
            // Create placeholder object
            restaurant.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            restaurant.isPlaceholderForFutureObject = @YES;
        }
        
    } else if([restaurant.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
        [restaurant updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    //[restaurant logDetails];
    
    return restaurant;
}

-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON, if not then update the appropriate relationshipIdentifiers attribute
    
    // Flights
    FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[FLIGHT_IDENTIFIERS]];
    [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
    
    // Groupings
    GroupDataHelper *gdh = [[GroupDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[GROUP_IDENTIFIERS]];
    [gdh updateNestedManagedObjectsLocatedAtKey:GROUPS inDictionary:dictionary];
    
    // WineUnits
    WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_UNIT_IDENTIFIERS]];
    [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UNITS inDictionary:dictionary];
}

+(Restaurant *)restaurantFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withAttributes:(NSDictionary *)attributesDictionary
{
    NSLog(@"attributesDictionary------------------------\n = %@", [attributesDictionary allKeys]);
    Restaurant *restaurant = nil;
    
    restaurant = (Restaurant *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:RESTAURANT_ENTITY usingPredicate:predicate inContext:context usingDictionary:attributesDictionary];
    
    
    
    // ATTRIBUTES
    restaurant.addedDate = [attributesDictionary dateAtKey:RESTAURANT_ADDED_AT];
    restaurant.address = [attributesDictionary sanitizedStringForKey:RESTAURANT_ADDRESS];
    restaurant.address2 = [attributesDictionary sanitizedStringForKey:RESTAURANT_ADDRESS_2];
    restaurant.city = [attributesDictionary sanitizedStringForKey:RESTAURANT_CITY];
    restaurant.country = [attributesDictionary sanitizedStringForKey:RESTAURANT_COUNTRY];
    NSLog(@"id string = %@",[attributesDictionary sanitizedStringForKey:RESTAURANT_ID]);
    NSLog(@"id = %@",[attributesDictionary sanitizedValueForKey:RESTAURANT_ID]);
    
    restaurant.identifier = [attributesDictionary sanitizedStringForKey:RESTAURANT_ID];
    //restaurant.identifier = [[attributesDictionary sanitizedValueForKey:RESTAURANT_ID] stringValue];
    NSLog(@"identifier = %@",restaurant.identifier);
    
    restaurant.isPlaceholderForFutureObject = @NO;
    restaurant.latitude = [NSNumber numberWithDouble:[[attributesDictionary sanitizedValueForKey:RESTAURANT_LATITUDE] doubleValue]];
    restaurant.longitude = [NSNumber numberWithDouble:[[attributesDictionary sanitizedValueForKey:RESTAURANT_LONGITUDE] doubleValue]];
    restaurant.deletedEntity = [attributesDictionary sanitizedValueForKey:DELETED_ENTITY];
    // restaurant.menuNeedsUpdating - used to notify server that we need to update a specific restaurant's menu.
    restaurant.name = [attributesDictionary sanitizedStringForKey:RESTAURANT_NAME];
    restaurant.state = [attributesDictionary sanitizedStringForKey:RESTAURANT_STATE];
    restaurant.zip = [attributesDictionary sanitizedValueForKey:RESTAURANT_ZIP];
    
    return restaurant;
    
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"added date = %@",self.addedDate);
    NSLog(@"address = %@",self.address);
    NSLog(@"address 2 = %@",self.address2);
    NSLog(@"city = %@",self.city);
    NSLog(@"country = %@",self.country);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"latitude = %@",self.latitude);
    NSLog(@"longitude = %@",self.longitude);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"menuNeedsUpdating = %@",self.menuNeedsUpdating);
    NSLog(@"name = %@",self.name);
    NSLog(@"state = %@",self.state);
    NSLog(@"zip = %@",self.zip);
    NSLog(@"flightIdentifiers = %@",self.flightIdentifiers);
    NSLog(@"groupIdentifiers = %@",self.groupIdentifiers);
    NSLog(@"wineUnitIdentifiers = %@",self.wineUnitIdentifiers);
    
    NSLog(@"flights count = %lu", (unsigned long)[self.flights count]);
    for(NSObject *obj in self.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groups count = %lu", (unsigned long)[self.groups count]);
    for(NSObject *obj in self.groups){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wineUnits count = %lu",(unsigned long)[self.wineUnits count]);
    for(NSObject *obj in self.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"\n\n\n");
}





@end
