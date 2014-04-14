//
//  serverHelper.h
//  Corkie
//
//  Created by Charles Feinn on 2/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define GROUP_ENTITY @"Group2"
#define RESTAURANT_ENTITY @"Restaurant2"
#define WINE_ENTITY @"Wine2"
#define WINE_UNIT_ENTITY @"WineUnit2"

#define ID_KEY @"id"
#define WINE_ID @"wine_id"
#define RESTAURANT_ID @"restaurant_id"
#define IDENTIFIER @"identifier"

@interface ServerHelper : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObject *relatedObject;

-(void)getDataAtUrl:(NSString *)url;

-(NSManagedObject *)findOrCreateManagedObjectEntityType:(NSString *)entityName
                                          andIdentifier:(NSNumber *)identifier;
-(void)createOrUpdateObjectsWithJsonInArray:(NSArray *)jsonArray andRelatedObject:(NSManagedObject *)managedObject;
-(NSSet *)addRelationToSet:(NSSet *)set;
-(void)addAdditionalRelativesToManagedObject:(NSManagedObject *)managedObject fromDictionary:(NSDictionary *)dictionary;
-(NSSet *)toManyRelationshipSetCreatedFromDictionariesArray:(NSArray *)dictionariesArray usingHelper:(ServerHelper *)serverHelper relatedObjectEntityType:(NSString *)entityType;

@end
