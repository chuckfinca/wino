//
//  Flight.h
//  Corkie
//
//  Created by Charles Feinn on 2/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, Wine;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isPlaceholderForFutureObject;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * restaurantIdentifier;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSString * wineIdentifiers;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Flight (CoreDataGeneratedAccessors)

- (void)addWinesObject:(Wine *)value;
- (void)removeWinesObject:(Wine *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
