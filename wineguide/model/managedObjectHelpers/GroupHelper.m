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
#import "Restaurant2.h"
#import "WineHelper.h"
#import "Wine2.h"

#define GROUP_RESTAURANT_ID @"restaurant_id"
#define GROUP_WINES @"wines"

@implementation GroupHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Group2 *group = (Group2 *)[self findOrCreateManagedObjectEntityType:GROUP_ENTITY andIdentifier:dictionary[SERVER_IDENTIFIER]];
    [group modifyAttributesWithDictionary:dictionary];
    
    
    // restaurant
    
    
    // wine
    NSArray *wineDictionariesArray = dictionary[GROUP_WINES];
    
    for(NSDictionary *wineDictionary in wineDictionariesArray){
        WineHelper *wh = [[WineHelper alloc] init];
        Wine2 *wine = (Wine2 *)[wh findOrCreateManagedObjectEntityType:WINE_ENTITY andIdentifier:wineDictionary[SERVER_IDENTIFIER]];
    }
    
    return group;
}



@end
