//
//  serverHelper.m
//  Corkie
//
//  Created by Charles Feinn on 2/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ServerHelper.h"
#import <AFNetworking.h>
#import "DocumentHandler2.h"
#import "ManagedObjectHandler.h"

#define SERVER_IDENTIFIER @"id"

@interface ServerHelper ()

@property (nonatomic, readwrite) NSManagedObjectContext *context;
@property (nonatomic, strong) NSString *predicateString;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, readwrite) NSManagedObject *relatedObject;

@end

@implementation ServerHelper

#pragma mark - Getters & Setters

-(NSManagedObjectContext *)context
{
    if(!_context) {
        _context = [DocumentHandler2 sharedDocumentHandler].document.managedObjectContext;
        if(!_context){
            NSLog(@"ServerHelper - Context does not exist!");
        }
    }
    return _context;
}

#pragma mark - Predicates

-(NSString *)predicateString
{
    if(!_predicateString) _predicateString = [NSString stringWithFormat:@"identifier = $IDENTIFIER"];
    return _predicateString;
}

-(NSPredicate *)predicate
{
    if(!_predicate) _predicate = [NSPredicate predicateWithFormat:self.predicateString];
    return _predicate;
}

-(NSPredicate *)predicateForEntityIdentifier:(NSNumber *)identifier
{
    NSDictionary *variables = @{@"IDENTIFIER" : identifier};
    return [self.predicate predicateWithSubstitutionVariables:variables];
}





-(void)getDataAtUrl:(NSString *)url
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableSet *set = [manager.responseSerializer.acceptableContentTypes mutableCopy];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

-(void)processResponseObject:(id)responseObject
{
    if([responseObject isKindOfClass:[NSArray class]]){
        [self createOrUpdateObjectsWithJsonInArray:(NSArray *)responseObject andRelatedObject:nil];
        
    } else {
        NSLog(@"Response object is NOT an array, it is a %@", [responseObject class]);
    }
}

-(void)createOrUpdateObjectsWithJsonInArray:(NSArray *)jsonArray andRelatedObject:(NSManagedObject *)managedObject
{
    [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *dictionary = (NSDictionary *)obj;
            if(dictionary[SERVER_IDENTIFIER]){
                NSManagedObject *mo = [self createOrModifyObjectWithDictionary:dictionary];
                if(managedObject){
                    self.relatedObject = managedObject;
                    [self addRelationToManagedObject:mo];
                }
            } else {
                NSLog(@"dictionary does not have key = %@",SERVER_IDENTIFIER);
            }
        } else {
            NSLog(@"obj in responseObject array is not a dictionary, it is a %@",[obj class]);
        }
    }];
}

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    // Abstract
    return [[NSManagedObject alloc] init];
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    // Abstract
}

-(NSSet *)addRelationToSet:(NSSet *)set
{
    NSMutableSet *mutableSet = [set mutableCopy];
    if(![mutableSet containsObject:self.relatedObject]) [mutableSet addObject:self.relatedObject];
    return mutableSet;
}


-(NSManagedObject *)findOrCreateManagedObjectEntityType:(NSString *)entityName andIdentifier:(NSNumber *)identifier
{
    NSManagedObject *managedObject;
    
    if(identifier > 0){
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:IDENTIFIER ascending:YES]];
        
        request.predicate = [self predicateForEntityIdentifier:identifier];
        
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
    }
    
    
    return managedObject;
}








@end
