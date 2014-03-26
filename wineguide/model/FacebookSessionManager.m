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
#import "UserDataHelper.h"
#import "DocumentHandler.h"

@interface FacebookSessionManager ()

@property (nonatomic, strong) NSArray *friends; // of NSDictionaries
@property (nonatomic, strong) NSManagedObjectContext *context;

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
        _context = [DocumentHandler sharedDocumentHandler].document.managedObjectContext;
    }
    return _context;
}

-(void)checkToken
{
    if([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded){
        BOOL cachedTokenExists = [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                                                    allowLoginUI:NO
                                                               completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                                                   [self sessionStateChanged:session state:status error:error];
                                                               }];
        if(cachedTokenExists){
            NSLog(@"Success! Facebook session is open, a cached token exists");
            self.sessionActive = YES;
            [self updateBasicInformation];
        }
    } else {
        NSLog(@"cached token does not exist");
        [self closeAndClearSession];
    }
}



-(void)logInWithCompletion:(void (^)(BOOL loggedIn))completion
{
    if([FBSession activeSession].state != FBSessionStateOpen || [FBSession activeSession].state != FBSessionStateOpenTokenExtended){
        // Open a session showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if(status == FBSessionStateOpen || status == FBSessionStateOpenTokenExtended){
                                              self.sessionActive = YES;
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
    [self checkPermissions];
    [self getUserInfo];
    [self getFacebookFriends];
}

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
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
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
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(void)closeAndClearSession
{
    self.sessionActive = NO;
    [[FBSession activeSession] closeAndClearTokenInformation];
}


-(void)checkPermissions
{
    // Check for publish permissions
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  if([result isKindOfClass:[NSArray class]]){
                                      for(NSString *permission in (NSArray *)[result data]){
                                          NSLog(@"permission = %@",permission);
                                      }
                                  }
                              } else {
                                  // Publish permissions found, publish the OG story
                                  
                                  NSLog(@"error retrieving permissions = %@",error.localizedDescription);
                              }
                          }];
}

-(void)getUserInfo
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            if([result isKindOfClass:[FBGraphObject class]]){
                FBGraphObject *graphObject = (FBGraphObject *)result;
                
                [graphObject setObject:@YES forKey:@"registered"];
                
                UserDataHelper *udh = [[UserDataHelper alloc] init];
                udh.context = self.context;
                [udh updateManagedObjectWithDictionary:graphObject];
            }
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

-(void)getFacebookInfoAtGraphPath:(NSString *)path
{
    [FBRequestConnection startWithGraphPath:path
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@"user events: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

-(void)getFacebookFriends
{
    if(!self.friends){
        
        FBRequest *friendsRequest = [FBRequest requestForMyFriends];
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            self.friends = [result objectForKey:@"data"];
            NSLog(@"Found: %i friends", self.friends.count);
            for (NSDictionary<FBGraphUser>* friend in _friends) {
                UserDataHelper *udh = [[UserDataHelper alloc] init];
                udh.context = self.context;
                [udh updateManagedObjectWithDictionary:friend];
            }
        }];
    }
}



@end
