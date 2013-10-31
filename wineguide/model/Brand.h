//
//  Brand.h
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, Varietal, Wine;

@interface Brand : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSSet *restaurants;
@property (nonatomic, retain) NSSet *varietals;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Brand (CoreDataGeneratedAccessors)

- (void)addRestaurantsObject:(Restaurant *)value;
- (void)removeRestaurantsObject:(Restaurant *)value;
- (void)addRestaurants:(NSSet *)values;
- (void)removeRestaurants:(NSSet *)values;

- (void)addVarietalsObject:(Varietal *)value;
- (void)removeVarietalsObject:(Varietal *)value;
- (void)addVarietals:(NSSet *)values;
- (void)removeVarietals:(NSSet *)values;

- (void)addWinesObject:(Wine *)value;
- (void)removeWinesObject:(Wine *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
