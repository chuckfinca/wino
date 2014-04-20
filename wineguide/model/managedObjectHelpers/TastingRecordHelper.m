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
#import "ReviewHelper.h"
#import "Review2.h"

#define TASTING_RECORD_RESTAURANT @"tasting_record_restaurant"  ///////////////////
#define TASTING_RECORD_REVIEWS @"tasting_record_reviews"        ///////////////////

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
        
    } else if([self.relatedObject class] == [Review2 class]){
        tastingRecord.reviews = [self addRelationToSet:tastingRecord.reviews];
        
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    TastingRecord2 *tastingRecord = (TastingRecord2 *)managedObject;
    
    // Restaurant
    if(!tastingRecord.restaurant){
        RestaurantHelper *rh = [[RestaurantHelper alloc] init];
        tastingRecord.restaurant = (Restaurant2 *)[rh findOrCreateManagedObjectEntityType:RESTAURANT_ENTITY andIdentifier:dictionary[TASTING_RECORD_RESTAURANT]];
    }
    
    ReviewHelper *rh = [[ReviewHelper alloc] init];
    [rh processJSON:dictionary[TASTING_RECORD_REVIEWS] withRelatedObject:tastingRecord];
}














@end








