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
#import "WineHelper.h"
#import "Wine2.h"

#define TASTING_RECORD_RESTAURANT @"restaurant"  
#define TASTING_RECORD_REVIEWS @"reviews"
#define TASTING_RECORD_WINE @"wine"

@implementation TastingRecordHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    TastingRecord2 *tastingRecord = (TastingRecord2 *)[self findOrCreateManagedObjectEntityType:TASTING_RECORD_ENTITY usingDictionary:dictionary];
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
        [rh processJSON:dictionary[TASTING_RECORD_RESTAURANT] withRelatedObject:tastingRecord];
    }
    if(!tastingRecord.wine){
        WineHelper *wh = [[WineHelper alloc] init];
        [wh processJSON:dictionary[TASTING_RECORD_WINE] withRelatedObject:tastingRecord];
    }
    
    ReviewHelper *rvh = [[ReviewHelper alloc] init];
    [rvh processJSON:dictionary[TASTING_RECORD_REVIEWS] withRelatedObject:tastingRecord];
}














@end








