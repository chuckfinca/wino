//
//  FacebookSessionManager.h
//  Corkie
//
//  Created by Charles Feinn on 3/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSession.h>
#import "User.h"

@interface FacebookSessionManager : NSObject

+(FacebookSessionManager *)sharedInstance;

@property (nonatomic, strong) User *user;

-(void)checkToken; // Silent, on app load

-(void)logInWithCompletion:(void (^)(BOOL loggedIn))completion;

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;

@end
