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

+(Review *)createReviewWithIdentifier:(NSString *)identifier rating:(NSNumber *)rating date:(NSDate *)date wine:(Wine *)wine ReviewText:(NSString *)reviewText andUser:(User *)user whoHasClaimedTheReview:(BOOL)hasClaimed
{
    NSPredicate *reviewPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    
    Review *review = nil;
    review = (Review *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:@"Review" usingPredicate:reviewPredicate inContext:wine.managedObjectContext usingDictionary:@{IDENTIFIER : identifier, DELETED_ENTITY : @0}];
    
    review.identifier = identifier;
    review.rating = rating;
    review.lastLocalUpdate = date;
    review.wine = wine;
    review.reviewText = reviewText;
    
    review.user = user;
    review.claimedByUser = @(hasClaimed);
    
    return review;
}

+(NSString *)reviewIdentifierFromUser:(User *)user andDate:(NSDate *)date
{
    NSString *dateString = [date.description stringByReplacingOccurrencesOfString:@" " withString:@"" ];
    NSString *userIdentifier = user.identifier;
    
    return [NSString stringWithFormat:@"%@%@",dateString,userIdentifier];
}

@end
