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
#import "FacebookErrorHandler.h"

@interface FacebookSessionManager ()

@property (nonatomic, strong) NSArray *friends; // of NSDictionaries
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL haveUpdatedUserInfoThisSession;
@property (nonatomic) BOOL haveUpdatedFriendInfoThisSession;

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

-(BOOL)userIsLoggedIn
{
    return [FBSession activeSession].state == FBSessionStateOpen || [FBSession activeSession].state == FBSessionStateOpenTokenExtended;
}

-(void)logInWithCompletion:(void (^)(BOOL loggedIn))completion
{
    NSLog(@"logInWithCompletion...");
    if([FBSession activeSession].state != FBSessionStateOpen || [FBSession activeSession].state != FBSessionStateOpenTokenExtended){
        // Open a session showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
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
    if(!self.haveUpdatedUserInfoThisSession){
        [self getUserInfo];
    }
    
    if(!self.haveUpdatedFriendInfoThisSession){
        [self getFacebookFriends];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FACEBOOK_LOGIN_SUCCESSFUL object:nil userInfo:nil];
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
            [[FacebookErrorHandler sharedInstance] handleError:error];
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
                                  [[FacebookErrorHandler sharedInstance] handleError:error];
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
            [[FacebookErrorHandler sharedInstance] handleError:error];
        }
    }];
}


#pragma mark - Session state changes

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // Called EVERY time the session state changes
    [self handleStateChange:state];
    if(error){
        [[FacebookErrorHandler sharedInstance] handleError:error];
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



-(void)closeAndClearSession
{
    NSLog(@"closeAndClearSession...");
    [[FBSession activeSession] closeAndClearTokenInformation];
}




@end
