//
//  FacebookPermissionsHandler.m
//  Corkie
//
//  Created by Charles Feinn on 6/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookPermissionsHandler.h"
#import <FBSession.h>
#import "FacebookSessionManager.h"
#import "FacebookErrorHandler.h"

@implementation FacebookPermissionsHandler

-(BOOL)userHasPermission:(NSString *)permission
{
    return [[FBSession activeSession].permissions containsObject:permission];
}

-(void)requestPermission:(NSString *)permission withCompletion:(void (^)(BOOL success))completion
{
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session, NSError *error) {
                                            __block NSString *alertText;
                                            __block NSString *alertTitle;
                                            if (!error) {
                                                if ([FBSession.activeSession.permissions
                                                     indexOfObject:@"publish_actions"] == NSNotFound){
                                                    // Permission not granted, tell the user we will not publish
                                                    alertTitle = @"Permission not granted";
                                                    alertText = @"Your action will not be published to Facebook.";
                                                    [[[UIAlertView alloc] initWithTitle:alertTitle
                                                                                message:alertText
                                                                               delegate:self
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles:nil] show];
                                                    completion(NO);
                                                } else {
                                                    // Permission granted, publish the OG story
                                                    completion(YES);
                                                }
                                                
                                            } else {
                                                [[FacebookErrorHandler sharedInstance] handleError:error];
                                                
                                                completion(NO);
                                            }
                                        }];
}









@end
