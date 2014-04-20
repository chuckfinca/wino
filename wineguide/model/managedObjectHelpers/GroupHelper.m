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

#define GROUP_RESTAURANT @"restaurant"
#define GROUP_WINES @"wines"

@implementation GroupHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Group2 *group = (Group2 *)[self findOrCreateManagedObjectEntityType:GROUP_ENTITY usingDictionary:dictionary];
    [group modifyAttributesWithDictionary:dictionary];
    
    return group;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Group2 *group = (Group2 *)managedObject;
    
    if([self.relatedObject class] == [Restaurant2 class]){
        group.restaurant = (Restaurant2 *)self.relatedObject;
        
    } else if ([self.relatedObject class] == [Wine2 class]){
        group.wines = [self addRelationToSet:group.wines];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Group2 *group = (Group2 *)managedObject;
    
    // Restaurant
    if(!group.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        [rh processJSON:dictionary[GROUP_RESTAURANT] withRelatedObject:group];
    }
    
    // Wines
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[GROUP_WINES] withRelatedObject:group];
}





@end
