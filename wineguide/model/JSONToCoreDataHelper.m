//
//  DataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "JSONToCoreDataHelper.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "IterationCounter.h"


#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"

#define DIVIDER @"/"

@interface JSONToCoreDataHelper ()

@property (nonatomic, strong) NSString *predicateString;

@end

@implementation JSONToCoreDataHelper

-(id)initWithContext:(NSManagedObjectContext *)context andRelatedObject:(NSManagedObject *)managedObject andNeededManagedObjectIdentifiersString:(NSString *)identifiers
{
    self = [super init];
    _context = context;
    _relatedObject = managedObject;
    _setOfIdentifiersThatNeedToBeTurnedIntoObjects = [NSMutableSet setWithArray:[identifiers componentsSeparatedByString:DIVIDER]];
    
    [IterationCounter sharedIterationCounter].counterOne++;
    if([IterationCounter sharedIterationCounter].counterOne % 100 == 0){
        NSLog(@"counterOne = %i",[IterationCounter sharedIterationCounter].counterOne);
    }
    
    return self;
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



#pragma mark - Server interaction

-(void)updateCoreDataWithJSONFromURL:(NSURL *)url
{
    dispatch_queue_t jsonQueue = dispatch_queue_create("JSON_Queue", NULL);
    dispatch_async(jsonQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        if(data){
            [self serializeData:data];
        } else {
            NSLog(@"data from JSON does not exist");
        }
    });
}

-(void)serializeData:(NSData *)data
{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:NSJSONReadingAllowFragments
                                                error:&error];
    dispatch_async(dispatch_get_main_queue(), ^{
        if([json isKindOfClass:[NSArray class]]){
            [self updateCoreDataWithDictionariesInArray:(NSArray *)json];
        } else {
            NSLog(@"json dictionary does not exist!");
            NSLog(@"error = %@",error);
        }
    });
}

-(void)updateCoreDataWithDictionariesInArray:(NSArray *)array
{
    if(self.context){
        [self updateManagedObjectsWithDictionariesInArray:array];
    } else {
        NSLog(@"DataHelper context = nil");
    }
}

-(void)updateManagedObjectsWithDictionariesInArray:(NSArray *)managedObjectDictionariesArray
{
    for(id obj in managedObjectDictionariesArray){
        if([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *managedObjectDictionary = (NSDictionary *)obj;
            NSManagedObject *mo = [self createOrModifyManagedObjectWithDictionary:managedObjectDictionary];
            [self.setOfIdentifiersThatNeedToBeTurnedIntoObjects removeObject:mo.identifier];
        }
    }
    [self createPlaceholderForObjectInSet:self.setOfIdentifiersThatNeedToBeTurnedIntoObjects];
}


#pragma mark - Update Core Data


-(NSManagedObject *)createOrModifyManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    NSManagedObject *mo = [self updateManagedObjectWithDictionary:dictionary];
    [self addRelationToManagedObject:mo];
    
    [IterationCounter sharedIterationCounter].counterTwo++;
    if([IterationCounter sharedIterationCounter].counterTwo % 100 == 0) {
        NSLog(@"counterTwo = %i",[IterationCounter sharedIterationCounter].counterTwo);
    }
    
    return mo;
}

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    // abstract
    // for each set of managed objects related to the object returned from this method updateNestedManagedObjectsLocatedAtKey:inDictionary:
    // will be called (by a DataHelper specific to that type of entity)
    NSManagedObject *managedObject = nil;
    return managedObject;
}


-(void)updateNestedManagedObjectsLocatedAtKey:(NSString *)key inDictionary:(NSDictionary *)dictionary
{
    id nestedObjects = [dictionary sanitizedValueForKey:key];
    
    // check for nested JSON
    if([nestedObjects isKindOfClass:[NSArray class]]){
        [self updateManagedObjectsWithDictionariesInArray:(NSArray *)nestedObjects];
    }
    [self createPlaceholderForObjectInSet:self.setOfIdentifiersThatNeedToBeTurnedIntoObjects];
}



#pragma mark - Relationships

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    // we need to add self.relatedObject to one of managedObjects sets
}

-(NSSet *)addRelationToSet:(NSSet *)set
{
    NSMutableSet *mutableSet = [set mutableCopy];
    if(![mutableSet containsObject:self.relatedObject]) [mutableSet addObject:self.relatedObject];
    return mutableSet;
}

#pragma Placeholder Objects

-(void)createPlaceholderForObjectInSet:(NSSet *)set
{
    if([self.setOfIdentifiersThatNeedToBeTurnedIntoObjects count] > 0){
        for(NSString *identifier in set){
            if([identifier length] > 0){
                NSDictionary *managedObjectDictionary = @{IDENTIFIER : identifier, IS_PLACEHOLDER : @YES};
                [self createOrModifyManagedObjectWithDictionary:managedObjectDictionary];
            }
        }
    }
}







@end

