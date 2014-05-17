//
//  WineList+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 5/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineList+Modify.h"
#import "NSDictionary+Helper.h"
#import "Flight2.h"
#import "Group2.h"
#import "WineUnit2.h"
#import "Wine2.h"
#import "Restaurant2.h"

#define WINELIST_NAME @"name"
#define WINELIST_DESCRIPTION @"about"

#define SERVER_IDENTIFIER @"id"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"
#define STATUS_CODE @"status"

@implementation WineList (Modify)

-(WineList *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.name = [dictionary sanitizedStringForKey:WINELIST_NAME];
        self.about = [dictionary sanitizedStringForKey:WINELIST_DESCRIPTION];
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
    NSLog(@"name = %@",self.name);
    NSLog(@"about = %@",self.about);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    NSLog(@"Related objects:");
    
    NSLog(@"restaurant = %@",self.restaurant.name);
    
    for(Flight2 *flight in self.flights){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[flight class], flight.identifier]);
    }
    for(Group2 *group in self.groups){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[group class], group.identifier]);
    }
    for(WineUnit2 *wineUnits in self.wineUnits){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[wineUnits class], wineUnits.identifier]);
    }
    for(Wine2 *wine in self.wines){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[wine class], wine.identifier]);
    }
}


-(NSString *)description
{
    [self logDetails];
    return [NSString stringWithFormat:@"%@ - %@",[self class],self.identifier];
}


@end
