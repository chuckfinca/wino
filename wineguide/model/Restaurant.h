//
//  Restaurant.h
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand, Varietal, Wine;

@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSSet *brands;
@property (nonatomic, retain) NSSet *varietals;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Restaurant (CoreDataGeneratedAccessors)

- (void)addBrandsObject:(Brand *)value;
- (void)removeBrandsObject:(Brand *)value;
- (void)addBrands:(NSSet *)values;
- (void)removeBrands:(NSSet *)values;

- (void)addVarietalsObject:(Varietal *)value;
- (void)removeVarietalsObject:(Varietal *)value;
- (void)addVarietals:(NSSet *)values;
- (void)removeVarietals:(NSSet *)values;

- (void)addWinesObject:(Wine *)value;
- (void)removeWinesObject:(Wine *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
