//
//  Group2+CreateOrModify.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Group2+CreateOrModify.h"
#import "NSDictionary+Helper.h"

#define SERVER_IDENTIFIER @"id"
#define GROUP_NAME @"group_name"
#define GROUP_DESCRIPTION @"group_desc"
#define GROUP_SORT_ORDER @"sort_order"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"


@implementation Group2 (CreateOrModify)

-(Group2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    if(!self.identifier || [self.identifier isEqualToNumber:@0]){
        self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
    }
    
    self.name = [dictionary sanitizedStringForKey:GROUP_NAME];
    self.groupDescription = [dictionary sanitizedStringForKey:GROUP_DESCRIPTION];
    self.sortOrder = [dictionary sanitizedValueForKey:GROUP_SORT_ORDER];
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
    NSLog(@"name = %@",self.name);
    NSLog(@"groupDescription = %@",self.groupDescription);
    NSLog(@"sortOrder = %@",self.sortOrder);
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
