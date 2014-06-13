//
//  CreateLocalTastingRecord.m
//  Corkie
//
//  Created by Charles Feinn on 6/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "LocalTastingRecordCreator.h"
#import "ReviewHelper.h"
#import "TastingRecordHelper.h"
#import "Review2.h"
#import "WineIsAFavoriteChecker.h"
#import "LocalReviewCreator.h"

#define REVIEW_DATE @"review_date"
#define RESTAURANT @"restaurant"

#define TASTING_DATE @"tasting_date"
@interface LocalTastingRecordCreator ()

@property (nonatomic, strong) User2 *me;

@end

@implementation LocalTastingRecordCreator

#pragma mark - Getters & setters

-(User2 *)me
{
    if(!_me){
        _me  = [GetMe sharedInstance].me;
    }
    return _me;
}


-(TastingRecord2 *)createTastingRecordAndReviewWithText:(NSString *)reviewText rating:(float)rating wine:(Wine2 *)wine restaurant:(Restaurant2 *)restaurant tastingDate:(NSDate *)tastingDate andFriends:(NSArray *)selectedFriends
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSDate *now = [NSDate date];
    
    if(!tastingDate){
        tastingDate = now;
    }
    
    // Need better identifier
    NSNumber *identifier = [NSNumber numberWithInteger:-arc4random_uniform(1000000000)+1];
    
    [dictionary setObject:now forKey:CREATED_AT];
    [dictionary setObject:identifier forKey:ID_KEY];
    [dictionary setObject:tastingDate forKey:TASTING_DATE];
    [dictionary setObject:now forKey:UPDATED_AT];
    
    TastingRecordHelper *trdh = [[TastingRecordHelper alloc] init];
    TastingRecord2 *tastingRecord = (TastingRecord2 *)[trdh createObjectFromDictionary:dictionary];
    
    tastingRecord.restaurant = restaurant;
    tastingRecord.wine = wine;
    
    LocalReviewCreator *reviewCreator = [[LocalReviewCreator alloc] init];
    
    NSMutableSet *reviews = [[NSMutableSet alloc] init];
    Review2 *userReview = [reviewCreator createClaimed:YES reviewForUser:self.me withReviewText:reviewText rating:rating andCreationDate:now];
    userReview.review_date = tastingRecord.created_at;
    [reviews addObject:userReview];
    
    WineIsAFavoriteChecker *wineIsAFavoriteChecker = [[WineIsAFavoriteChecker alloc] init];
    [wineIsAFavoriteChecker setFavoriteStatusForWine:wine];
    
    if(selectedFriends){
        for(User2 *friend in selectedFriends){
            Review2 *friendReview = [reviewCreator createClaimed:NO reviewForUser:friend withReviewText:nil rating:0 andCreationDate:now];
            friendReview.created_at = tastingRecord.created_at;
            [reviews addObject:friendReview];
        }
        tastingRecord.reviews = reviews;
    }
    
    return tastingRecord;
}














@end
