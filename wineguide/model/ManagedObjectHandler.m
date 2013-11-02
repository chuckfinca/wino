//
//  ManagedObjectHandler.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ManagedObjectHandler.h"

#define IDENTIFIER @"identifier"
#define NAME @"name"
#define MARK_FOR_DELETION @"markForDeletion"

@implementation ManagedObjectHandler

+(NSManagedObject *)createOrReturnManagedObjectWithEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context usingDictionary:(NSDictionary *)dictionary
{
    NSManagedObject *managedObject = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:IDENTIFIER ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",dictionary[IDENTIFIER]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1){
        // Error
        NSLog(@"Error %@ - matches exists? %@; [matches count] = %lu",error,matches ? @"yes" : @"no",(unsigned long)[matches count]);
        
    } else if ([matches count] == 0 && [dictionary[MARK_FOR_DELETION] boolValue] == NO) {
        // Create new managed object
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            // [ManagedObjectHandler logIdentifierWithString:@"create 1" ofManagedObject:managedObject];
        
    } else if ([matches count] == 1){
        // Managed object already exists
        if([dictionary[MARK_FOR_DELETION] boolValue] == NO){
            managedObject = [matches lastObject];
                // [ManagedObjectHandler logIdentifierWithString:@"return 1" ofManagedObject:managedObject];
        }
    } else {
        // Error
        NSLog(@"Error %@ - ManagedObject %@ will be nil",error,dictionary[IDENTIFIER]);
    }
    return managedObject;
}


+(NSManagedObject *)createOrReturnManagedObjectWithEntityName:(NSString *)entityName andNameAttribute:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    // this method can only used for Entities that do have unique names!!
    
    NSManagedObject *managedObject = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NAME ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1){
        // Error
        NSLog(@"Error %@ - matches exists? %@; [matches count] = %lu",error,matches ? @"yes" : @"no",(unsigned long)[matches count]);
        
    } else if ([matches count] == 0) {
        // Create new managed object
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            // [ManagedObjectHandler logIdentifierWithString:@"create 2" ofManagedObject:managedObject];
        
    } else if ([matches count] == 1){
        // Managed object already exists
        managedObject = [matches lastObject];
            // [ManagedObjectHandler logIdentifierWithString:@"return 2" ofManagedObject:managedObject];
        
    } else {
        // Error
        NSLog(@"Error %@ - ManagedObject %@ will be nil",error,name);
    }
    return managedObject;
}

+(void)logIdentifierWithString:(NSString *)string ofManagedObject:(NSManagedObject *)obj
{
    if([obj respondsToSelector:@selector(identifier)]){
        NSLog(@"%@ identifier = %@ and class %@",string,[obj performSelector:@selector(identifier)], [obj class]);
    }
}

+(NSManagedObject *)getManagedObjectWithEntityName:(NSString *)entityName andIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context
{
    NSManagedObject *managedObject = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:IDENTIFIER ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",identifier];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1){
        // Error
        NSLog(@"Error %@ - matches exists? %@; [matches count] = %lu",error,matches ? @"yes" : @"no",(unsigned long)[matches count]);
        
    } else if ([matches count] == 0) {
        // Create new managed object
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            // [ManagedObjectHandler logIdentifierWithString:@"get - create" ofManagedObject:managedObject];
        
    } else if ([matches count] == 1){
        // Managed object already exists
        managedObject = [matches lastObject];
            // [ManagedObjectHandler logIdentifierWithString:@"get - return" ofManagedObject:managedObject];
        
    } else {
        // Error
        NSLog(@"3 Error %@ - ManagedObject %@ will be nil",error,identifier);
    }
    return managedObject;
}


@end