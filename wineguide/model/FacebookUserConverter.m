//
//  FacebookUserConverter.m
//  Corkie
//
//  Created by Charles Feinn on 5/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookUserConverter.h"
#import "DocumentHandler2.h"
#import "GetMe.h"
#import "NSDictionary+Helper.h"
#import "ManagedObjectFetcher.h"

@interface FacebookUserConverter ()

@property (nonatomic, strong) ManagedObjectFetcher *managedObjectFetcher;

@end

#define USER_ENTITY @"User2"

#define UPDATED_AT @"updated_at"

#define USER_EMAIL @"email"
#define USER_GENDER @"gender"
#define USER_LATITUDE @"user_latitude"
#define USER_LONGITUDE @"user_longitude"
#define USER_NAME_FIRST @"user_first"
#define USER_NAME_LAST @"user_last"
#define USER_IMAGE @"image"
#define USER_FACEBOOK_ID @"facebook_id"
#define USER_FACEBOOK_UPDATED_AT @"facebook_updated_at"

#define FACEBOOK_EMAIL @"email"
#define FACEBOOK_FIRST_NAME @"first_name"
#define FACEBOOK_GENDER @"gender"
#define FACEBOOK_ID @"id"
#define FACEBOOK_LAST_NAME @"last_name"
#define FACEBOOK_UPDATED_TIME @"updated_time"

@implementation FacebookUserConverter

#pragma mark - Getters & setters

-(ManagedObjectFetcher *)managedObjectFetcher
{
    if(!_managedObjectFetcher){
        _managedObjectFetcher = [[ManagedObjectFetcher alloc] init];
    }
    return _managedObjectFetcher;
}


-(void)modifyMeWithFacebookDictionary:(NSDictionary *)facebookDictionary
{
    User2 *me = [GetMe sharedInstance].me;
    
    if(!me.facebook_id || !me.email){
        
        NSMutableDictionary *mutableDictionary = [[self dictionaryWithBasicDetailsFromFacebookDictionary:facebookDictionary] mutableCopy];
        [mutableDictionary setObject:facebookDictionary[FACEBOOK_EMAIL] forKey:USER_EMAIL];
        
        NSInteger genderInteger = 0;
        NSString *genderString = facebookDictionary[FACEBOOK_GENDER];
        if([genderString isEqualToString:@"male"]){
            genderInteger = 1;
        } else if([genderString isEqualToString:@"female"]) {
            genderInteger = 2;
        }
        
        [mutableDictionary setObject:@(genderInteger) forKey:USER_GENDER];
        [mutableDictionary setObject:facebookDictionary[FACEBOOK_UPDATED_TIME] forKey:USER_FACEBOOK_UPDATED_AT];
        
        [me modifyAttributesWithDictionary:mutableDictionary];
    }
}

-(NSMutableDictionary *)dictionaryWithBasicDetailsFromFacebookDictionary:(NSDictionary *)facebookDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:facebookDictionary[FACEBOOK_ID] forKey:USER_FACEBOOK_ID];
    [dictionary setObject:facebookDictionary[FACEBOOK_FIRST_NAME] forKey:USER_NAME_FIRST];
    [dictionary setObject:facebookDictionary[FACEBOOK_LAST_NAME] forKey:USER_NAME_LAST];
    
    return dictionary;
}

-(User2 *)createOrModifyObjectWithFacebookFriendDictionary:(NSDictionary *)facebookDictionary
{
    NSString *facebookID = (NSString *)facebookDictionary[FACEBOOK_ID];
    
    User2 *user;
    
    if(facebookID){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"facebook_id == %@",facebookID];
        
        user = (User2 *)[self.managedObjectFetcher findOrCreateManagedObjectEntityType:USER_ENTITY usingDictionary:@{@"facebook_id" : facebookID}andPredicate:predicate];
        
        if(!user.facebook_id){
            NSLog(@"modifying");
            [user modifyAttributesWithDictionary:[self dictionaryWithBasicDetailsFromFacebookDictionary:facebookDictionary]];
        }
    }
    
    return user;
}















@end
