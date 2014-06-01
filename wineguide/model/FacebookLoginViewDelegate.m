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
    [self handleAuthError:error];
    
    //[[FacebookSessionManager sharedInstance] sessionStateChanged:nil state:0 error:error];
}


- (void)handleAuthError:(NSError *)error
{
    NSString *alertText;
    NSString *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        // Error requires people using you app to make an action outside your app to recover
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        [self showMessage:alertText withTitle:alertTitle];
        
    } else {
        // You need to find more information to handle the error within your app
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            //The user refused to log in into your app, either ignore or...
            alertTitle = @"Login cancelled";
            alertText = @"You need to login to access this part of the app";
            [self showMessage:alertText withTitle:alertTitle];
            
        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Something went wrong";
            alertText = @"Please retry";
            [self showMessage:alertText withTitle:alertTitle];
        }
    }
    
    NSLog(@"error.userInfo = %@",error.userInfo);
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
