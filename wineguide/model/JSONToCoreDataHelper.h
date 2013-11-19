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

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSManagedObject *relatedObject;
@property (nonatomic, strong) NSMutableSet *setOfIdentifiersThatNeedToBeTurnedIntoObjects;



-(id)initWithContext:(NSManagedObjectContext *)context andRelatedObject:(NSManagedObject *)managedObject andNeededManagedObjectIdentifiersString:(NSString *)identifiers; // designated initializer


-(void)updateCoreDataWithJSONFromURL:(NSURL *)url;
-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary; // abstract
-(NSPredicate *)predicateForDicitonary:(NSDictionary *)dictionary;


// Called by managed object categories insearch of nested JSON
-(void)updateNestedManagedObjectsLocatedAtKey:(NSString *)key inDictionary:(NSDictionary *)dictionary;

// Methods that create placeholder objects and add relationships
-(void)addRelationToManagedObject:(NSManagedObject *)managedObject;
-(NSSet *)addRelationToSet:(NSSet *)set;

@end
