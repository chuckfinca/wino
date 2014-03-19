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
    
    if(!user.updatedDate || [user.updatedDate laterDate:date] == date){
        if(!user.updatedDate){
            user.addedDate = date;
        }
        user.blurb = nil;
        // user.deletedEntity
        user.identifier = [dictionary objectForKey:@"id"];
        // user.lastLocalUpdate
        // user.lastServerUpdate = date;
        user.name = [NSString stringWithFormat:@"%@ %@",[dictionary objectForKey:@"first_name"],[dictionary objectForKey:@"last_name"]];
        
        
        NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [dictionary objectForKey:@"username"]];
        // user.profileImage
        user.updatedDate = date;
        
        [user setHomeCoordinatesFromDictionary:[dictionary objectForKey:@"location"]];
        
        user.locale = [dictionary objectForKey:@"locale"];
        // user.birthday =
        user.email = [dictionary objectForKey:@"email"];
        user.gender = [dictionary objectForKey:@"gender"];
        
    }
    
    /* make the API call */
    
    [user logDetails];
    
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

-(void)logDetails
{
    NSLog(@"blurb = %@",self.blurb);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"name = %@",self.name);
    NSLog(@"profileImage = %@",self.profileImage);
    NSLog(@"updatedDate = %@",self.updatedDate);
    NSLog(@"homeLongitude = %@",self.homeLongitude);
    NSLog(@"homeLatitude = %@",self.homeLatitude);
    NSLog(@"locale = %@",self.locale);
    NSLog(@"birthday = %@",self.birthday);
    NSLog(@"email = %@",self.email);
    NSLog(@"gender = %@",self.gender);
}


@end
