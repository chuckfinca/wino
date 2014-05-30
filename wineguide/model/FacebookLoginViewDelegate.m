//
//  FacebookLoginViewDelegate.m
//  Corkie
//
//  Created by Charles Feinn on 5/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookLoginViewDelegate.h"
#import "FacebookSessionManager.h"


@implementation FacebookLoginViewDelegate

#pragma mark - FBLoginViewDelegate

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                           user:(id<FBGraphUser>)user
{
    NSLog(@"loginViewFetchedUserInfo...");
    [self.delegate updateBasicInformation];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"loginViewShowingLoggedInUser...");
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"loginViewShowingLoggedOutUser...");
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"FBLoginViewDelegate - There was a communication or authorization error - %@.",error.localizedDescription);
    [[FacebookSessionManager sharedInstance] sessionStateChanged:nil state:0 error:error];
}


@end
