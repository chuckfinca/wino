//
//  Group2+CreateOrModify.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Group2+CreateOrModify.h"
#import "NSDictionary+Helper.h"
#import "WineList.h"
#import "Wine2.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"
#define GROUP_NAME @"group_name"
#define GROUP_DESCRIPTION @"group_desc"
#define GROUP_SORT_ORDER @"sort_order"


@implementation Group2 (CreateOrModify)

-(Group2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqual: @0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.name = [dictionary sanitizedStringForKey:GROUP_NAME];
        self.group_description = [dictionary sanitizedStringForKey:GROUP_DESCRIPTION];
        self.sort_order = [dictionary sanitizedValueForKey:GROUP_SORT_ORDER];
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
    NSLog(@"group_description = %@",self.group_description);
    NSLog(@"sort_order = %@",self.sort_order);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    NSLog(@"Related objects:");
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.wineList class], self.wineList.identifier]);
    
    for(Wine2 *wine in self.wines){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[wine class], wine.identifier]);
    }
}


-(NSString *)description
{
    [self logDetails];
    return @"-----------------------------------------------------";
}









@end
