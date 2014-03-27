//
//  ReviewObjectHandler.m
//  Corkie
//
//  Created by Charles Feinn on 3/26/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewObjectHandler.h"
#import "Wine.h"
#import "Restaurant.h"
#import "User.h"

#define IDENTIFIER @"identifier"
#define DELETED_ENTITY @"deletedEntity"

@implementation ReviewObjectHandler

+(Review *)createClaimed:(BOOL)claimed reviewWithDate:(NSDate *)date user:(User *)user wine:(Wine *)wine rating:(NSNumber *)rating andReviewText:(NSString *)reviewText
{
    NSString *dateString = [date.description stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *userIdentifier = user.identifier;
    NSString *identifier = [NSString stringWithFormat:@"%@%@",dateString,userIdentifier];
    NSPredicate *reviewPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    
    Review *review = nil;
    review = (Review *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:@"Review" usingPredicate:reviewPredicate inContext:wine.managedObjectContext usingDictionary:@{IDENTIFIER : identifier, DELETED_ENTITY : @0}];
    
    review.identifier = identifier;
    review.rating = rating;
    review.lastLocalUpdate = date;
    review.wine = wine;
    review.reviewText = reviewText;
    
    review.user = user;
    review.claimedByUser = @(claimed);
    
    return review;
}








@end
