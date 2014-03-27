//
//  User.h
//  Corkie
//
//  Created by Charles Feinn on 3/26/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Review, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * homeLatitude;
@property (nonatomic, retain) NSNumber * homeLongitude;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * nameFirst;
@property (nonatomic, retain) NSString * nameLast;
@property (nonatomic, retain) NSString * nameLastInitial;
@property (nonatomic, retain) NSData * profileImage;
@property (nonatomic, retain) NSNumber * registered;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSNumber * isMe;
@property (nonatomic, retain) NSString * nameFull;
@property (nonatomic, retain) NSSet *followedBy;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) NSSet *reviews;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFollowedByObject:(User *)value;
- (void)removeFollowedByObject:(User *)value;
- (void)addFollowedBy:(NSSet *)values;
- (void)removeFollowedBy:(NSSet *)values;

- (void)addFollowingObject:(User *)value;
- (void)removeFollowingObject:(User *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addReviewsObject:(Review *)value;
- (void)removeReviewsObject:(Review *)value;
- (void)addReviews:(NSSet *)values;
- (void)removeReviews:(NSSet *)values;

@end
