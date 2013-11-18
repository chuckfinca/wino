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
#import "GroupingDataHelper.h"
#import "WineUnitDataHelper.h"


#define RESTAURANT_ENTITY @"Restaurant"

#define ADDRESS @"address"
#define CITY @"city"
#define COUNTRY @"country"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_ACCESSED @"lastAccessed"
#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define DELETE_ENTITY @"markForDeletion"
#define NAME @"name"
#define STATE @"state"
#define VERSION @"version"
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
    
    if(restaurant){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            //NSLog(@"placeholder - %@",[dictionary sanitizedStringForKey:IDENTIFIER]);
            
            restaurant.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            restaurant.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            if([restaurant.version intValue] == 0 || restaurant.version < dictionary[VERSION]){
                
                // ATTRIBUTES
                
                restaurant.address = [dictionary sanitizedStringForKey:ADDRESS];
                restaurant.city = [dictionary sanitizedStringForKey:CITY];
                restaurant.country = [dictionary sanitizedStringForKey:COUNTRY];
                restaurant.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
                restaurant.isPlaceholderForFutureObject = @NO;
                // restaurant.lastAccessed
                restaurant.latitude = [dictionary sanitizedValueForKey:LATITUDE];
                restaurant.longitude = [dictionary sanitizedValueForKey:LONGITUDE];
                restaurant.markForDeletion = [dictionary sanitizedValueForKey:DELETE_ENTITY];
                // restaurant.menuNeedsUpdating - used to notify server that we need to update a specific restaurant's menu.
                restaurant.name = [dictionary sanitizedStringForKey:NAME];
                restaurant.state = [dictionary sanitizedStringForKey:STATE];
                restaurant.version = [dictionary sanitizedValueForKey:VERSION];
                restaurant.zip = [[dictionary sanitizedValueForKey:ZIP] stringValue];
                
                // store any information about relationships provided
                
                NSString *flightIdentifiers = [dictionary sanitizedStringForKey:FLIGHT_IDENTIFIERS];
                restaurant.flightIdentifiers = [restaurant addIdentifiers:flightIdentifiers toCurrentIdentifiers:restaurant.flightIdentifiers];
                
                NSString *groupIdentifiers = [dictionary sanitizedStringForKey:GROUP_IDENTIFIERS];
                restaurant.groupIdentifiers = [restaurant addIdentifiers:groupIdentifiers toCurrentIdentifiers:restaurant.groupIdentifiers];
                
                
                // RELATIONSHIPS
                // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON, if not then update the appropriate relationshipIdentifiers attribute
                
                // Flights
                FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context];
                [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
                
                // Groupings
                GroupingDataHelper *gdh = [[GroupingDataHelper alloc] initWithContext:context];
                [gdh updateNestedManagedObjectsLocatedAtKey:GROUPS inDictionary:dictionary];
            }
        }
    }
    
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
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"latitude = %@",self.latitude);
    NSLog(@"longitude = %@",self.longitude);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"menuNeedsUpdating = %@",self.menuNeedsUpdating);
    NSLog(@"name = %@",self.name);
    NSLog(@"state = %@",self.state);
    NSLog(@"version = %@",self.version);
    NSLog(@"zip = %@",self.zip);
    NSLog(@"flightIdentifiers = %@",self.flightIdentifiers);
    NSLog(@"groupIdentifiers = %@",self.groupIdentifiers);
    
    NSLog(@"flights count = %i",[self.flights count]);
    for(NSObject *obj in self.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groupings count = %i",[self.groups count]);
    for(NSObject *obj in self.groups){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"\n\n\n");
}





@end
