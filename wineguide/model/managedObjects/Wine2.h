//
//  Wine2.h
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand2, Flight2, Group2, RatingHistory2, WineUnit2;

@interface Wine2 : NSManagedObject

@property (nonatomic, retain) NSNumber * alcohol;
@property (nonatomic, retain) NSString * category_code;
@property (nonatomic, retain) NSNumber * color_code;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * dessert;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sparkling;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * vineyard;
@property (nonatomic, retain) NSString * vintage;
@property (nonatomic, retain) NSString * wine_description;
@property (nonatomic, retain) Brand2 *brand;
@property (nonatomic, retain) NSSet *flights;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) RatingHistory2 *ratingHistory;
@property (nonatomic, retain) NSSet *wineUnits;
@end

@interface Wine2 (CoreDataGeneratedAccessors)

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

@end
