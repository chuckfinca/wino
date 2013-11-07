//
//  Restaurant.h
//  wineguide
//
//  Created by Charles Feinn on 11/7/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight, Grouping, WineUnit;

@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastAccessed;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSNumber * menuNeedsUpdating;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * flightIdentifiers;
@property (nonatomic, retain) NSString * groupIdentifiers;
@property (nonatomic, retain) NSString * wineUnitIdentifiers;
@property (nonatomic, retain) NSSet *flights;
@property (nonatomic, retain) NSSet *groupings;
@property (nonatomic, retain) NSSet *wineUnits;
@end

@interface Restaurant (CoreDataGeneratedAccessors)

- (void)addFlightsObject:(Flight *)value;
- (void)removeFlightsObject:(Flight *)value;
- (void)addFlights:(NSSet *)values;
- (void)removeFlights:(NSSet *)values;

- (void)addGroupingsObject:(Grouping *)value;
- (void)removeGroupingsObject:(Grouping *)value;
- (void)addGroupings:(NSSet *)values;
- (void)removeGroupings:(NSSet *)values;

- (void)addWineUnitsObject:(WineUnit *)value;
- (void)removeWineUnitsObject:(WineUnit *)value;
- (void)addWineUnits:(NSSet *)values;
- (void)removeWineUnits:(NSSet *)values;

@end
