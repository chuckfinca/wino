//
//  DataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "JSONToCoreDataHelper.h"
#import "NSDictionary+Helper.h"


#define IDENTIFIER @"identifier"

@interface JSONToCoreDataHelper ()

@property (nonatomic, strong) NSString *predicateString;

@end

@implementation JSONToCoreDataHelper

-(id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    _context = context;
    return self;
}


#pragma mark - Getters & Setters


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



#pragma mark - Server interaction

-(void)updateCoreDataWithJSONFromURL:(NSURL *)url
{
    dispatch_queue_t jsonQueue = dispatch_queue_create("JSON_Queue", NULL);
    dispatch_async(jsonQueue, ^{
        NSLog(@"url = %@",url);
        NSData *data = [NSData dataWithContentsOfURL:url];
        if(data){
            [self prepareSerializedData:data];
        } else {
            NSLog(@"data from JSON does not exist");
        }
    });
}

-(void)prepareSerializedData:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(json){
            [self updateCoreDataWithDictionaryObjectsInDictionary:json];
        } else {
            NSLog(@"json dictionary does not exist!");
        }
    });
}

-(void)updateCoreDataWithDictionaryObjectsInDictionary:(NSDictionary *)dictionary
{
    if(self.context){
        for(NSDictionary *managedObjectDataDictionary in dictionary){
            [self updateManagedObjectWithDictionary:managedObjectDataDictionary];
        }
        [self updateRelationships];
    } else {
        NSLog(@"DataHelper context = nil");
    }
}



#pragma mark - Update Core Data

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    // abstract
}

-(void)updateNestedManagedObjectsLocatedAtKey:(NSString *)key inDictionary:(NSDictionary *)dictionary
{
    id obj = [dictionary sanitizedValueForKey:key];
    // The JSON may or may not have returned a nested JSON for this relationship.
    
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *arrayOfManagedObjectDictionaries = (NSArray *)obj;
        
        for(id dictionaryObj in arrayOfManagedObjectDictionaries){
            if([dictionaryObj isKindOfClass:[NSDictionary class]]){
                NSDictionary *managedObjectDictionary = (NSDictionary *)dictionaryObj;
                [self updateManagedObjectWithDictionary:managedObjectDictionary];
            } else {
                NSLog(@"nested object from JSON is not a dictionary, it is class = %@",[obj class]);
            }
        }
        [self updateRelationships];
    }
}

-(void)updateRelationships
{
    // abstract
}








@end

