//
//  ReviewObjectHandler.h
//  Corkie
//
//  Created by Charles Feinn on 3/26/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ManagedObjectHandler.h"
#import "Review.h"

@interface ReviewObjectHandler : ManagedObjectHandler

+(Review *)createReviewWithIdentifier:(NSString *)identifier rating:(NSNumber *)rating date:(NSDate *)date wine:(Wine *)wine ReviewText:(NSString *)reviewText andUser:(User *)user whoHasClaimedTheReview:(BOOL)hasClaimed;

+(NSString *)reviewIdentifierFromUser:(User *)user andDate:(NSDate *)date;

@end
