//
//  User2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "User2+Modify.h"
#import "NSDictionary+Helper.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

#define USER_EMAIL @"email"
#define USER_GENDER @"gender"
#define USER_LATITUDE @"user_latitude"
#define USER_LONGITUDE @"user_longitude"
#define USER_NAME_FIRST @"user_first"
#define USER_NAME_LAST @"user_last"
#define USER_IMAGE @"image"
#define USER_FACEBOOK_ID @"facebook_id"

@implementation User2 (Modify)

-(User2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        if(!self.facebook_id || [self.facebook_id isEqualToNumber:@0]){
            self.facebook_id = [dictionary sanitizedValueForKey:USER_FACEBOOK_ID];
        }
        
        self.email = [dictionary sanitizedStringForKey:USER_EMAIL];
        self.gender = [dictionary sanitizedStringForKey:USER_GENDER];
        self.latitude = [dictionary sanitizedStringForKey:USER_LATITUDE];
        self.longitude = [dictionary sanitizedStringForKey:USER_LONGITUDE];
                // self.is_me
        self.name_first = [dictionary sanitizedStringForKey:USER_NAME_FIRST];
        self.name_last = [dictionary sanitizedStringForKey:USER_NAME_LAST];
        self.name_display = [NSString stringWithFormat:@"%@ %@.",self.name_first, [self.name_last substringToIndex:1]];
                // self.imageData
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
    NSLog(@"facebook_id = %@",self.facebook_id);
    NSLog(@"name_display = %@",self.name_display);
    NSLog(@"is_me = %@",self.is_me);
    NSLog(@"name_first = %@",self.name_first);
    NSLog(@"name_last = %@",self.name_last);
    NSLog(@"email = %@",self.email);
    NSLog(@"gender = %@",self.gender);
    NSLog(@"latitude = %@",self.latitude);
    NSLog(@"longitude = %@",self.longitude);
    NSLog(@"image data exists = %@",self.imageData ? @"Yes" : @"No");
    NSLog(@"registered = %@",self.registered);
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






