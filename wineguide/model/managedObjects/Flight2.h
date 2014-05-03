//
//  Flight2.h
//  Corkie
//
//  Created by Charles Feinn on 5/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant2, Wine2;

@interface Flight2 : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Restaurant2 *restaurant;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Flight2 (CoreDataGeneratedAccessors)

- (void)addWinesObject:(Wine2 *)value;
- (void)removeWinesObject:(Wine2 *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
