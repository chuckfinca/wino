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

@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObject *parentManagedObject;

-(id)initWithContext:(NSManagedObjectContext *)context; // designated initializer
-(void)updateCoreDataWithJSONFromURL:(NSURL *)url;

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary; // abstract
-(NSPredicate *)predicateForDicitonary:(NSDictionary *)dictionary;

-(void)updateNestedManagedObjectsLocatedAtKey:(NSString *)key inDictionary:(NSDictionary *)dictionary;

@end
