//
//  FacebookPermissionsHandler.h
//  Corkie
//
//  Created by Charles Feinn on 6/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FACEBOOK_PUBLISH_PERMISSION @"publish_actions"
#define FACEBOOK_TAGGABLE_FRIENDS_PERMISSION @"taggable_friends"
#define FACEBOOK_USER_FRIENDS_PERMISSION @"user_friends"

@interface FacebookPermissionsHandler : NSObject

-(BOOL)userHasPermission:(NSString *)permission;
-(void)requestPermission:(NSString *)permission withCompletion:(void (^)(BOOL success))completion;

@end
