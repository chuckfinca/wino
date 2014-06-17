//
//  FacebookSessionManager.m
//  Corkie
//
//  Created by Charles Feinn on 3/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookSessionManager.h"
#import <FBError.h>
#import <FBErrorUtility.h>
#import <FBRequest.h>
#import <FBRequestConnection.h>
#import <FBGraphObject.h>
#import <FBGraphUser.h>
#import "FacebookUserConverter.h"
#import "DocumentHandler2.h"
#import "GetMe.h"

@interface FacebookSessionManager () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *friends; // of NSDictionaries
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL haveUpdatedUserInfoThisSession;
@property (nonatomic) BOOL haveUpdatedFriendInfoThisSession;

@property (nonatomic) BOOL alertInProgress;

@end

@implementation FacebookSessionManager

static FacebookSessionManager *sharedInstance;

+(FacebookSessionManager *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Getters & Setters

-(NSManagedObjectContext *)context
{
    if(!_context){
        _context = [DocumentHandler2 sharedDocumentHandler].document.managedObjectContext;
    }
    return _context;
}



-(void)checkToken
{
    if([FBSession activeSession].state == FBSessionStateClosedLoginFailed || [FBSession activeSession].state == FBSessionStateClosed){
        NSLog(@"cached token does not exist");
        NSLog(@"[FBSession activeSession].state = %u",[FBSession activeSession].state);
        [self closeAndClearSession];
        
    } else {
        if([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded){
            BOOL cachedTokenExists = [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                                                        allowLoginUI:NO
                                                                   completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                                                       [self sessionStateChanged:session state:status error:error];
                                                                   }];
            if(cachedTokenExists){
                NSLog(@"Success! Facebook session is open, a cached token exists");
                [self updateBasicInformation];
            } else {
                [self checkToken];
            }
        }
    }
}

-(void)logInWithCompletion:(void (^)(BOOL loggedIn))completion
{
    NSLog(@"logInWithCompletion...");
    if([FBSession activeSession].state != FBSessionStateOpen || [FBSession activeSession].state != FBSessionStateOpenTokenExtended){
        // Open a session showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if(status == FBSessionStateOpen || status == FBSessionStateOpenTokenExtended){
                                              [self updateBasicInformation];
                                              completion(YES);
                                              
                                          } else {
                                              completion(NO);
                                          }
                                          
                                          [self sessionStateChanged:session state:status error:error];
                                      }];
    } else {
        completion(YES);
    }
}

-(void)updateBasicInformation
{
    NSLog(@"updateBasicInformation...");
    NSLog(@"Facebook permissions = %@",[FBSession activeSession].permissions);
    
    if(!self.haveUpdatedUserInfoThisSession){
        [self getUserInfo];
    }
    
    if(!self.haveUpdatedFriendInfoThisSession){
        [self getFacebookFriends];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FACEBOOK_LOGIN_SUCCESSFUL object:nil userInfo:nil];
}

-(BOOL)userHasPermission:(NSString *)permission
{
    return [[FBSession activeSession].permissions containsObject:permission];
}

-(void)requestPermission:(NSString *)permission withCompletion:(void (^)(BOOL success))completion
{
    if(![self userHasPermission:FACEBOOK_PUBLISH_PERMISSION]){
        
        if([FBSession activeSession].isOpen){
            
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
                                                        // There was an error, handle it
                                                        // See https://developers.facebook.com/docs/ios/errors/
                                                        [self handleError:error];
                                                        
                                                        completion(NO);
                                                    }
                                                }];
        } else {
            NSLog(@"FBSession activeSession not open");
            [self logInWithCompletion:^(BOOL loggedIn) {
                NSLog(@"loggedIn = %hhd",loggedIn);
                if(loggedIn){
                    
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
                                                                // There was an error, handle it
                                                                // See https://developers.facebook.com/docs/ios/errors/
                                                                [self handleError:error];
                                                                
                                                                completion(NO);
                                                            }
                                                        }];
                } else {
                    NSLog(@"FBSession activeSession STILL not open");
                }
            }];
        }
    } else {
        completion(YES);
    }
}

