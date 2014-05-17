//
//  GroupHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "GroupHelper.h"
#import "Group2+CreateOrModify.h"
#import "WineList.h"
#import "WineListHelper.h"
#import "WineHelper.h"
#import "Wine2.h"

#define GROUP_WINE_LIST @"wine_list"
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
    
    if([self.relatedObject class] == [WineList class]){
        group.wineList = (WineList *)self.relatedObject;
        
    } else if ([self.relatedObject class] == [Wine2 class]){
        group.wines = [self addRelationToSet:group.wines];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Group2 *group = (Group2 *)managedObject;
    
    // Restaurant
    if(!group.wineList){
        WineListHelper *wlh = [[WineListHelper alloc] init];
        [wlh processJSON:dictionary[GROUP_WINE_LIST] withRelatedObject:group];
    }
    
    // Wines
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[GROUP_WINES] withRelatedObject:group];
}





@end
