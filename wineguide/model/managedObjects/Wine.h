//
//  Wine.h
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand, Recommendation, Restaurant, TastingNote, Varietal;

@interface Wine : NSManagedObject

@property (nonatomic, retain) NSNumber * alcoholPercentage;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * dessert;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastAccessed;
@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSNumber * sparkling;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSNumber * vintage;
@property (nonatomic, retain) NSString * vineyard;
@property (nonatomic, retain) Brand *brand;
@property (nonatomic, retain) NSSet *recommendedAs;
@property (nonatomic, retain) NSSet *restaurants;
@property (nonatomic, retain) NSSet *tastingNotes;
@property (nonatomic, retain) NSSet *varietals;
@end

@interface Wine (CoreDataGeneratedAccessors)

- (void)addRecommendedAsObject:(Recommendation *)value;
- (void)removeRecommendedAsObject:(Recommendation *)value;
- (void)addRecommendedAs:(NSSet *)values;
- (void)removeRecommendedAs:(NSSet *)values;

- (void)addRestaurantsObject:(Restaurant *)value;
- (void)removeRestaurantsObject:(Restaurant *)value;
- (void)addRestaurants:(NSSet *)values;
- (void)removeRestaurants:(NSSet *)values;

- (void)addTastingNotesObject:(TastingNote *)value;
- (void)removeTastingNotesObject:(TastingNote *)value;
- (void)addTastingNotes:(NSSet *)values;
- (void)removeTastingNotes:(NSSet *)values;

- (void)addVarietalsObject:(Varietal *)value;
- (void)removeVarietalsObject:(Varietal *)value;
- (void)addVarietals:(NSSet *)values;
- (void)removeVarietals:(NSSet *)values;

@end
