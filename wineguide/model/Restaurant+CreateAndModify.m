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

#define ADDRESS @"address"
#define CITY @"city"
#define COUNTRY @"country"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_UPDATED @"lastUpdated"
#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define STATE @"state"
#define VERSION_NUMBER @"versionNumber"
#define ZIP @"zip"

#define FLIGHT_IDENTIFIERS @"flightIdentifiers"
#define GROUP_IDENTIFIERS @"groupIdentifiers"

#define FLIGHTS @"flights"
#define GROUPS @"groups"

#define DIVIDER @"/"

@implementation Restaurant (CreateAndModify)

+(Restaurant *)restaurantFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Restaurant *restaurant = nil;
    
    restaurant = (Restaurant *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:RESTAURANT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSString *flightIdentifiers;
    NSString *groupIdentifiers;
    NSLog(@"self = %@",self);
    NSLog(@"date = %@",[NSDate date]);
    NSLog(@"lastUpdated = %@",restaurant.lastUpdated);
    NSLog(@"dictionary[LAST_UPDATED] = %@",dictionary[LAST_UPDATED]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss Z"];
    NSDate *serverDate = [dateFormatter dateFromString:dictionary[LAST_UPDATED]];
    
    NSLog(@"serverDate = %@",serverDate);
    if(!restaurant.lastUpdated || [restaurant.lastUpdated laterDate:serverDate] == serverDate){
        NSLog(@"inside");
        
        // ATTRIBUTES
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            restaurant.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            restaurant.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            restaurant.address = [dictionary sanitizedStringForKey:ADDRESS];
            restaurant.city = [dictionary sanitizedStringForKey:CITY];
            restaurant.country = [dictionary sanitizedStringForKey:COUNTRY];
            restaurant.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            restaurant.isPlaceholderForFutureObject = @NO;
            restaurant.lastUpdated = [NSDate date];
            restaurant.latitude = [dictionary sanitizedValueForKey:LATITUDE];
            restaurant.longitude = [dictionary sanitizedValueForKey:LONGITUDE];
            restaurant.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            // restaurant.menuNeedsUpdating - used to notify server that we need to update a specific restaurant's menu.
            restaurant.name = [dictionary sanitizedStringForKey:NAME];
            restaurant.state = [dictionary sanitizedStringForKey:STATE];
            restaurant.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            restaurant.zip = [[dictionary sanitizedValueForKey:ZIP] stringValue];
            
            // store any information about relationships provided
            
            flightIdentifiers = [dictionary sanitizedStringForKey:FLIGHT_IDENTIFIERS];
            restaurant.flightIdentifiers = [restaurant addIdentifiers:flightIdentifiers toCurrentIdentifiers:restaurant.flightIdentifiers];
            
            groupIdentifiers = [dictionary sanitizedStringForKey:GROUP_IDENTIFIERS];
            restaurant.groupIdentifiers = [restaurant addIdentifiers:groupIdentifiers toCurrentIdentifiers:restaurant.groupIdentifiers];
        }
    }
    
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON, if not then update the appropriate relationshipIdentifiers attribute
    
    // Flights
    FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context andRelatedObject:restaurant andNeededManagedObjectIdentifiersString:flightIdentifiers];
    [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
    
    // Groupings
    GroupDataHelper *gdh = [[GroupDataHelper alloc] initWithContext:context andRelatedObject:restaurant andNeededManagedObjectIdentifiersString:groupIdentifiers];
    [gdh updateNestedManagedObjectsLocatedAtKey:GROUPS inDictionary:dictionary];
    
    //[restaurant logDetails];
    
    return restaurant;
}


-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"address = %@",self.address);
    NSLog(@"city = %@",self.city);
    NSLog(@"country = %@",self.country);
    NSLog(@"lastUpdated = %@",self.lastUpdated);
    NSLog(@"latitude = %@",self.latitude);
    NSLog(@"longitude = %@",self.longitude);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"menuNeedsUpdating = %@",self.menuNeedsUpdating);
    NSLog(@"name = %@",self.name);
    NSLog(@"state = %@",self.state);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"zip = %@",self.zip);
    NSLog(@"flightIdentifiers = %@",self.flightIdentifiers);
    NSLog(@"groupIdentifiers = %@",self.groupIdentifiers);
    
    NSLog(@"flights count = %lu", (unsigned long)[self.flights count]);
    for(NSObject *obj in self.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groupings count = %lu", (unsigned long)[self.groups count]);
    for(NSObject *obj in self.groups){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"\n\n\n");
}





@end
