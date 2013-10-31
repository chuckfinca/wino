//
//  Varietal.h
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand, Restaurant, Wine;

@interface Varietal : NSManagedObject

@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSSet *brands;
@property (nonatomic, retain) NSSet *restaurants;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Varietal (CoreDataGeneratedAccessors)

- (void)addBrandsObject:(Brand *)value;
- (void)removeBrandsObject:(Brand *)value;
- (void)addBrands:(NSSet *)values;
- (void)removeBrands:(NSSet *)values;

- (void)addRestaurantsObject:(Restaurant *)value;
- (void)removeRestaurantsObject:(Restaurant *)value;
- (void)addRestaurants:(NSSet *)values;
- (void)removeRestaurants:(NSSet *)values;

- (void)addWinesObject:(Wine *)value;
- (void)removeWinesObject:(Wine *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
