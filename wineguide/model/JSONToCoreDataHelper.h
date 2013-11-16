//
//  DataHelper.h
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JSONToCoreDataHelper : NSObject

-(id)initWithContext:(NSManagedObjectContext *)context; // designated initializer

@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, weak) NSManagedObjectContext *context;

-(void)updateCoreDataWithJSONFromURL:(NSURL *)url;

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary; // abstract
-(NSPredicate *)predicateForDicitonary:(NSDictionary *)dictionary;

// Called by managed object categories insearch of nested JSON
-(void)updateNestedManagedObjectsLocatedAtKey:(NSString *)key inDictionary:(NSDictionary *)dictionary;

// Called by DataHelpers to update relationships for a set of managed objects that were just created and/or modified
-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet;

// Called by DataHelpers to update one type of relationship for a given managed object
-(NSSet *)updateRelationshipSet:(NSSet *)relationshipSet ofEntitiesNamed:(NSString *)entityName usingIdentifiersString:(NSString *)identifiers;

// Called by DataHelpers to create the appropriate DataHelpers
-(void)updateManagedObjectsWithEntityName:(NSString *)entityName withDictionariesInArray:(NSArray *)managedObjectDictionariesArray; // abstract

// Called by DataHelpers created by updateManagedObjectsWithEntityName:withDictionariesInArray: to create necessary placeholder entities
-(void)updateManagedObjectsWithDictionariesInArray:(NSArray *)managedObjectDictionariesArray;

@end
