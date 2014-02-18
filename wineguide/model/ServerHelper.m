//
//  serverHelper.m
//  Corkie
//
//  Created by Charles Feinn on 2/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ServerHelper.h"
#import <AFNetworking.h>
#import "DocumentHandler.h"

#define IDENTIFIER @"id"

@interface ServerHelper ()

@property (nonatomic, readwrite) NSManagedObjectContext *context;
@property (nonatomic, strong) NSString *predicateString;
@property (nonatomic, strong) NSPredicate *predicate;

@end

@implementation ServerHelper

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
        NSArray *returnedArray = (NSArray *)responseObject;
        
        [returnedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *dictionary = (NSDictionary *)obj;
                if([dictionary objectForKey:IDENTIFIER]){
                    [self createOrModifyObjectWithDictionary:dictionary];
                }
            } else {
                NSLog(@"obj in responseObject array is not a dictionary, it is a %@",[obj class]);
            }
        }];
    } else {
        NSLog(@"Response object is NOT an array, it is a %@", [responseObject class]);
    }
}

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    // abstract
    return [[NSManagedObject alloc] init];
}

#pragma mark - Getters & Setters

-(NSManagedObjectContext *)context
{
    if(!_context) {
        _context = [DocumentHandler sharedDocumentHandler].document.managedObjectContext;
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

-(NSPredicate *)predicateForDicitonary:(NSDictionary *)dictionary
{
    NSDictionary *variables = @{@"IDENTIFIER" : dictionary[IDENTIFIER]};
    return [self.predicate predicateWithSubstitutionVariables:variables];
}

@end
