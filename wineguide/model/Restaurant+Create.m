//
//  Restaurant+Create.m
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant+Create.h"

#define ENTITY_NAME @"Restaurant"
#define DELETE_BOOL @"delete"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define LONGITUDE @"longitude"
#define LATITUDE @"latitude"
#define CITY @"city"
#define STREET @"street"
#define VERSION @"version"
#define IDENTIFIER @"identifier"
#define WINES @"wines"
#define BRANDS @"brands"
#define VARIETALS @"varietals"

@implementation Restaurant (Create)

+(Restaurant *)restaurantWithInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    Restaurant *restaurant = nil;
    
    NSString *restaurantIdentifier = dictionary[IDENTIFIER];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:restaurantIdentifier ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",restaurantIdentifier];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1){
        // Error
        NSLog(@"Error %@ - matches exists? %@; [matches count] = %i",error,matches ? @"yes" : @"no",[matches count]);
        
    } else if ([matches count] == 0 && [dictionary[DELETE_BOOL] boolValue] == NO){
        // Create new restaurant
        restaurant = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
        [restaurant modifyBasicInfoWithDictionary:dictionary inContext:context];
        
    } else if ([matches count] == 1){
        // Restaurant already exists
        restaurant = [matches lastObject];
        if([dictionary[MARK_FOR_DELETION] boolValue] == NO){
            [restaurant modifyBasicInfoWithDictionary:dictionary inContext:context];
        }
    } else {
        //Error
        NSLog(@"Error %@ - Restaurant %@ will be nil",error,dictionary[IDENTIFIER]);
    }
    
    return restaurant;
}

-(void)modifyBasicInfoWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    if(!self.version  || self.version < dictionary[VERSION]){
        NSLog(@"modifing restaurant...");
        self.markForDeletion = dictionary[MARK_FOR_DELETION];
        self.name = dictionary[NAME];
        self.longitude = dictionary[LONGITUDE];
        self.latitude = dictionary[LATITUDE];
        self.city = dictionary[CITY];
        self.street = dictionary[STREET];
        self.version = dictionary[VERSION];
        self.identifier = dictionary[IDENTIFIER];
    }
}

-(void)modifyWinesWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    NSLog(@"modify restaurant's wines");
}

@end
