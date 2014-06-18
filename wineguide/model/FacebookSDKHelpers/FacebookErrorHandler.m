//
//  FacebookErrorHandler.m
//  Corkie
//
//  Created by Charles Feinn on 6/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookErrorHandler.h"
#import <FBErrorUtility.h>

@interface FacebookErrorHandler () <UIAlertViewDelegate>

@property (nonatomic) BOOL alertInProgress;

@end

@implementation FacebookErrorHandler

static FacebookErrorHandler *sharedInstance;

+(FacebookErrorHandler *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)handleError:(NSError *)error
{
    NSString *alertMessage;
    NSString *alertTitle;
    NSString *errorString;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please connect with Facebook again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        
        switch ([FBErrorUtility errorCategoryForError:error]) {
            case 0:
                /*! Indicates that the error category is invalid and likely represents an error that
                 is unrelated to Facebook or the Facebook SDK */
                errorString = @"FBErrorCategoryInvalid";
                break;
            case 1:
                /*! Indicates that the error may be authentication related but the application should retry the operation.
                 This case may involve user action that must be taken, and so the application should also test
                 the fberrorShouldNotifyUser property and if YES display fberrorUserMessage to the user before retrying.*/
                errorString = @"FBErrorCategoryRetry";
                break;
            case 3:
                /*! Indicates that the error is permission related */
                errorString = @"FBErrorCategoryPermissions";
                break;
            case 4:
                /*! Indicates that the error implies that the server had an unexpected failure or may be temporarily down */
                errorString = @"FBErrorCategoryServer";
                break;
            case 5:
                /*! Indicates that the error results from the server throttling the client */
                errorString = @"FBErrorCategoryFacebookOther";
                break;
            case -1:
                /*! Indicates that the error is Facebook-related but is uncategorizable, and likely newer than the
                 current version of the SDK */
                errorString = @"FBErrorCategoryInvalid";
                break;
            case -2:
                /*! Indicates that the error is an application error resulting in a bad or malformed request to the server. */
                errorString = @"FBErrorCategoryBadRequest";
                break;
                
            default:
                NSLog(@"Unexpected error:%@", error);
                break;
        }
    }
    
    if (alertMessage && !self.alertInProgress) {
        self.alertInProgress = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
        NSLog(@"Facebook error alertview already in flight. Trying to display another Error:\nalertTitle = %@; alertMessage = %@; error = %@",alertTitle,alertMessage,error);
    }
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.alertInProgress = NO;
}






@end
