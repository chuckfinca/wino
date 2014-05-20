//
//  TastingRecord2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecord2+Modify.h"
#import "NSDictionary+Helper.h"
#import "Restaurant2.h"
#import "Review2.h"
#import "Wine2.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

#define TASTING_RECORD_TASTING_DATE @"tasting_date"

@implementation TastingRecord2 (Modify)

-(TastingRecord2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqual: @0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.tasting_date = [dictionary dateAtKey:TASTING_RECORD_TASTING_DATE];
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
    NSLog(@"tasting_date = %@",self.tasting_date);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    
    NSLog(@"Related objects:");
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.restaurant class], self.restaurant.identifier]);
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.wine class], self.wine.identifier]);
    
    for(Review2 *r in self.reviews){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[r class], r.identifier]);
    }
}

-(NSString *)description
{
    [self logDetails];
    return @"-----------------------------------------------------";
}









@end






