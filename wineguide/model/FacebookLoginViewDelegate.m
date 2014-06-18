//
//  FacebookLoginViewDelegate.m
//  Corkie
//
//  Created by Charles Feinn on 5/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookLoginViewDelegate.h"
#import "FacebookSessionManager.h"
#import <FBErrorUtility.h>
#import "FacebookErrorHandler.h"


@implementation FacebookLoginViewDelegate

#pragma mark - FBLoginViewDelegate

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                           user:(id<FBGraphUser>)user
{
    NSLog(@"loginView - FetchedUserInfo...");
    [self.delegate updateBasicInformation];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"loginView - ShowingLoggedInUser...");
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"loginView - ShowingLoggedOutUser...");
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"FBLoginViewDelegate - There was a communication or authorization error - %@.",error.localizedDescription);
    [[FacebookErrorHandler sharedInstance] handleError:error];
}








@end
