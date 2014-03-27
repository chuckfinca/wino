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

+(Review *)createClaimed:(BOOL)claimed reviewWithDate:(NSDate *)date user:(User *)user wine:(Wine *)wine rating:(NSNumber *)rating andReviewText:(NSString *)reviewText;

@end
