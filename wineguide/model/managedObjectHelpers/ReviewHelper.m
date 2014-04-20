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

#define REVIEW_TASTING_RECORD @"tasting_record"     ///////////////////
#define REVIEW_USER @"user"                         ///////////////////

@implementation ReviewHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Review2 *review = (Review2 *)[self findOrCreateManagedObjectEntityType:REVIEW_ENTITY usingDictionary:dictionary];
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
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Review2 *review = (Review2 *)managedObject;
    
    // Tasting Record
    if(!review.tastingRecord){
        TastingRecordHelper *rh = [[TastingRecordHelper alloc] init];
        [rh processJSON:dictionary[REVIEW_TASTING_RECORD] withRelatedObject:review];
    }
    
    // User
    if(!review.user){
        UserHelper *uh = [[UserHelper alloc] init];
        [uh processJSON:dictionary[REVIEW_USER] withRelatedObject:review];
    }
    
}











@end











