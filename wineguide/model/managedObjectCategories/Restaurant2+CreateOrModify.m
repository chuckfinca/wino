//
//  Restaurant2+CreateOrModify.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Restaurant2+CreateOrModify.h"
#import "NSDictionary+Helper.h"

#define SERVER_IDENTIFIER @"id"
#define RESTAURANT_STATE @"restaurant_state"
#define RESTAURANT_NAME @"restaurant_name"
#define RESTAURANT_STREET_1 @"restaurant_street_1"
#define RESTAURANT_STREET_2 @"restaurant_street_2"
#define RESTAURANT_CITY @"restaurant_city"
#define STATUS_CODE @"status"
#define RESTAURANT_ZIP @"restaurant_zip"
#define RESTAURANT_COUNTRY @"restaurant_country"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"
#define RESTAURANT_LATITUDE @"restaurant_lat"
#define RESTAURANT_LONGITUDE @"restaurant_lon"

@implementation Restaurant2 (CreateOrModify)

-(Restaurant2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    if(!self.identifier || [self.identifier isEqualToNumber:@0]){
        self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
    }
    
    self.state = [dictionary sanitizedStringForKey:RESTAURANT_STATE];
    self.name = [dictionary sanitizedStringForKey:RESTAURANT_NAME];
    self.street_1 = [dictionary sanitizedStringForKey:RESTAURANT_STREET_1];
    self.street_2 = [dictionary sanitizedStringForKey:RESTAURANT_STREET_2];
    self.city = [dictionary sanitizedStringForKey:RESTAURANT_CITY];
    self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
    self.zip = [dictionary sanitizedStringForKey:RESTAURANT_ZIP];
    self.country = [dictionary sanitizedStringForKey:RESTAURANT_COUNTRY];
    self.created_at = [dictionary dateAtKey:CREATED_AT];
    self.updated_at = [dictionary dateAtKey:UPDATED_AT];
    self.latitude = [dictionary sanitizedValueForKey:RESTAURANT_LATITUDE];
    self.longitude = [dictionary sanitizedValueForKey:RESTAURANT_LONGITUDE];
    
    [self logDetails];
    
    return self;
}

-(void)logDetails
{
    NSLog(@"=====================================================");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"state = %@",self.state);
    NSLog(@"name = %@",self.name);
    NSLog(@"street_1 = %@",self.street_1);
    NSLog(@"street_2 = %@",self.street_2);
    NSLog(@"city = %@",self.city);
    NSLog(@"status = %@",self.status);
    NSLog(@"zip = %@",self.zip);
    NSLog(@"country = %@",self.country);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    NSLog(@"latitude = %@",self.latitude);
    NSLog(@"longitude = %@",self.longitude);
}


-(NSString *)description
{
    [self logDetails];
    return [NSString stringWithFormat:@"%@ - %@",[self class],self.identifier];
}





@end
