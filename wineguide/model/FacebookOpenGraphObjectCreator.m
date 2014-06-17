//
//  FacebookOpenGraphObjectCreator.m
//  Corkie
//
//  Created by Charles Feinn on 6/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookOpenGraphObjectCreator.h"
#import <FBOpenGraphObject.h>
#import <FBRequestConnection.h>
#import <FBOpenGraphAction.h>
#import "Wine2.h"
#import "User2.h"
#import "Review2.h"
#import "GetMe.h"
#import <FBErrorUtility.h>

#define FACEBOOK_NAME_SPACE @"corkieapp"
#define FACEBOOK_OBJECT_TYPE @"wine"
#define FACEBOOK_ACTION @"try"


@implementation FacebookOpenGraphObjectCreator

-(void)createObjectForTastingRecord:(TastingRecord2 *)tastingRecord
{
    // instantiate a Facebook Open Graph object
    NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
    
    // specify that this Open Graph object will be posted to Facebook
    object.provisionedForPost = YES;
    
    // for og:title
    NSLog(@"tastingRecord.wine.name = %@",tastingRecord.wine.name);
    object[@"title"] = tastingRecord.wine.name;
    
    // for og:type, this corresponds to the Namespace you've set for your app and the object type name
    object[@"type"] = [NSString stringWithFormat:@"%@:%@",FACEBOOK_NAME_SPACE,FACEBOOK_OBJECT_TYPE];
    
    // for og:description
    object[@"description"] = @"Crunchy pumpkin seeds roasted in butter and lightly salted.";
    
    // for og:url, we cover how this is used in the "Deep Linking" section below
    object[@"url"] = @"http://example.com/roasted_pumpkin_seeds";
    
    // for og:image we assign the image that we just staged, using the uri we got as a response
    // the image has to be packed in a dictionary like this:
    //object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];

    
    NSMutableArray *selectedFacebookFriendIdentifiers = [[NSMutableArray alloc] init];
    
    for(Review2 *review in tastingRecord.reviews){
        if(review.user != [GetMe sharedInstance].me && review.user.facebook_id){
            NSLog(@"name = %@",review.user.name_full);
            [selectedFacebookFriendIdentifiers addObject:review.user.facebook_id];
        }
    }
    
    [self postObjectToFacebook:object withSelectedFriends:selectedFacebookFriendIdentifiers];
}

-(void)postObjectToFacebook:(NSDictionary<FBOpenGraphObject> *)object withSelectedFriends:(NSArray *)selectedFacebookFriendIdentifiers
{
    [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            // get the object ID for the Open Graph object that is now stored in the Object API
            NSString *objectId = [result objectForKey:@"id"];
            
            // Further code to post the OG story goes here
            [self createActionForObjectId:objectId withSelectedFriends:selectedFacebookFriendIdentifiers];
            
        } else {
            // An error occurred
            NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
        }
    }];
}

-(void)createActionForObjectId:(NSString *)objectId withSelectedFriends:(NSArray *)selectedFacebookFriendIdentifiers
{
    // create an Open Graph action
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    [action setObject:objectId forKey:FACEBOOK_OBJECT_TYPE];
    
    // create action referencing user owned object
    NSString *graphPath = [NSString stringWithFormat:@"/me/%@:%@",FACEBOOK_NAME_SPACE,FACEBOOK_ACTION];
    [FBRequestConnection startForPostWithGraphPath:graphPath graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
            
            NSString *storyId = [result objectForKey:@"id"];
            for(NSString *ident in selectedFacebookFriendIdentifiers){
                NSLog(@"id = %@",ident);
            }
            
            [self getTaggableFriends];
            
            
        } else {
            // An error occurred
            NSLog(@"Encountered an error posting to Open Graph: %@", error);
        }
    }];
}

-(void)getTaggableFriends
{
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              if(!error){
                                  NSLog(@"RESULT %@ class = %@",[result class], result);
                              } else {
                                  [self handleAPICallError:error];
                              }
                          }];
}

// Example Graph API call
- (void)makeGraphAPICall {
    // We will use retryCount as part of the error handling logic for errors that need retries
    static int retryCount = 0;
    
    // FBRequestConnection example API call to me
    [FBRequestConnection
     startWithGraphPath:@"me"
     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         // Completion handler block
         if (error) {
             [self handleAPICallError:error];
         } else {
             retryCount = 0;
         }
     }];
}

// Helper method to handle errors during API calls
- (void)handleAPICallError:(NSError *)error
{
    // If the user has removed a permission that was previously granted
    if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryPermissions) {
        NSLog(@"Re-requesting permissions");
        // Ask for required permissions.
        //[self requestPermission];
        return;
    }
    
    // Some Graph API errors need retries, we will have a simple retry policy of one additional attempt
    // We also retry on a throttling error message, a more sophisticated app should consider a back-off period
    //retryCount++;
    if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryRetry ||
        [FBErrorUtility errorCategoryForError:error] == FBErrorCategoryThrottling) {
        if (2) {
            NSLog(@"Retrying open graph post");
            // Recovery tactic: Call API again.
            [self makeGraphAPICall];
            return;
        } else {
            NSLog(@"Retry count exceeded.");
            return;
        }
    }
    
    // For all other errors...
    NSString *alertText;
    NSString *alertTitle;
    
    // Get more error information from the error
    int errorCode = error.code;
    NSDictionary *errorInformation = [[[[error userInfo] objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]
                                       objectForKey:@"body"]
                                      objectForKey:@"error"];
    int errorSubcode = 0;
    if ([errorInformation objectForKey:@"code"]){
        errorSubcode = [[errorInformation objectForKey:@"code"] integerValue];
    }
    
    // Check if it's a "duplicate action" error
    if (errorCode == 5 && errorSubcode == 3501) {
        // Tell the user the action failed because duplicate action-object  are not allowed
        alertTitle = @"Duplicate action";
        alertText = @"You already did this, you can perform this action only once on each item.";
        
        // If the user should be notified, we show them the corresponding message
    } else if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Something Went Wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        
    } else {
        // show a generic error message
        NSLog(@"Unexpected error posting to open graph: %@", error);
        alertTitle = @"Something went wrong";
        alertText = @"Please try again later.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

@end
