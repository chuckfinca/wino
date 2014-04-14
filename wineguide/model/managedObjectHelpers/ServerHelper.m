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
        
    } else if([responseObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        if(dictionary[ID_KEY]){
            [self processDictionary:dictionary withRelatedObject:nil];
        } else {
            NSLog(@"dictionary does not have key = %@",ID_KEY);
        }
    } else {
        NSLog(@"Response object from server is not an array or a dictionary");
    }
}

-(void)createOrUpdateObjectsWithJsonInArray:(NSArray *)jsonArray andRelatedObject:(NSManagedObject *)relatedObject
{
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *dictionary = (NSDictionary *)obj;
                if(dictionary[ID_KEY]){
                    [self processDictionary:dictionary withRelatedObject:relatedObject];
                } else {
                    NSLog(@"dictionary does not have key = %@",ID_KEY);
                }
            } else {
                NSLog(@"obj in responseObject array is not a dictionary, it is a %@",[obj class]);
            }
        }];
}

-(void)processDictionary:(NSDictionary *)dictionary withRelatedObject:(NSManagedObject *)relatedObject
{
    NSManagedObject *mo = [self createOrModifyObjectWithDictionary:dictionary];
    if(relatedObject){
        self.relatedObject = relatedObject;
        [self addRelationToManagedObject:mo];
    }
    [self addAdditionalRelativesToManagedObject:mo fromDictionary:dictionary];
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

-(void)addAdditionalRelativesToManagedObject:(NSManagedObject *)managedObject fromDictionary:(NSDictionary *)dictionary
{
    // Abstract
}

-(NSSet *)toManyRelationshipSetCreatedFromDictionariesArray:(NSArray *)dictionariesArray usingHelper:(ServerHelper *)serverHelper relatedObjectEntityType:(NSString *)entityType
{
    NSMutableSet *set;
    if(dictionariesArray > 0){
        set = [[NSMutableSet alloc] init];
        for(NSDictionary *dictionary in dictionariesArray){
            NSManagedObject *mo = [serverHelper findOrCreateManagedObjectEntityType:entityType andIdentifier:dictionary[ID_KEY]];
            [set addObject:mo];
        }
    }
    return set;
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
