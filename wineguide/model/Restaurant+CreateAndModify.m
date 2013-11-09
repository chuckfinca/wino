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
#import "FlightDataHelper.h"
#import "GroupingDataHelper.h"
#import "WineUnitDataHelper.h"


#define RESTAURANT_ENTITY @"Restaurant"

#define ADDRESS @"address"
#define CITY @"city"
#define COUNTRY @"country"
#define IDENTIFIER @"identifier"
#define LAST_ACCESSED @"lastAccessed"
#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define DELETE_ENTITY @"markForDeletion"
#define NAME @"name"
#define STATE @"state"
#define VERSION @"version"
#define ZIP @"zip"

#define FLIGHT_IDENTIFIERS @"flightidentifiers"
#define GROUP_IDENTIFIERS @"groupidentifiers"
#define WINE_UNIT_IDENTIFIERS @"wineunitidentifiers"

#define FLIGHTS @"flights"
#define GROUPINGS @"groupings"
#define WINE_UINTS @"wineunits"

#define DIVIDER @"/"

@implementation Restaurant (CreateAndModify)

+(Restaurant *)restaurantFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Restaurant *restaurant = nil;
    
    restaurant = (Restaurant *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:RESTAURANT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(restaurant){
        if([restaurant.version intValue] == 0 || restaurant.version < dictionary[VERSION]){
            
            // ATTRIBUTES
            
            restaurant.address = [dictionary sanitizedValueForKey:ADDRESS];
            restaurant.city = [dictionary sanitizedValueForKey:CITY];
            restaurant.country = [dictionary sanitizedValueForKey:COUNTRY];
            restaurant.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            // restaurant.lastAccessed
            restaurant.latitude = [dictionary sanitizedValueForKey:LATITUDE];
            restaurant.longitude = [dictionary sanitizedValueForKey:LONGITUDE];
            restaurant.markForDeletion = [dictionary sanitizedValueForKey:DELETE_ENTITY];
            // restaurant.menuNeedsUpdating - used to notify server that we need to update a specific restaurant's menu.
            restaurant.name = [dictionary sanitizedValueForKey:NAME];
            restaurant.state = [dictionary sanitizedValueForKey:STATE];
            restaurant.version = [dictionary sanitizedValueForKey:VERSION];
            restaurant.zip = [dictionary sanitizedValueForKey:ZIP];
            
            // store any information about relationships provided
            
            [restaurant addIdentifiers:[dictionary sanitizedValueForKey:FLIGHT_IDENTIFIERS] toCurrentIdentifiers:restaurant.flightIdentifiers];
            [restaurant addIdentifiers:[dictionary sanitizedValueForKey:GROUP_IDENTIFIERS] toCurrentIdentifiers:restaurant.groupIdentifiers];
            [restaurant addIdentifiers:[dictionary sanitizedValueForKey:WINE_UNIT_IDENTIFIERS] toCurrentIdentifiers:restaurant.wineUnitIdentifiers];
            
            
            // RELATIONSHIPS
            // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON, if not then update the appropriate relationshipIdentifiers attribute
            
            // Flights
            FlightDataHelper *fdh = [[FlightDataHelper alloc] initWithContext:context];
            fdh.parentManagedObject = restaurant;
            [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
            
            // Groupings
            GroupingDataHelper *gdh = [[GroupingDataHelper alloc] initWithContext:context];
            gdh.parentManagedObject = restaurant;
            [gdh updateNestedManagedObjectsLocatedAtKey:GROUPINGS inDictionary:dictionary];
            
            // Wine Units
            WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:context];
            wudh.parentManagedObject = restaurant;
            [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UINTS inDictionary:dictionary];
        }
    }
    
    [restaurant logDetails];
    
    return restaurant;
}

-(void)addIdentifiers:(NSString *)newIdentifiers toCurrentIdentifiers:(NSString *)currentIdentifiers
{
    if(!currentIdentifiers){
        currentIdentifiers = newIdentifiers;
    } else {
        currentIdentifiers = [currentIdentifiers stringByAppendingString:[NSString stringWithFormat:@"%@%@",DIVIDER,newIdentifiers]];
    }
}


-(NSString *)description
{
    return self.identifier;
}


-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
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
    NSLog(@"wineUnitIdentifiers = %@",self.wineUnitIdentifiers);
    
    NSLog(@"flights count = %i",[self.flights count]);
    for(NSObject *obj in self.flights){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"groupings count = %i",[self.groupings count]);
    for(NSObject *obj in self.groupings){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wineUnits count = %i",[self.wineUnits count]);
    for(NSObject *obj in self.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"\n\n\n");
}











@end
