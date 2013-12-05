//
//  Flight.h
//  Gimme
//
//  Created by Charles Feinn on 12/4/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, WineUnit;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isPlaceholderForFutureObject;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * restaurantIdentifier;
@property (nonatomic, retain) NSNumber * versionNumber;
@property (nonatomic, retain) NSString * wineUnitIdentifiers;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) NSSet *wineUnits;
@end

@interface Flight (CoreDataGeneratedAccessors)

- (void)addWineUnitsObject:(WineUnit *)value;
- (void)removeWineUnitsObject:(WineUnit *)value;
- (void)addWineUnits:(NSSet *)values;
- (void)removeWineUnits:(NSSet *)values;

@end
