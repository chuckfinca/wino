//
//  ManagedObjectHandler.h
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagedObjectHandler : NSObject

+(NSManagedObject *)createOrReturnManagedObjectWithEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context usingDictionary:(NSDictionary *)dictionary;
+(NSManagedObject *)createOrReturnManagedObjectWithEntityName:(NSString *)entityName andNameAttribute:(NSString *)name inContext:(NSManagedObjectContext *)context;  // this method can only be used for Entities that do have unique names!!

+(NSManagedObject *)getManagedObjectWithEntityName:(NSString *)entityName andIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;

@end
