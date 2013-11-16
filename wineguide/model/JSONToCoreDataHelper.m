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


#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
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
    NSMutableSet *managedObjectSet = [[NSMutableSet alloc] init];
    for(id obj in managedObjectDictionariesArray){
        if([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *managedObjectDictionary = (NSDictionary *)obj;
            
            NSManagedObject *mo = [self updateManagedObjectWithDictionary:managedObjectDictionary];
            [managedObjectSet addObject:mo];
        }
    }
    [self updateRelationshipsForObjectSet:managedObjectSet];
}

#pragma mark - Update Core Data

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
}


-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    // abstract
    // calls updateRelationshipSet:ofEntitiesNamed:withIdentifiersString: for each set of managed objects related to the
}


-(NSSet *)updateRelationshipSet:(NSSet *)relationshipSet ofEntitiesNamed:(NSString *)entityName usingIdentifiersString:(NSString *)identifiers
{
    // separate identifiers
    NSMutableArray *relatedIdentifiersArray = [[identifiers componentsSeparatedByString:DIVIDER] mutableCopy];
    
    // create a compound OR predicate with all the identifiers
    NSMutableArray *compoundPredicateArray = [[NSMutableArray alloc] init];
    for (NSString *identifier in relatedIdentifiersArray){
        
        NSDictionary *variables = @{@"IDENTIFIER" : identifier};
        [compoundPredicateArray addObject:[self.predicate predicateWithSubstitutionVariables:variables]];
    }
    NSCompoundPredicate *compoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:compoundPredicateArray];
    
    // get all entities with name 'entityName' that have identifiers that were in the identifiers string
    NSArray *matches = [self managedObjectWithEntityName:entityName usingPredicate:compoundPredicate inContext:self.context];
    
    NSLog(@"matches count = %i",[matches count]);
    NSMutableSet *set = set = [relationshipSet mutableCopy];
    
    if(matches){
        // take the current relationship set and add all of the matches to it
        if(!set) set = [[NSMutableSet alloc] init];
        
        for(NSManagedObject *mo in matches){
            if(![set containsObject:mo]) {
                [set addObject:mo];
            }
            // remove identifier from relatedIdentifierArray
            [relatedIdentifiersArray removeObject:mo.identifier];
        }
    }
    
    // after previous for loop we are left with only identifiers for objects that do not yet exist.
    NSMutableArray *managedObjectPlaceholdersThatNeedToBeCreated = [[NSMutableArray alloc] init];
    for(NSString *identifier in relatedIdentifiersArray){
        if([identifier length] > 0){
            
            NSDictionary *managedObjectDictionary = @{IDENTIFIER : identifier, IS_PLACEHOLDER : @YES};
            [managedObjectPlaceholdersThatNeedToBeCreated addObject:managedObjectDictionary];
        }
    }
    if([managedObjectPlaceholdersThatNeedToBeCreated count] > 0) {
        [self updateManagedObjectsWithEntityName:entityName withDictionariesInArray:managedObjectPlaceholdersThatNeedToBeCreated];
    }
    
    return set;
}

-(void)updateManagedObjectsWithEntityName:(NSString *)entityName withDictionariesInArray:(NSArray *)managedObjectDictionariesArray
{
    // abstract
}

-(NSArray *)managedObjectWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSArray *matches = nil;
    
    if(entityName){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
        request.predicate = predicate;
        
        NSError *error = nil;
        matches = [context executeFetchRequest:request error:&error];
        
        if(!matches){
            // Error
            NSLog(@"Error %@ - matches exists? %@; [matches count] = %i",error,matches ? @"yes" : @"no",[matches count]);
            return nil;
            
        } else if([matches count] == 0){
            //NSLog(@"[matches count] = %i",[matches count]);
            return nil;
        } else if([matches count] > 0) {
            // We found objects
            //NSLog(@"[matches count] = %i",[matches count]);
            return matches;
            
        }  else {
            // Error
            NSLog(@"Error %@ ",error.description);
        }
    }
    return matches;
}












@end

