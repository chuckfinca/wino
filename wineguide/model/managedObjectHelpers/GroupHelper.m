//
//  GroupHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "GroupHelper.h"
#import "Group2+CreateOrModify.h"

#import "RestaurantHelper.h"

#define GROUP_ENTITY @"Group2"

#define SERVER_IDENTIFIER @"id"
#define WINE_ID @"wine_id"
#define RESTAURANT_ID @"restaurant_id"

@implementation GroupHelper

-(NSManagedObject *)findOrCreateObjectWithDictionary:(NSDictionary *)dictionary
{
    Group2 *group = (Group2 *)[self findOrCreateManagedObjectEntityType:GROUP_ENTITY andIdentifier:dictionary[SERVER_IDENTIFIER]];
    [group modifyAttributesWithDictionary:dictionary];
    
    // wine
    NSNumber *wineIdentifier = dictionary[WINE_ID];
    
    // restaurant
    if(self.relatedRestaurant){
        group.restaurant = self.relatedRestaurant;
    } else {
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        group.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ID andIdentifier:dictionary[RESTAURANT_ID]];
    }
    
    return group;
}
@end
