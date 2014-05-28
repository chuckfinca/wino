//
//  User2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "User2+Modify.h"
#import "NSDictionary+Helper.h"
#import "Wine2.h"
#import "Review2.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"


@implementation User2 (Modify)

-(User2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqual: @0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        if(!self.facebook_id){
            self.facebook_id = [dictionary sanitizedStringForKey:USER_FACEBOOK_ID];
        }
        self.facebook_updated_at = [dictionary dateAtKey:USER_FACEBOOK_UPDATED_AT];
        
        self.email = [dictionary sanitizedStringForKey:USER_EMAIL];
        self.gender = [dictionary sanitizedValueForKey:USER_GENDER];
        self.latitude = [dictionary sanitizedValueForKey:USER_LATITUDE];
        self.longitude = [dictionary sanitizedValueForKey:USER_LONGITUDE];
                // self.is_me
        self.name_first = [dictionary sanitizedStringForKey:USER_NAME_FIRST];
        self.name_last = [dictionary sanitizedStringForKey:USER_NAME_LAST];
        self.name_display = [NSString stringWithFormat:@"%@ %@.",self.name_first, [self.name_last substringToIndex:1]];
        self.name_last_initial = [self.name_last substringToIndex:1];
                // self.imageData
        self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
                // self.registered
                // self.follow_status // used by UserHelper for relationship creation
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
    NSLog(@"facebook_updated_at = %@",self.facebook_updated_at);
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
    NSLog(@"follow_status = %@",self.follow_status);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    
    NSLog(@"Related Objects");
    
    for(Review2 *r in self.reviews){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[r class], r.identifier]);
    }
    
    for(Wine2 *w in self.wines){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[w class], w.identifier]);
    }
    
    for(User2 *following in self.following){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[following class], following.identifier]);
    }
    
    for(User2 *followedBy in self.followedBy){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[followedBy class], followedBy.identifier]);
    }
}

-(NSString *)description
{
    [self logDetails];
    return @"-----------------------------------------------------";
}









@end