-(void)getUserInfo
{
    NSLog(@"getUserInfo...");
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            if([result isKindOfClass:[FBGraphObject class]]){
                FBGraphObject *graphObject = (FBGraphObject *)result;
                
                [graphObject setObject:@YES forKey:@"registered"];
                
                FacebookUserConverter *facebookUserConverter = [[FacebookUserConverter alloc] init];
                [facebookUserConverter modifyMeWithFacebookDictionary:graphObject];
                
                self.haveUpdatedUserInfoThisSession = YES;
            }
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            [self handleError:error];
        }
    }];
}

-(void)getFacebookInfoAtGraphPath:(NSString *)path
{
    NSLog(@"getFacebookInfoAtGraphPath...");
    [FBRequestConnection startWithGraphPath:path
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@"user events: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  [self handleError:error];
                              }
                          }];
}

-(void)getFacebookFriends
{
    NSLog(@"getFacebookFriends...");
    FBRequest *friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
        
        if(!error){
            self.friends = [result objectForKey:@"data"];
            NSLog(@"Found: %lu friends", (unsigned long)self.friends.count);
            
            User2 *me = [GetMe sharedInstance].me;
            
            NSMutableSet *friendsSet = [me.following mutableCopy];
            
            FacebookUserConverter *facebookUserConverter = [[FacebookUserConverter alloc] init];
            
            for (NSDictionary<FBGraphUser>* friendDictionary in self.friends) {
                User2 *friend = [facebookUserConverter createOrModifyObjectWithFacebookFriendDictionary:friendDictionary];
                
                if(![friendsSet containsObject:friend]){
                    [friendsSet addObject:friend];
                }
            }
            
            me.following = friendsSet;
            
            self.haveUpdatedFriendInfoThisSession = YES;
        } else {
            [self handleError:error];
        }
    }];
}


#pragma mark - Session state changes

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // Called EVERY time the session state changes
    [self handleStateChange:state];
    if(error){
        [self handleError:error];
    }
}

-(void)handleStateChange:(FBSessionState)status
{
    switch (status) {
            
        case FBSessionStateCreated:
            NSLog(@"FBSessionStateCreated");
            NSLog(@"  - no token has been found (yet).");
            break;
            
        case FBSessionStateCreatedTokenLoaded:
            NSLog(@"FBSessionStateCreatedTokenLoaded");
            NSLog(@"  - token has been found, but session isn't open");
            break;
            
        case FBSessionStateOpen:
            NSLog(@"FBSessionStateOpen");
            NSLog(@"  - session finished opening");
            NSLog(@"  - other API features can be accessed");
            break;
            
        case FBSessionStateClosed:
            NSLog(@"FBSessionStateClosed");
            [self closeAndClearSession];
            break;
            
        case FBSessionStateClosedLoginFailed:
            NSLog(@"FBSessionStateClosedLoginFailed");
            [self closeAndClearSession];
            break;
            
        case FBSessionStateCreatedOpening:
            NSLog(@"FBSessionStateCreatedOpening");
            break;
            
        case FBSessionStateOpenTokenExtended:
            NSLog(@"FBSessionStateOpenTokenExtended");
            break;
            
        default:
            NSLog(@"handleStateChange default");
            break;
    }
}

-(void)handleError:(NSError *)error
{
    NSString *alertMessage;
    NSString *alertTitle;
    
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
        
        NSString *errorString;
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
    
    if (alertMessage && self.alertInProgress) {
        self.alertInProgress = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
}

-(void)closeAndClearSession
{
    NSLog(@"closeAndClearSession...");
    [[FBSession activeSession] closeAndClearTokenInformation];
}



#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.alertInProgress = NO;
}





@end
