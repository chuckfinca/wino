//
//  WineUnit2+CreateOrModify.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineUnit2+CreateOrModify.h"
#import "NSDictionary+Helper.h"
#import "WineList.h"
#import "Wine2.h"

#define SERVER_IDENTIFIER @"id"
#define WINE_UNIT_PRICE @"price"
#define WINE_UNIT_QUANTITY @"quantity"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

@implementation WineUnit2 (CreateOrModify)

-(WineUnit2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqual: @0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.price = [dictionary sanitizedValueForKey:WINE_UNIT_PRICE];
        self.quantity = [dictionary sanitizedValueForKey:WINE_UNIT_QUANTITY];
        self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
        self.created_at = [dictionary dateAtKey:CREATED_AT];
        self.updated_at = serverUpdatedDate;
    }
    
    return self;
}

-(void)logDetails
{
    NSLog(@"=====================================================");
    NSLog(@"%@ - %@\n",[self class],self.identifier);
    NSLog(@"price = %@",self.price);
    NSLog(@"quantity = %@",self.quantity);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    NSLog(@"Related objects:");
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.wineList class], self.wineList.identifier]);
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.wine class], self.wine.identifier]);
}


-(NSString *)description
{
    [self logDetails];
    return @"-----------------------------------------------------";
}







@end
