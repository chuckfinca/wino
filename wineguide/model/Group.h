//
//  Group.h
//  wineguide
//
//  Created by Charles Feinn on 11/12/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, WineUnit;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastAccessed;
@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * restaurantIdentifier;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * wineUnitIdentifiers;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) NSSet *wineUnits;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addWineUnitsObject:(WineUnit *)value;
- (void)removeWineUnitsObject:(WineUnit *)value;
- (void)addWineUnits:(NSSet *)values;
- (void)removeWineUnits:(NSSet *)values;

@end
