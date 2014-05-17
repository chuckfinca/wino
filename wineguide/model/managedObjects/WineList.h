//
//  WineList.h
//  Corkie
//
//  Created by Charles Feinn on 5/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight2, Group2, Restaurant2, Wine2, WineUnit2;

@interface WineList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) Restaurant2 *restaurant;
@property (nonatomic, retain) NSSet *flights;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *wineUnits;
@property (nonatomic, retain) NSSet *wines;
@end

@interface WineList (CoreDataGeneratedAccessors)

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

- (void)addWinesObject:(Wine2 *)value;
- (void)removeWinesObject:(Wine2 *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
