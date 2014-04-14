//
//  WineHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineHelper.h"
#import "Wine2+Modify.h"



#define RESTAURANT_WINE_UNITS @"wine_units"
#define RESTAURANT_GROUPS @"groups"
#define RESTAURANT_FLIGHTS @"flights"


#define WINE_ID @"wine_id"
#define RESTAURANT_ID @"restaurant_id"

@implementation WineHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Wine2 *wine = (Wine2 *)[self findOrCreateManagedObjectEntityType:WINE_ENTITY andIdentifier:dictionary[SERVER_IDENTIFIER]];
    [wine modifyAttributesWithDictionary:dictionary];
    
    // wine
    NSNumber *wineIdentifier = dictionary[WINE_ID];
    
    // restaurant
    /*
    if(self.relatedRestaurant){
        group.restaurant = self.relatedRestaurant;
    } else {
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        group.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ID andIdentifier:dictionary[RESTAURANT_ID]];
    }
     */
    
    return wine;
}



@end
