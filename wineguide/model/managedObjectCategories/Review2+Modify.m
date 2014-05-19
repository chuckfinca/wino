//
//  Review2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Review2+Modify.h"
#import "NSDictionary+Helper.h"
#import "TastingRecord2.h"
#import "User2.h"
#import "Wine2.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

#define REVIEW_RATING @"review_rating"
#define REVIEW_CLAIMED @"review_claimed"
#define REVIEW_TEXT @"review_text"

@implementation Review2 (Modify)

-(Review2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqual: @0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.claimed = [dictionary sanitizedValueForKey:REVIEW_CLAIMED];
        self.rating = [dictionary sanitizedValueForKey:REVIEW_RATING];
        self.review_text = [dictionary sanitizedStringForKey:REVIEW_TEXT];
        self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
        self.created_at = [dictionary dateAtKey:CREATED_AT];
        self.updated_at = serverUpdatedDate;
    }
    
    [self logDetails];
    
    return self;
}


-(void)logDetails
{
    NSLog(@"=====================================================");
    NSLog(@"%@ - %@\n",[self class],self.identifier);
    NSLog(@"rating = %@",self.rating);
    NSLog(@"review_text = %@",self.review_text);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    NSLog(@"Related objects:");
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.user class], self.user.identifier]);
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.tastingRecord class], self.tastingRecord.identifier]);
}

-(NSString *)description
{
    [self logDetails];
    return [NSString stringWithFormat:@"%@ - %@",[self class],self.identifier];
}

@end







