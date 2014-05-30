//
//  ManagedObjectCreator.h
//  Corkie
//
//  Created by Charles Feinn on 5/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagedObjectFetcher : NSObject

-(NSManagedObject *)findOrCreateManagedObjectEntityType:(NSString *)entityName usingDictionary:(NSDictionary *)dictionary andPredicate:(NSPredicate *)predicate;

@end
