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

#define USER_WINES @"wines"             ////////////////////
#define USER_REVIEWS @"reviews"         ////////////////////
#define USER_FOLLOWING @"following"     ////////////////////
#define USER_FOLLOWED_BY @"followed_by" ////////////////////

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














@end





