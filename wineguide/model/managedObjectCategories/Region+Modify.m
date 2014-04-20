//
//  Region+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Region+Modify.h"
#import "NSDictionary+Helper.h"
#import "Wine2.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

#define REGION_DESCRIPTION @"varietal_desc"
#define REGION_NAME @"varietal_name"

@implementation Region (Modify)

-(Region *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.region_description = [dictionary sanitizedValueForKey:REGION_DESCRIPTION];
        self.name = [dictionary sanitizedValueForKey:REGION_NAME];
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
    NSLog(@"region_description = %@",self.region_description);
    NSLog(@"name = %@",self.name);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    NSLog(@"Related Objects");
    
    for(Wine2 *w in self.wines){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[w class], w.identifier]);
    }
}

-(NSString *)description
{
    [self logDetails];
    return [NSString stringWithFormat:@"%@ - %@",[self class],self.identifier];
}













@end




