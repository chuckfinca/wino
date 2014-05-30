//
//  ManagedObjectCreator.m
//  Corkie
//
//  Created by Charles Feinn on 5/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ManagedObjectFetcher.h"
#import "DocumentHandler2.h"

#define IDENTIFIER @"identifier"

@interface ManagedObjectFetcher ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end


@implementation ManagedObjectFetcher

#pragma mark - Getters & setters

-(NSManagedObjectContext *)context
{
    if(!_context){
        _context = [DocumentHandler2 sharedDocumentHandler].document.managedObjectContext;
    }
    return _context;
}


-(NSManagedObject *)findOrCreateManagedObjectEntityType:(NSString *)entityName usingDictionary:(NSDictionary *)dictionary andPredicate:(NSPredicate *)predicate
{
    NSManagedObject *managedObject;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:IDENTIFIER ascending:YES]];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1){
        NSLog(@"Error %@ - matches exists? %@; [matches count] = %lu",error,matches ? @"yes" : @"no",(unsigned long)[matches count]);
        
    } else if ([matches count] == 0) {
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
        
    } else if ([matches count] == 1){
        managedObject = [matches lastObject];
        
    } else {
        // Error
        NSLog(@"Error - ManagedObject will be nil");
    }
    
    return managedObject;
}







@end
