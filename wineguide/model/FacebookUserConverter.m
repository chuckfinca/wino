//
//  FacebookUserConverter.m
//  Corkie
//
//  Created by Charles Feinn on 5/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookUserConverter.h"
#import "DocumentHandler2.h"
#import "User2+Modify.h"
#import "GetMe.h"
#import "NSDictionary+Helper.h"

@interface FacebookUserConverter ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

#define USER_ENTITY @"User2"

#define UPDATED_AT @"updated_at"

#define USER_EMAIL @"email"
#define USER_GENDER @"gender"
#define USER_LATITUDE @"user_latitude"
#define USER_LONGITUDE @"user_longitude"
#define USER_NAME_FIRST @"user_first"
#define USER_NAME_LAST @"user_last"
#define USER_IMAGE @"image"
#define USER_FACEBOOK_ID @"facebook_id"
#define USER_FACEBOOK_UPDATED_AT @"facebook_updated_at"

#define FACEBOOK_EMAIL @"email"
#define FACEBOOK_FIRST_NAME @"first_name"
#define FACEBOOK_GENDER @"gender"
#define FACEBOOK_ID @"id"
#define FACEBOOK_LAST_NAME @"last_name"
#define FACEBOOK_UPDATED_TIME @"updated_time"

@implementation FacebookUserConverter

#pragma mark - Getters & Setters

-(NSManagedObjectContext *)context
{
    if(!_context){
        _context = [DocumentHandler2 sharedDocumentHandler].document.managedObjectContext;
    }
    return _context;
}

-(void)modifyMeWithFacebookDictionary:(NSDictionary *)facebookDictionary
{
    User2 *me = [GetMe sharedInstance].me;
    
    if(!me.facebook_id || !me.email){
        
        NSMutableDictionary *mutableDictionary = [[self dictionaryWithBasicDetailsFromFacebookDictionary:facebookDictionary] mutableCopy];
        [mutableDictionary setObject:facebookDictionary[FACEBOOK_EMAIL] forKey:USER_EMAIL];
        
        NSInteger genderInteger = 0;
        NSString *genderString = facebookDictionary[FACEBOOK_GENDER];
        if([genderString isEqualToString:@"male"]){
            genderInteger = 1;
        } else if([genderString isEqualToString:@"female"]) {
            genderInteger = 2;
        }
        
        [mutableDictionary setObject:@(genderInteger) forKey:USER_GENDER];
        [mutableDictionary setObject:facebookDictionary[FACEBOOK_UPDATED_TIME] forKey:USER_FACEBOOK_UPDATED_AT];
        
        [me modifyAttributesWithDictionary:mutableDictionary];
    }
}

-(NSMutableDictionary *)dictionaryWithBasicDetailsFromFacebookDictionary:(NSDictionary *)facebookDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:facebookDictionary[FACEBOOK_ID] forKey:USER_FACEBOOK_ID];
    [dictionary setObject:facebookDictionary[FACEBOOK_FIRST_NAME] forKey:USER_NAME_FIRST];
    [dictionary setObject:facebookDictionary[FACEBOOK_LAST_NAME] forKey:USER_NAME_LAST];
    
    return dictionary;
}

-(NSManagedObject *)createOrModifyObjectWithFacebookDictionary:(NSDictionary *)facebookDictionary
{
    NSLog(@"createOrModifyObjectWithFacebookDictionary... %@", facebookDictionary[FACEBOOK_ID]);
    User2 *user = (User2 *)[self findOrCreateManagedObjectForFacebookUserID:facebookDictionary[FACEBOOK_ID]];
    
    if(!user.facebook_id){
        NSLog(@"modifying");
        [user modifyAttributesWithDictionary:[self dictionaryWithBasicDetailsFromFacebookDictionary:facebookDictionary]];
    }
    
    return user;
}


-(NSManagedObject *)findOrCreateManagedObjectForFacebookUserID:(NSString *)facebookID
{
    NSManagedObject *managedObject;
    
    if(facebookID){
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER_ENTITY];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"facebook_id == %@",facebookID];
        
        NSError *error;
        NSArray *matches = [self.context executeFetchRequest:request error:&error];
        
        if(!matches || [matches count] > 1){
            NSLog(@"Error %@ - matches exists? %@; [matches count] = %lu",error,matches ? @"yes" : @"no",(unsigned long)[matches count]);
            
        } else if ([matches count] == 0) {
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:USER_ENTITY inManagedObjectContext:self.context];
            
        } else if ([matches count] == 1){
            managedObject = [matches lastObject];
            
        } else {
            // Error
            NSLog(@"Error - ManagedObject will be nil");
        }

    }
    
    return managedObject;
}












@end
