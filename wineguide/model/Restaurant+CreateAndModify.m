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

#define FLIGHTS @"flights"
#define GROUPINGS @"groupings"
#define WINE_UINTS @"wineUnits"

@implementation Restaurant (CreateAndModify)

+(Restaurant *)restaurantFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Restaurant *restaurant = nil;
    
    restaurant = (Restaurant *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:RESTAURANT_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(restaurant){
        if([restaurant.version intValue] == 0 || restaurant.version < dictionary[VERSION]){
            
            // ATTRIBUTES
            
            restaurant.address = [dictionary objectForKeyNotNull:ADDRESS];
            restaurant.city = [dictionary objectForKeyNotNull:CITY];
            restaurant.country = [dictionary objectForKeyNotNull:COUNTRY];
            restaurant.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
            // restaurant.lastAccessed
            restaurant.latitude = [dictionary objectForKeyNotNull:LATITUDE];
            restaurant.longitude = [dictionary objectForKeyNotNull:LONGITUDE];
            restaurant.markForDeletion = [dictionary objectForKeyNotNull:DELETE_ENTITY];
            // restaurant.menuNeedsUpdating - used to notify server that we need to update a specific restaurant's menu.
            restaurant.name = [dictionary objectForKeyNotNull:NAME];
            restaurant.state = [dictionary objectForKeyNotNull:STATE];
            restaurant.version = [dictionary objectForKeyNotNull:VERSION];
            restaurant.zip = [dictionary objectForKeyNotNull:ZIP];
            
            
            // RELATIONSHIPS
            // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON, if not then update the appropriate relationshipIdentifiers attribute
            
            // Flights
            FlightDataHelper *fdh = [[FlightDataHelper alloc] init];
            fdh.parentManagedObject = restaurant;
            [fdh updateNestedManagedObjectsLocatedAtKey:FLIGHTS inDictionary:dictionary];
            
            // Groupings
            GroupingDataHelper *gdh = [[GroupingDataHelper alloc] init];
            gdh.parentManagedObject = restaurant;
            [gdh updateNestedManagedObjectsLocatedAtKey:GROUPINGS inDictionary:dictionary];
            
            // Wine Units
            WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] init];
            wudh.parentManagedObject = restaurant;
            [wudh updateNestedManagedObjectsLocatedAtKey:WINE_UINTS inDictionary:dictionary];
        }
    }
    return restaurant;
}

-(NSString *)description
{
    return self.identifier;
}














@end
