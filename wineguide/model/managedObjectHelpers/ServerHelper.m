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
#import "ManagedObjectFetcher.h"

@interface ServerHelper ()

@property (nonatomic, strong) NSString *predicateString;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, readwrite) NSManagedObject *relatedObject;
@property (nonatomic, strong) ManagedObjectFetcher *managedObjectFetcher;

@end

@implementation ServerHelper

#pragma mark - Getters & setters

-(ManagedObjectFetcher *)managedObjectFetcher
{
    if(!_managedObjectFetcher){
        _managedObjectFetcher = [[ManagedObjectFetcher alloc] init];
    }
    return _managedObjectFetcher;
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
        [self processJSON:responseObject withRelatedObject:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        NSLog(@"At this point we need to try again and/or display some sort of error to the user. Telling them what happened and what to do about it");
    }];
}

-(void)processJSON:(id)json withRelatedObject:(NSManagedObject *)relatedObject
{
    if(relatedObject){
        self.relatedObject = relatedObject;
    }
    
    if([json isKindOfClass:[NSArray class]]){
        [json enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self ensureIsDictionaryAndProcessObject:obj];
        }];
    } else {
        [self ensureIsDictionaryAndProcessObject:json];
    }
}

-(void)ensureIsDictionaryAndProcessObject:(id)obj
{
    if([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *dictionary = (NSDictionary *)obj;
        if(dictionary[ID_KEY]){
            [self createObjectFromDictionary:dictionary];
        } else {
            NSLog(@"dictionary does not have key = %@",ID_KEY);
        }
    } else {
        NSLog(@"obj in responseObject array is not a dictionary, it is a %@",[obj class]);
    }
}

-(NSManagedObject *)createObjectFromDictionary:(NSDictionary *)dictionary
{
    NSManagedObject *mo = [self createOrModifyObjectWithDictionary:dictionary];
    if(self.relatedObject){
        [self addRelationToManagedObject:mo];
    }
    [self processManagedObject:mo relativesFoundInDictionary:dictionary];
    
    // [mo description]; // to look at created object properties and relationships
    return mo;
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
    if(![mutableSet containsObject:self.relatedObject]) {
        [mutableSet addObject:self.relatedObject];
    }
    return mutableSet;
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    // Abstract
}


-(NSManagedObject *)findOrCreateManagedObjectEntityType:(NSString *)entityName usingDictionary:(NSDictionary *)dictionary
{
    NSManagedObject *mo;
    NSNumber *identifier = (NSNumber *)dictionary[ID_KEY];
    
    if(identifier){
        mo = [self.managedObjectFetcher findOrCreateManagedObjectEntityType:entityName usingDictionary:dictionary andPredicate:[self predicateForEntityIdentifier:identifier]];
    }
    return mo;
}










@end
