//
//  Restaurant2.h
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight2, Group2, TastingRecord2, WineUnit2;

@interface Restaurant2 : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * street_1;
@property (nonatomic, retain) NSString * street_2;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *flights;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *wineUnits;
@property (nonatomic, retain) NSSet *tastingRecords;
@end

@interface Restaurant2 (CoreDataGeneratedAccessors)

- (void)addFlightsObject:(Flight2 *)value;
- (void)removeFlightsObject:(Flight2 *)value;
- (void)addFlights:(NSSet *)values;
- (void)removeFlights:(NSSet *)values;

- (void)addGroupsObject:(Group2 *)value;
- (void)removeGroupsObject:(Group2 *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addWineUnitsObject:(WineUnit2 *)value;
- (void)removeWineUnitsObject:(WineUnit2 *)value;
- (void)addWineUnits:(NSSet *)values;
- (void)removeWineUnits:(NSSet *)values;

- (void)addTastingRecordsObject:(TastingRecord2 *)value;
- (void)removeTastingRecordsObject:(TastingRecord2 *)value;
- (void)addTastingRecords:(NSSet *)values;
- (void)removeTastingRecords:(NSSet *)values;

@end
