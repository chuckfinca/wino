//
//  RestaurantHelper.m
//  Corkie
//
//  Created by Charles Feinn on 2/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RestaurantHelper.h"
#import "Restaurant2+CreateOrModify.h"
#import "WineList.h"
#import "WineListHelper.h"
#import "TastingRecordHelper.h"
#import "TastingRecord2.h"

#define RESTAURANT_WINE_LIST @"wine_list"
#define RESTAURANT_TASTING_RECORDS @"tasting_records"  ////////////////////////

@implementation RestaurantHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Restaurant2 *restaurant = (Restaurant2 *)[self findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY usingDictionary:dictionary];
    [restaurant modifyAttributesWithDictionary:dictionary];
    
    return restaurant;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Restaurant2 *restaurant = (Restaurant2 *)managedObject;
    
    if([self.relatedObject class] == [WineList class]){
        restaurant.wineList = (WineList *)self.relatedObject;
        
    } else if ([self.relatedObject class] == [TastingRecord2 class]){
        restaurant.tastingRecords = [self addRelationToSet:restaurant.tastingRecords];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Restaurant2 *restaurant = (Restaurant2 *)managedObject;
    
    // Wine List
    WineListHelper *wlh = [[WineListHelper alloc] init];
    [wlh processJSON:dictionary[RESTAURANT_WINE_LIST] withRelatedObject:restaurant];
    
    // Tasting Records
    TastingRecordHelper *trh = [[TastingRecordHelper alloc] init];
    [trh processJSON:dictionary[RESTAURANT_TASTING_RECORDS] withRelatedObject:restaurant];
}




















@end
