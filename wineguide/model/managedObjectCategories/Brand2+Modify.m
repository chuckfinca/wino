//
//  Brand2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Brand2+Modify.h"
#import "NSDictionary+Helper.h"
#import "Wine2.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"
#define BRAND_ABOUT @"about"
#define BRAND_NAME @"brand_name"
#define BRAND_WEBSITE @"website"

@implementation Brand2 (Modify)

-(Brand2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqual: @0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.about = [dictionary sanitizedStringForKey:BRAND_ABOUT];
        self.name = [dictionary sanitizedStringForKey:BRAND_NAME];
        self.website = [dictionary sanitizedStringForKey:BRAND_WEBSITE];
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
    NSLog(@"website = %@",self.website);
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
    return @"-----------------------------------------------------";
}






@end



