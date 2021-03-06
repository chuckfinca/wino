//
//  ManagedObjectHandler.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ManagedObjectHandler.h"

#define IDENTIFIER @"identifier"
#define DELETED_ENTITY @"deletedEntity"

@implementation ManagedObjectHandler

+(NSManagedObject *)createOrReturnManagedObjectWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context usingDictionary:(NSDictionary *)dictionary
{
    NSManagedObject *managedObject = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:IDENTIFIER ascending:YES]];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1){
        // Error
        NSLog(@"Error %@ - matches exists? %@; [matches count] = %lu",error,matches ? @"yes" : @"no",(unsigned long)[matches count]);
        
    } else if ([matches count] == 0 && [dictionary[DELETED_ENTITY] boolValue] == NO) {
        // Create new managed object
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        
    } else if ([matches count] == 1){
        // Managed object already exists
            managedObject = [matches lastObject];
    } else {
        // Error
        NSLog(@"Error %@ - ManagedObject %@ will be nil",error,dictionary[IDENTIFIER]);
    }
    return managedObject;
}





@end