//
//  Wine.h
//  Corkie
//
//  Created by Charles Feinn on 5/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand, Flight, Group, Rating, Review, TastingNote, User, Varietal, WineUnit;

@interface Wine : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSNumber * alcoholPercentage;
@property (nonatomic, retain) NSString * brandIdentifier;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSNumber * dessert;
@property (nonatomic, retain) NSString * flightIdentifiers;
@property (nonatomic, retain) NSString * groupIdentifiers;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isPlaceholderForFutureObject;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSNumber * sparkling;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * tastingNoteIdentifers;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSString * varietalIdentifiers;
@property (nonatomic, retain) NSString * vineyard;
@property (nonatomic, retain) NSNumber * vintage;
@property (nonatomic, retain) NSString * wineUnitIdentifiers;
@property (nonatomic, retain) NSNumber * user_favorite;
@property (nonatomic, retain) Brand *brand;
@property (nonatomic, retain) NSSet *favoritedBy;
@property (nonatomic, retain) NSSet *flights;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) Rating *rating;
@property (nonatomic, retain) NSSet *reviews;
@property (nonatomic, retain) NSSet *tastingNotes;
@property (nonatomic, retain) NSSet *varietals;
@property (nonatomic, retain) NSSet *wineUnits;
@end

@interface Wine (CoreDataGeneratedAccessors)

- (void)addFavoritedByObject:(User *)value;
- (void)removeFavoritedByObject:(User *)value;
- (void)addFavoritedBy:(NSSet *)values;
- (void)removeFavoritedBy:(NSSet *)values;

- (void)addFlightsObject:(Flight *)value;
- (void)removeFlightsObject:(Flight *)value;
- (void)addFlights:(NSSet *)values;
- (void)removeFlights:(NSSet *)values;

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addReviewsObject:(Review *)value;
- (void)removeReviewsObject:(Review *)value;
- (void)addReviews:(NSSet *)values;
- (void)removeReviews:(NSSet *)values;

- (void)addTastingNotesObject:(TastingNote *)value;
- (void)removeTastingNotesObject:(TastingNote *)value;
- (void)addTastingNotes:(NSSet *)values;
- (void)removeTastingNotes:(NSSet *)values;

- (void)addVarietalsObject:(Varietal *)value;
- (void)removeVarietalsObject:(Varietal *)value;
- (void)addVarietals:(NSSet *)values;
- (void)removeVarietals:(NSSet *)values;

- (void)addWineUnitsObject:(WineUnit *)value;
- (void)removeWineUnitsObject:(WineUnit *)value;
- (void)addWineUnits:(NSSet *)values;
- (void)removeWineUnits:(NSSet *)values;

@end
