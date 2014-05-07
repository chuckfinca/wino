//
//  Region.h
//  Corkie
//
//  Created by Charles Feinn on 5/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wine2;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * region_description;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addWinesObject:(Wine2 *)value;
- (void)removeWinesObject:(Wine2 *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
