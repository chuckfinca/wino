//
//  TalkingHeads+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 5/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TalkingHeads+Modify.h"
#import "NSDictionary+Helper.h"
#import "User2.h"
#import "Wine2.h"

#define SERVER_IDENTIFIER @"id"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"


@implementation TalkingHeads (Modify)

-(TalkingHeads *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqual: @0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
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
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    NSLog(@"Related objects:");
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.wine class], self.wine.identifier]);
    
    for(User2 *u in self.users){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[u class], u.identifier]);
    }
}

-(NSString *)description
{
    [self logDetails];
    return @"-----------------------------------------------------";
}


@end
