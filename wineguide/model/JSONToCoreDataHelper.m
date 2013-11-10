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
#define DIVIDER @"/"

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
        NSMutableSet *managedObjectSet = [[NSMutableSet alloc] init];
        for(NSDictionary *managedObjectDataDictionary in dictionary){
            NSManagedObject *mo = [self updateManagedObjectWithDictionary:managedObjectDataDictionary];
            [managedObjectSet addObject:mo];
        }
        [self updateRelationshipsForObjectSet:managedObjectSet];
    } else {
        NSLog(@"DataHelper context = nil");
    }
}

#pragma mark - Update Core Data

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    // abstract
    NSManagedObject *managedObject = nil;
    return managedObject;
}

-(void)updateNestedManagedObjectsLocatedAtKey:(NSString *)key inDictionary:(NSDictionary *)dictionary
{
    id obj = [dictionary sanitizedValueForKey:key];
    // The JSON may or may not have returned a nested JSON for this relationship.
    
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *arrayOfManagedObjectDictionaries = (NSArray *)obj;
        
        NSMutableSet *managedObjectSet = [[NSMutableSet alloc] init];
        for(id dictionaryObj in arrayOfManagedObjectDictionaries){
            if([dictionaryObj isKindOfClass:[NSDictionary class]]){
                NSDictionary *managedObjectDictionary = (NSDictionary *)dictionaryObj;
                NSManagedObject *mo = [self updateManagedObjectWithDictionary:managedObjectDictionary];
                [managedObjectSet addObject:mo];
            } else {
                NSLog(@"nested object from JSON is not a dictionary, it is class = %@",[obj class]);
            }
        }
        [self updateRelationshipsForObjectSet:managedObjectSet];
    }
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    // abstract
}



-(NSSet *)updateManagedObject:(NSManagedObject *)managedObject relationshipSet:(NSSet *)relationshipSet withIdentifiersString:(NSString *)identifiers
{
    // separate identifiers of managed objects that need to be joined to
    NSArray *identifiersArray = [identifiers componentsSeparatedByString:DIVIDER];
    NSLog(@"managedObject = %@",managedObject);
    NSLog(@"relationshipSet = %@",relationshipSet);
    NSLog(@"identifiers = %@",identifiers);
    NSLog(@"identifiersArray = %@",identifiersArray);
    NSMutableArray *compoundPredicateArray = [[NSMutableArray alloc] init];
    for (NSString *identifier in identifiersArray){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",identifier];
        NSLog(@"predicate = %@",[NSPredicate description]);
        [compoundPredicateArray addObject:predicate];
    }
    NSCompoundPredicate *compoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:compoundPredicateArray];
    
    NSLog(@"managedObject class = %@",[[managedObject class] description]);
    NSArray *matches = [self managedObjectWithEntityName:[[managedObject class] description] usingPredicate:compoundPredicate inContext:self.context];
    
    NSMutableSet *set = [relationshipSet mutableCopy];
    if(!set) set = [[NSMutableSet alloc] init];
    for(NSManagedObject *mo in matches){
        [set addObject:mo];
    }
    return set;
}

-(NSArray *)managedObjectWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] == 0){
        // Error
        NSLog(@"Error %@ - matches exists? %@; [matches count] = %i",error,matches ? @"yes" : @"no",[matches count]);
        return nil;
        
    } else if ([matches count] > 1) {
        // We found objects
        NSLog(@"We found objects!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        return matches;
        
    }  else {
        // Error
        NSLog(@"Error %@ ",error);
    }
    return matches;
}







@end

