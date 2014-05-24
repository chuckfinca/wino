//
//  FacebookSessionManager.h
//  Corkie
//
//  Created by Charles Feinn on 3/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSession.h>

@interface FacebookSessionManager : NSObject

+(FacebookSessionManager *)sharedInstance;

-(void)checkToken; // Silent, on app load
-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;

@end
