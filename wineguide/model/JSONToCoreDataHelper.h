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

-(void)updateNestedManagedObjectsLocatedAtKey:(NSString *)key inDictionary:(NSDictionary *)dictionary;

-(NSSet *)updateRelationshipSet:(NSSet *)relationshipSet ofEntitiesNamed:(NSString *)entityName usingIdentifiersString:(NSString *)identifiers;

@end
