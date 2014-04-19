//
//  RatingHistory2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingHistory2+Modify.h"
#import "NSDictionary+Helper.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"
#define RATING_HISTORY_AVERAGE_RATING @"asdf"
#define RATING_HISTORY_FIVES @"asdf"
#define RATING_HISTORY_FOURS @"asdf"
#define RATING_HISTORY_THREES @"asdf"
#define RATING_HISTORY_TWOS @"asdf"
#define RATING_HISTORY_ONES @"asdf"
#define RATING_HISTORY_TOTAL_RATINGS @"asdf"


@implementation RatingHistory2 (Modify)

-(RatingHistory2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    if(!self.identifier || [self.identifier isEqualToNumber:@0]){
        self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
    }
 
    self.average = [dictionary sanitizedStringForKey:RATING_HISTORY_AVERAGE_RATING];
    self.five_star_ratings = [dictionary sanitizedStringForKey:RATING_HISTORY_FIVES];
    self.four_star_ratings = [dictionary sanitizedStringForKey:RATING_HISTORY_FOURS];
    self.three_star_ratings = [dictionary sanitizedStringForKey:RATING_HISTORY_THREES];
    self.two_star_ratings = [dictionary sanitizedStringForKey:RATING_HISTORY_TWOS];
    self.one_star_ratings = [dictionary sanitizedStringForKey:RATING_HISTORY_ONES];
    self.total_ratings = [dictionary sanitizedStringForKey:RATING_HISTORY_TOTAL_RATINGS];
    self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
    self.created_at = [dictionary dateAtKey:CREATED_AT];
    self.updated_at = [dictionary dateAtKey:UPDATED_AT];
    
    [self logDetails];
    
    return self;
}

-(void)logDetails
{
    NSLog(@"=====================================================");
    NSLog(@"%@ - %@",[self class],self.identifier);
    NSLog(@"average = %@",self.average);
    NSLog(@"five_star_ratings = %@",self.five_star_ratings);
    NSLog(@"four_star_ratings = %@",self.four_star_ratings);
    NSLog(@"three_star_ratings = %@",self.three_star_ratings);
    NSLog(@"two_star_ratings = %@",self.two_star_ratings);
    NSLog(@"one_star_ratings = %@",self.one_star_ratings);
    NSLog(@"total_ratings = %@",self.total_ratings);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
}


-(NSString *)description
{
    [self logDetails];
    return [NSString stringWithFormat:@"%@ - %@",[self class],self.identifier];
}








@end
