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
    Group2 *group = (Group2 *)[self findOrCreateManagedObjectEntityType:GROUP_ENTITY andIdentifier:dictionary[ID_KEY]];
    [group modifyAttributesWithDictionary:dictionary];
    
    return group;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Group2 class]]){
        Group2 *group = (Group2 *)managedObject;
        
        if([self.relatedObject class] == [Restaurant2 class]){
            group.restaurant = (Restaurant2 *)self.relatedObject;
            
        } else if ([self.relatedObject class] == [Wine2 class]){
            group.wines = [self addRelationToSet:group.wines];
        }
    }
}

-(void)addAdditionalRelativesToManagedObject:(NSManagedObject *)managedObject fromDictionary:(NSDictionary *)dictionary
{
    Group2 *group = (Group2 *)managedObject;
    
    // restaurant
    if(!group.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        group.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[RESTAURANT_ID]];
    }
    
    NSArray *winesArray = dictionary[GROUP_WINES];
    WineHelper *wu = [[WineHelper alloc] init];
    NSSet *wineSet = [self toManyRelationshipSetCreatedFromDictionariesArray:winesArray usingHelper:wu relatedObjectEntityType:WINE_ENTITY];
}





@end
