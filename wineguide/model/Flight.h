//
//  Flight.h
//  wineguide
//
//  Created by Charles Feinn on 11/8/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, Wine;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastAccessed;
@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * wineIdentifiers;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Flight (CoreDataGeneratedAccessors)

- (void)addWinesObject:(Wine *)value;
- (void)removeWinesObject:(Wine *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
