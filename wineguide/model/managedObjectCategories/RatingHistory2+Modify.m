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
#define RATING_HISTORY_AVERAGE_RATING @"avg_rating"
#define RATING_HISTORY_FIVES @"five_star_ratings"
#define RATING_HISTORY_FOURS @"four_star_ratings"
#define RATING_HISTORY_THREES @"three_star_ratings"
#define RATING_HISTORY_TWOS @"two_star_ratings"
#define RATING_HISTORY_ONES @"one_star_ratings"
#define RATING_HISTORY_TOTAL_RATINGS @"total_ratings"


@implementation RatingHistory2 (Modify)

-(RatingHistory2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.average = [dictionary sanitizedValueForKey:RATING_HISTORY_AVERAGE_RATING];
        self.five_star_ratings = [dictionary sanitizedValueForKey:RATING_HISTORY_FIVES];
        self.four_star_ratings = [dictionary sanitizedValueForKey:RATING_HISTORY_FOURS];
        self.three_star_ratings = [dictionary sanitizedValueForKey:RATING_HISTORY_THREES];
        self.two_star_ratings = [dictionary sanitizedValueForKey:RATING_HISTORY_TWOS];
        self.one_star_ratings = [dictionary sanitizedValueForKey:RATING_HISTORY_ONES];
        self.total_ratings = [dictionary sanitizedValueForKey:RATING_HISTORY_TOTAL_RATINGS];
        self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
        self.created_at = [dictionary dateAtKey:CREATED_AT];
        self.updated_at = serverUpdatedDate;
        
        [self logDetails];
    }
    return self;
}

-(void)logDetails
{
    NSLog(@"=====================================================");
    NSLog(@"%@ - %@\n",[self class],self.identifier);
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
