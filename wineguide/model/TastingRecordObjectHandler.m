//
//  TastingRecordObjectHandler.m
//  Corkie
//
//  Created by Charles Feinn on 3/26/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecordObjectHandler.h"
#import "ReviewObjectHandler.h"
#import "User.h"
#import "Wine.h"

#define IDENTIFIER @"identifier"
#define DELETED_ENTITY @"deletedEntity"

@implementation TastingRecordObjectHandler

+(TastingRecord *)createTastingRecordWithIdentifier:(NSString *)identifier tastingDate:(NSDate *)tastingDate review:(Review *)review restaurant:(Restaurant *)restaurant andFriends:(NSArray *)friendsArray
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    
    TastingRecord *tastingRecord = nil;
    tastingRecord = (TastingRecord *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:@"TastingRecord" usingPredicate:predicate inContext:review.managedObjectContext usingDictionary:@{IDENTIFIER : identifier, DELETED_ENTITY : @0}];
    
    tastingRecord.identifier = identifier;
    tastingRecord.addedDate = tastingDate;
    tastingRecord.tastingDate = tastingDate;
    tastingRecord.restaurant = restaurant;
    
    NSMutableSet *reviews = [tastingRecord.reviews mutableCopy];
    [reviews addObject:review];
    tastingRecord.reviews = reviews;
    
    for(User *friend in friendsArray){
        Review *friendReview = [ReviewObjectHandler createClaimed:NO reviewWithDate:tastingDate user:friend wine:review.wine rating:nil andReviewText:nil];
        friendReview.tastingRecord = tastingRecord;
    }
    
    return tastingRecord;
}

@end
