//
//  User.h
//  Corkie
//
//  Created by Charles Feinn on 1/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Review, TastingRecord, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * profileImage;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSSet *reviews;
@property (nonatomic, retain) NSSet *tastingRecords;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) NSSet *followedBy;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addReviewsObject:(Review *)value;
- (void)removeReviewsObject:(Review *)value;
- (void)addReviews:(NSSet *)values;
- (void)removeReviews:(NSSet *)values;

- (void)addTastingRecordsObject:(TastingRecord *)value;
- (void)removeTastingRecordsObject:(TastingRecord *)value;
- (void)addTastingRecords:(NSSet *)values;
- (void)removeTastingRecords:(NSSet *)values;

- (void)addFollowingObject:(User *)value;
- (void)removeFollowingObject:(User *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addFollowedByObject:(User *)value;
- (void)removeFollowedByObject:(User *)value;
- (void)addFollowedBy:(NSSet *)values;
- (void)removeFollowedBy:(NSSet *)values;

@end
