//
//  ReviewHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewHelper.h"
#import "Review2+Modify.h"
#import "TastingRecordHelper.h"
#import "TastingRecord2.h"
#import "UserHelper.h"
#import "User2.h"
#import "WineHelper.h"
#import "Wine2.h"

#define REVIEW_TASTING_RECORD @"asdf"   ///////////////////
#define REVIEW_USER @"asdf"             ///////////////////
#define REVIEW_WINE @"asdf"             ///////////////////

@implementation ReviewHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Review2 *review = (Review2 *)[self findOrCreateManagedObjectEntityType:REVIEW_ENTITY andIdentifier:dictionary[ID_KEY]];
    [review modifyAttributesWithDictionary:dictionary];
    
    return review;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Review2 *review = (Review2 *)managedObject;
    
    if([self.relatedObject class] == [TastingRecord2 class]){
        review.tastingRecord = (TastingRecord2 *)self.relatedObject;
        
    } else if([self.relatedObject class] == [User2 class]){
        review.user = (User2 *)self.relatedObject;
        
    } else if([self.relatedObject class] == [Wine2 class]){
        review.wine = (Wine2 *)self.relatedObject;
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Review2 *review = (Review2 *)managedObject;
    
    // tasting record
    if(!review.tastingRecord){
        TastingRecordHelper *rh = [[TastingRecordHelper alloc] init];
        review.tastingRecord  = (TastingRecord2 *)[rh findOrCreateManagedObjectEntityType:TASTING_RECORD_ENTITY andIdentifier:dictionary[RESTAURANT_ID]];
    }
    
    // user
    if(!review.user){
        UserHelper *rh = [[UserHelper alloc] init];
        review.user  = (User2 *)[rh findOrCreateManagedObjectEntityType:USER_ENTITY andIdentifier:dictionary[REVIEW_USER]];
    }
    
    // wine
    if(!review.wine){
        WineHelper *rh = [[WineHelper alloc] init];
        review.wine  = (Wine2 *)[rh findOrCreateManagedObjectEntityType:WINE_ENTITY andIdentifier:dictionary[REVIEW_WINE]];
    }
    
}











@end











