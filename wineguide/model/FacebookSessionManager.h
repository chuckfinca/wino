//
//  FacebookSessionManager.h
//  Corkie
//
//  Created by Charles Feinn on 3/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSession.h>
#import "FacebookLoginViewDelegate.h"

#define FACEBOOK_LOGIN_SUCCESSFUL @"Facebook login successful"
#define FACEBOOK_PUBLISH_PERMISSION @"publish_actions"

@interface FacebookSessionManager : NSObject <FacebookLoginViewDelegateDelegate>

+(FacebookSessionManager *)sharedInstance;

-(void)checkToken; // Silent, on app load
-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;

-(void)updateBasicInformation; // Called only by FacebookLoginViewDelegate

-(BOOL)userHasPermission:(NSString *)permission;
-(void)requestPermission:(NSString *)permission withCompletion:(void (^)(BOOL success))completion;


@end
