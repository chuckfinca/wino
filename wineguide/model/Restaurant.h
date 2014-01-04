//
//  Restaurant.h
//  Corkie
//
//  Created by Charles Feinn on 1/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight, Group, WineUnit;

@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSString * flightIdentifiers;
@property (nonatomic, retain) NSString * groupIdentifiers;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isPlaceholderForFutureObject;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * menuNeedsUpdating;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * wineUnitIdentifiers;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSSet *flights;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *wineUnits;
@property (nonatomic, retain) NSSet *tastingRecords;
@property (nonatomic, retain) NSSet *reviews;
@end

@interface Restaurant (CoreDataGeneratedAccessors)

- (void)addFlightsObject:(Flight *)value;
- (void)removeFlightsObject:(Flight *)value;
- (void)addFlights:(NSSet *)values;
- (void)removeFlights:(NSSet *)values;

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addWineUnitsObject:(WineUnit *)value;
- (void)removeWineUnitsObject:(WineUnit *)value;
- (void)addWineUnits:(NSSet *)values;
- (void)removeWineUnits:(NSSet *)values;

- (void)addTastingRecordsObject:(NSManagedObject *)value;
- (void)removeTastingRecordsObject:(NSManagedObject *)value;
- (void)addTastingRecords:(NSSet *)values;
- (void)removeTastingRecords:(NSSet *)values;

- (void)addReviewsObject:(NSManagedObject *)value;
- (void)removeReviewsObject:(NSManagedObject *)value;
- (void)addReviews:(NSSet *)values;
- (void)removeReviews:(NSSet *)values;

@end
