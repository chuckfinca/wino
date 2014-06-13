//
//  LocalReviewCreator.m
//  Corkie
//
//  Created by Charles Feinn on 6/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "LocalReviewCreator.h"
#import "ReviewHelper.h"

#define RATING @"rating"
#define REVIEW_TEXT @"review_text"

@implementation LocalReviewCreator


-(Review2 *)createClaimed:(BOOL)claimed reviewForUser:(User2 *)user withReviewText:(NSString *)reviewText rating:(float)rating andCreationDate:(NSDate *)creationDate
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    // Need better identifier
    NSNumber *identifier = [NSNumber numberWithInteger:-arc4random_uniform(1000000000)+1];
    
    [dictionary setObject:identifier forKey:ID_KEY];
    [dictionary setObject:creationDate forKey:CREATED_AT];
    [dictionary setObject:@(claimed) forKey:CLAIMED_BY_USER];
    
    if(reviewText){
        [dictionary setObject:reviewText forKey:REVIEW_TEXT];
    }
    if(rating > 0){
        [dictionary setObject:@(rating) forKey:RATING];
    }
    
    ReviewHelper *rdh = [[ReviewHelper alloc] init];
    Review2 *review = (Review2 *)[rdh createObjectFromDictionary:dictionary];
    review.user = user;
    return review;
}


@end
