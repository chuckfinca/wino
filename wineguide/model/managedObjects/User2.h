//
//  User2.h
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User2, Wine2;

@interface User2 : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name_display;
@property (nonatomic, retain) NSString * name_first;
@property (nonatomic, retain) NSString * name_last;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * is_me;
@property (nonatomic, retain) NSNumber * facebook_id;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSNumber * registered;
@property (nonatomic, retain) NSNumber * follow_status;
@property (nonatomic, retain) NSSet *wines;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) NSSet *followedBy;
@end

@interface User2 (CoreDataGeneratedAccessors)

- (void)addWinesObject:(Wine2 *)value;
- (void)removeWinesObject:(Wine2 *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

- (void)addFollowingObject:(User2 *)value;
- (void)removeFollowingObject:(User2 *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addFollowedByObject:(User2 *)value;
- (void)removeFollowedByObject:(User2 *)value;
- (void)addFollowedBy:(NSSet *)values;
- (void)removeFollowedBy:(NSSet *)values;

@end
