//
//  Review+CreateAndModify.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Review+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSManagedObject+Helper.h"
#import "NSDictionary+Helper.h"

#define REVIEW_ENTITY @"Review"

#define ADDED_DATE @"addedDate"
#define CLAIMED_BY_USER @"claimedByUser"
#define DELETED_ENTITY @"deletedEntity"
#define IDENTIFIER @"identifier"
#define RATING @"rating"
#define REVIEW_TEXT @"reviewText"
#define REVIEW_DATE @"reviewDate"
#define UPDATED_DATE @"updatedDate"
#define RESTAURANT @"restaurant"

@implementation Review (CreateAndModify)

+(Review *)foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Review *review = (Review *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:REVIEW_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSDate *updatedDate = [review lastUpdatedDateFromDictionary:dictionary];
    
    if(!review.addedDate || [review.updatedDate laterDate:updatedDate] == updatedDate){
        
        NSDate *addedDate = [review dateFromObj:dictionary[ADDED_DATE]];
        if(addedDate){
            review.addedDate = addedDate;
        } else {
            review.addedDate = updatedDate;
        }
        
        NSNumber *claimed = [dictionary sanitizedValueForKey:CLAIMED_BY_USER];
        review.claimedByUser = claimed;
        review.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
        review.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
        review.rating = [dictionary sanitizedValueForKey:RATING];
        
        NSDate *reviewDate = [review dateFromObj:dictionary[REVIEW_DATE]];
        if(reviewDate){
            review.reviewDate = reviewDate;
        } else if(!review.reviewDate && [claimed boolValue] == YES){
            review.reviewDate = updatedDate;
        }
        
        review.reviewText = [dictionary sanitizedStringForKey:REVIEW_TEXT];
        review.updatedDate = updatedDate;
    }
    
    [review logDetails];
    
    return review;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"added date = %@",self.addedDate);
    NSLog(@"claimedByUser = %@",self.claimedByUser);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"rating = %@",self.rating);
    NSLog(@"reviewDate = %@",self.reviewDate);
    NSLog(@"reviewText = %@",self.reviewText);
    NSLog(@"updatedDate = %@",self.updatedDate);
    
    
    NSLog(@"\n\n\n");
}





@end
