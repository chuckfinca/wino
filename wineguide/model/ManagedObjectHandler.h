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

+(NSManagedObject *)createOrReturnManagedObjectWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context usingDictionary:(NSDictionary *)dictionary;

@end
