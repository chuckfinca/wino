//
//  Restaurant+Create.m
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant+CreateAndModify.h"

#define ENTITY_NAME @"Restaurant"
#define DELETE_BOOL @"delete"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define LONGITUDE @"longitude"
#define LATITUDE @"latitude"
#define ADDRESS @"address"
#define CITY @"city"
#define STATE @"state"
#define VERSION @"version"
#define IDENTIFIER @"identifier"
#define WINES @"wines"
#define BRANDS @"brands"
#define VARIETALS @"varietals"

@implementation Restaurant (CreateAndModify)

+(Restaurant *)restaurantWithInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    Restaurant *restaurant = nil;
    NSLog(@"dictionary[IDENTIFIER] = %@",dictionary[IDENTIFIER]);
    NSString *restaurantIdentifier = dictionary[IDENTIFIER];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:IDENTIFIER ascending:YES]];
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
        if([dictionary[MARK_FOR_DELETION] boolValue] == NO && restaurant.version < dictionary[VERSION]){
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
    self.markForDeletion = dictionary[MARK_FOR_DELETION] ? dictionary[MARK_FOR_DELETION] : @NO;
    self.name = dictionary[NAME];
    self.longitude = dictionary[LONGITUDE];
    self.latitude = dictionary[LATITUDE];
    self.address = dictionary[ADDRESS];
    self.city = dictionary[CITY];
    self.state = dictionary[STATE];
    self.version = dictionary[VERSION];
    self.identifier = dictionary[IDENTIFIER];
}

-(void)modifyWinesWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    NSLog(@"modify restaurant's wines");
}

@end
