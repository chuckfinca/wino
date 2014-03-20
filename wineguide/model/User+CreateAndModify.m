//
//  User+CreateAndModify.m
//  Corkie
//
//  Created by Charles Feinn on 3/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "User+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSManagedObject+Helper.h"
#import <FBRequestConnection.h>
#import <AFNetworking.h>

#define USER_ENTITY @"User"

@implementation User (CreateAndModify)

+(User *)userFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    User *user = nil;
    
    user = (User *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:USER_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSString *dateString = [dictionary objectForKey:@"updated_time"];
    NSDate *date = [df dateFromString:dateString];
    
    if(!date){
        date = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:0];
    }
    
    
    if(!user.updatedDate || [user.updatedDate laterDate:date] == date){
        
        NSLog(@"date = %@",date);
        NSLog(@"user.updatedDate = %@",user.updatedDate);
        NSLog(@"user.updatedDate doesn't exist = %@",!user.updatedDate ? @"y" : @"n");
        NSLog(@"user doesn't exist = %@",!user ? @"y" : @"n");
        
        if(!user.updatedDate){
            user.addedDate = date;
        }
        user.blurb = nil;
        // user.deletedEntity
        user.identifier = [dictionary objectForKey:@"id"];
        // user.lastLocalUpdate
        // user.lastServerUpdate = date;
        user.nameFirst = [dictionary objectForKey:@"first_name"];
        
        NSString *lastName = [dictionary objectForKey:@"last_name"];
        user.nameLast = lastName;
        user.nameLastInitial = [lastName substringToIndex:1];
        
        // user.profileImage
        user.registered = [dictionary objectForKey:@"registered"];
        
        if([user.registered boolValue] == YES){
            [user getAndSetUserProfilePicFromStringUrl:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [dictionary objectForKey:@"username"]]];
            [user setHomeCoordinatesFromDictionary:[dictionary objectForKey:@"location"]];
        }
        
        user.updatedDate = date;
        
        user.locale = [dictionary objectForKey:@"locale"];
        // user.birthday =
        user.email = [dictionary objectForKey:@"email"];
        user.gender = [dictionary objectForKey:@"gender"];
        
    }
    
    /* make the API call */
    
    //[user logDetails];
    
    return user;
}

-(void)setHomeCoordinatesFromDictionary:(NSDictionary *)dictionary
{
    [FBRequestConnection startWithGraphPath:[dictionary objectForKey:@"id"]
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  if([result isKindOfClass:[NSDictionary class]]){
                                      NSDictionary *locationDictionary = [result objectForKey:@"location"];
                                      self.homeLatitude = [locationDictionary objectForKey:@"latitude"];
                                      self.homeLongitude = [locationDictionary objectForKey:@"longitude"];
                                  }
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"Error with startWithGraphPath:%@",[dictionary objectForKey:@"id"]);
                              }
                          }];
}

-(void)getAndSetUserProfilePicFromStringUrl:(NSString *)stringUrl
{
    NSURL *URL = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // You have it.
                               if(!error){
                                   self.profileImage = data;
                                   NSLog(@"data.bytes = %lu",(unsigned long)data.length);
                               } else {
                                   NSLog(@"Error downloading user profile image - %@ - error code %li",error.localizedDescription, (long)error.code);
                               }
                           }];
     
     /*
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
      */
}

-(void)logDetails
{
    NSLog(@"blurb = %@",self.blurb);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"first name = %@",self.nameFirst);
    NSLog(@"last name = %@",self.nameLast);
    NSLog(@"profileImage bytes = %lu",(unsigned long)self.profileImage.length);
    NSLog(@"updatedDate = %@",self.updatedDate);
    NSLog(@"registered = %@",self.registered);
    NSLog(@"homeLongitude = %@",self.homeLongitude);
    NSLog(@"homeLatitude = %@",self.homeLatitude);
    NSLog(@"locale = %@",self.locale);
    NSLog(@"birthday = %@",self.birthday);
    NSLog(@"email = %@",self.email);
    NSLog(@"gender = %@",self.gender);
}


@end
