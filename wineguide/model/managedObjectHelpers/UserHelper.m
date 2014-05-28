//
//  UserHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UserHelper.h"
#import "User2+Modify.h"
#import "WineHelper.h"
#import "Wine2.h"
#import "ReviewHelper.h"
#import "Review2.h"
#import "NSDictionary+Helper.h"

#define USER_WINES @"wines"
#define USER_REVIEWS @"reviews"
#define USER_FOLLOWING @"following"
#define USER_FOLLOWED_BY @"followed_by"

#define UPDATED_AT @"updated_at"

#define USER_EMAIL @"email"
#define USER_GENDER @"gender"
#define USER_LATITUDE @"user_latitude"
#define USER_LONGITUDE @"user_longitude"
#define USER_NAME_FIRST @"user_first"
#define USER_NAME_LAST @"user_last"
#define USER_IMAGE @"image"
#define USER_FACEBOOK_ID @"facebook_id"

#define FACEBOOK_EMAIL @"email"
#define FACEBOOK_FIRST_NAME @"first_name"
#define FACEBOOK_GENDER @"gender"
#define FACEBOOK_ID @"id"
#define FACEBOOK_LAST_NAME @"last_name"
#define FACEBOOK_UPDATED_TIME @"updated_time"

typedef NS_ENUM(NSInteger, FollowingStatus) {
    FollowingStatus_None     = 0,
    FollowingStatus_Following = 1,
    FollowingStatus_FollowedBy = 2,
};

@implementation UserHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    User2 *user = (User2 *)[self findOrCreateManagedObjectEntityType:USER_ENTITY usingDictionary:dictionary];
    [user modifyAttributesWithDictionary:dictionary];
    
    return user;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    User2 *user = (User2 *)managedObject;
    
    if ([self.relatedObject class] == [Wine2 class]){
        user.wines = [self addRelationToSet:user.wines];
        
    } else if([self.relatedObject class] == [Review2 class]){
        user.reviews = [self addRelationToSet:user.reviews];
        
    } else if ([self.relatedObject class] == [User2 class]){
        User2 *user = (User2 *)self.relatedObject;
        
        if([user.follow_status  isEqual: @(FollowingStatus_Following)]){
            user.following = [self addRelationToSet:user.following];
            user.follow_status = @(FollowingStatus_None);
            
        } else if ([user.follow_status isEqual: @(FollowingStatus_FollowedBy)]){
            user.followedBy = [self addRelationToSet:user.followedBy];
            user.follow_status = @(FollowingStatus_None);
        }
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    User2 *user = (User2 *)managedObject;
    
    // Wines
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[USER_WINES] withRelatedObject:user];
    
    // Reviews
    ReviewHelper *rh = [[ReviewHelper alloc] init];
    [rh processJSON:dictionary[USER_REVIEWS] withRelatedObject:user];
    
    // Following
    UserHelper *followingHelper = [[UserHelper alloc] init];
    user.follow_status = @(FollowingStatus_Following);
    [followingHelper processJSON:dictionary[USER_FOLLOWING] withRelatedObject:user];
    
    // Followed by
    UserHelper *followedByHelper = [[UserHelper alloc] init];
    user.follow_status = @(FollowingStatus_FollowedBy);
    [followedByHelper processJSON:dictionary[USER_FOLLOWED_BY] withRelatedObject:user];
}

-(NSManagedObject *)createOrModifyObjectWithFacebookDictionary:(NSDictionary *)facebookDictionary
{
    NSNumber *facebookID = [NSNumber numberWithInteger:[facebookDictionary[FACEBOOK_ID] integerValue]];
    
    NSLog(@"facebookID = %@",facebookID);
    NSLog(@"facebookDictionary = %@",facebookDictionary);
    
    User2 *user = (User2 *)[self findOrCreateManagedObjectForFacebookUserID:[NSNumber numberWithInteger:[facebookDictionary[FACEBOOK_ID] integerValue]]];
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    
    [mutableDictionary setObject:facebookDictionary[FACEBOOK_ID] forKey:USER_FACEBOOK_ID];
    [mutableDictionary setObject:facebookDictionary[FACEBOOK_FIRST_NAME] forKey:USER_NAME_FIRST];
    [mutableDictionary setObject:facebookDictionary[FACEBOOK_LAST_NAME] forKey:USER_NAME_LAST];
    
    [user modifyAttributesWithDictionary:mutableDictionary];
    
    return user;
}


-(NSManagedObject *)findOrCreateManagedObjectForFacebookUserID:(NSNumber *)facebookID
{
    NSManagedObject *managedObject;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"facebook_id == %@",facebookID];
    
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1){
        NSLog(@"Error %@ - matches exists? %@; [matches count] = %lu",error,matches ? @"yes" : @"no",(unsigned long)[matches count]);
        
    } else if ([matches count] == 0) {
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:USER_ENTITY inManagedObjectContext:self.context];
        
    } else if ([matches count] == 1){
        managedObject = [matches lastObject];
        
    } else {
        // Error
        NSLog(@"Error - ManagedObject will be nil");
    }
    
    return managedObject;
}







@end





