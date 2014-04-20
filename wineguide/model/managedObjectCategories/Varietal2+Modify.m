//
//  Varietal2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Varietal2+Modify.h"
#import "NSDictionary+Helper.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

#define VARIETAL_ABOUT @"varietal_desc"
#define VARIETAL_NAME @"varietal_name"
#define VARIETAL_IS_BLEND @"is_mixed"

@implementation Varietal2 (Modify)

-(Varietal2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqualToNumber:@0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.about = [dictionary sanitizedValueForKey:VARIETAL_ABOUT];
        self.name = [dictionary sanitizedValueForKey:VARIETAL_NAME];
        self.blend = [dictionary sanitizedValueForKey:VARIETAL_IS_BLEND];
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
    NSLog(@"about = %@",self.about);
    NSLog(@"name = %@",self.name);
    NSLog(@"blend = %@",self.blend);
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