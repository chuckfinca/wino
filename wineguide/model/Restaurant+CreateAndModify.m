//
//  Restaurant+Create.m
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant+CreateAndModify.h"
#import "ManagedObjectHandler.h"

#define ENTITY_NAME @"Restaurant"
#define DELETE_ENTITY @"markForDeletion"
#define NAME @"name"
#define LONGITUDE @"longitude"
#define LATITUDE @"latitude"
#define ADDRESS @"address"
#define CITY @"city"
#define STATE @"state"
#define VERSION @"version"
#define IDENTIFIER @"identifier"
#define WINES @"wines"
#define BRANDS @"brands"
#define VARIETALS @"varietals"

@implementation Restaurant (CreateAndModify)

+(Restaurant *)restaurantWithInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    Restaurant *restaurant = nil;
    
    restaurant = (Restaurant *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:ENTITY_NAME inContext:context usingDictionary:dictionary];
    
    if(restaurant){
        if([restaurant.version intValue] == 0 || restaurant.version < dictionary[VERSION]){
            
            restaurant.markForDeletion = dictionary[DELETE_ENTITY] ? dictionary[DELETE_ENTITY] : @NO;
            restaurant.name = dictionary[NAME];
            restaurant.longitude = dictionary[LONGITUDE];
            restaurant.latitude = dictionary[LATITUDE];
            restaurant.address = dictionary[ADDRESS];
            restaurant.city = dictionary[CITY];
            restaurant.state = dictionary[STATE];
            restaurant.version = dictionary[VERSION];
            restaurant.identifier = dictionary[IDENTIFIER];
        }
    }
    
    return restaurant;
}

@end
