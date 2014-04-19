//
//  Flight2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Flight2+Modify.h"
#import "NSDictionary+Helper.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

@implementation Flight2 (Modify)

-(Flight2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    if(!self.identifier || [self.identifier isEqualToNumber:@0]){
        self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
    }
    
    self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
    self.created_at = [dictionary dateAtKey:CREATED_AT];
    self.updated_at = [dictionary dateAtKey:UPDATED_AT];
    
    [self logDetails];
    
    return self;
}

-(void)logDetails
{
    NSLog(@"=====================================================");
    NSLog(@"%@ - %@\n",[self class],self.identifier);
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
