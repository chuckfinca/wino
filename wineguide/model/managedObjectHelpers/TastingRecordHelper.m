//
//  TastingRecordHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecordHelper.h"
#import "TastingRecord2+Modify.h"
#import "RestaurantHelper.h"
#import "Restaurant2.h"

@implementation TastingRecordHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    TastingRecord2 *tastingRecord = (TastingRecord2 *)[self findOrCreateManagedObjectEntityType:TASTING_RECORD_ENTITY andIdentifier:dictionary[ID_KEY]];
    [tastingRecord modifyAttributesWithDictionary:dictionary];
    
    return tastingRecord;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    TastingRecord2 *tastingRecord = (TastingRecord2 *)managedObject;
    
    if([self.relatedObject class] == [Restaurant2 class]){
        tastingRecord.restaurant = (Restaurant2 *)self.relatedObject;
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    TastingRecord2 *tastingRecord = (TastingRecord2 *)managedObject;
    
    // Restaurant
    if(!tastingRecord.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        tastingRecord.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[RESTAURANT_ID]];
    }
}














@end








