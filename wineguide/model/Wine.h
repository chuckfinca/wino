//
//  Wine.h
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand, Restaurant, TastingNote, Varietal;

@interface Wine : NSManagedObject

@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * vintage;
@property (nonatomic, retain) NSNumber * sparkling;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet *restaurants;
@property (nonatomic, retain) Brand *brand;
@property (nonatomic, retain) NSSet *varietals;
@property (nonatomic, retain) NSSet *tastingNotes;
@end

@interface Wine (CoreDataGeneratedAccessors)

- (void)addRestaurantsObject:(Restaurant *)value;
- (void)removeRestaurantsObject:(Restaurant *)value;
- (void)addRestaurants:(NSSet *)values;
- (void)removeRestaurants:(NSSet *)values;

- (void)addVarietalsObject:(Varietal *)value;
- (void)removeVarietalsObject:(Varietal *)value;
- (void)addVarietals:(NSSet *)values;
- (void)removeVarietals:(NSSet *)values;

- (void)addTastingNotesObject:(TastingNote *)value;
- (void)removeTastingNotesObject:(TastingNote *)value;
- (void)addTastingNotes:(NSSet *)values;
- (void)removeTastingNotes:(NSSet *)values;

@end
