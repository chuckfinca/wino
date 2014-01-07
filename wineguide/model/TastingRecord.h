//
//  TastingRecord.h
//  Corkie
//
//  Created by Charles Feinn on 1/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Review, User;

@interface TastingRecord : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSDate * tastingDate;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Review *review;

@end
