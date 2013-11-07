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
    NSLog(@"dictionary = %@",dictionary);
    NSDictionary *variables = @{@"IDENTIFIER" : dictionary[IDENTIFIER]};
    return [self.predicate predicateWithSubstitutionVariables:variables];
}



#pragma mark - Server interaction

-(void)updateCoreDataWithJSONFromURL:(NSURL *)url
{
    dispatch_queue_t jsonQueue = dispatch_queue_create("JSON_Queue", NULL);
    dispatch_async(jsonQueue, ^{
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
            NSLog(@"json does not exist!");
        }
    });
}

-(void)updateCoreDataWithDictionaryObjectsInDictionary:(NSDictionary *)dictionary
{
    if(self.context){
        for(NSDictionary *managedObjectDataDictionary in dictionary){
            [self updateManagedObjectWithDictionary:managedObjectDataDictionary];
        }
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
    id managedObjectInfo = [dictionary objectForKeyNotNull:key];
    // The JSON may or may not have returned a nested JSON for this relationship. If it did then update these items with the nested JSON
    if([managedObjectInfo isKindOfClass:[NSDictionary class]]){
        NSDictionary *entitiesDictionary = [dictionary objectForKeyNotNull:key];
        
        if(entitiesDictionary){
            for(NSDictionary *entityDictionary in entitiesDictionary){
                [self updateManagedObjectWithDictionary:entityDictionary];
            }
        }
    } else {
        NSLog(@"id managedObjectInfo is class %@ - %@",[managedObjectInfo class], managedObjectInfo);
        NSLog(@"The above should be a string list of managedObject.identifiers separated by /");
        
        if([managedObjectInfo isKindOfClass:[NSString class]]){
            NSString *relationshipIdentifiersString = (NSString *)managedObjectInfo;
            
            [self setRelationIdentifiersAttribute:relationshipIdentifiersString];
            // save this list for use once we have imported the necessary data.
            
            // [self.parentManagedObject class] + self.parentManagedObject.identifier + key + string of managedObject.identifiers will give us everything we need.
            // in other words we need to know:
            // the TYPE OF managedObject that is the parent
            // the IDENTIFER of the parent in that type of entity
            // the KEY, which identifies the relationship and can be used to figure out what type of managedObject the children are
            // the STRING that is a / separated list of the identifers which the parent is related to
            
            // @{ CLASS_OF_PARENT : [NSString stringWithFormat:@"%@",[Parent class]], IDENTIFIER_OF_PARENT : [NSString stringWithFormat:@"%@",parent.identifier], RELATIONSHIP : KEY, LIST_OF_CHILD_IDENTIFIERS : STRING }
            
            // each time a child is created it should ask itself if it should connect itself to a parent (which has already been created, since the list of these relationships should only be created after the parent has been otherwise created).
            
            // dictionary with keys that are managedObject.identifier's
        }
    }
}


-(void)setRelationIdentifiersAttribute:(NSString *)string
{
    // abstract
}













@end

