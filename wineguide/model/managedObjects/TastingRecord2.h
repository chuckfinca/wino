//
//  TastingRecord2.h
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant2;

@interface TastingRecord2 : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSDate * tasting_date;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) Restaurant2 *restaurant;
@property (nonatomic, retain) NSSet *reviews;
@end

@interface TastingRecord2 (CoreDataGeneratedAccessors)

- (void)addReviewsObject:(NSManagedObject *)value;
- (void)removeReviewsObject:(NSManagedObject *)value;
- (void)addReviews:(NSSet *)values;
- (void)removeReviews:(NSSet *)values;

@end