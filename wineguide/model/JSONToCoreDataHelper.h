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
@property (nonatomic, strong) NSManagedObject *parentManagedObject;

-(void)updateCoreDataWithJSONFromURL:(NSURL *)url;

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary; // abstract
-(NSPredicate *)predicateForDicitonary:(NSDictionary *)dictionary;

-(void)updateNestedManagedObjectsLocatedAtKey:(NSString *)key inDictionary:(NSDictionary *)dictionary;


-(NSArray *)managedObjectWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
-(NSSet *)updateManagedObject:(NSManagedObject *)managedObject relationshipSet:(NSSet *)relationshipSet withIdentifiersString:(NSString *)identifiers;

@end
