//
//  Review.h
//  Corkie
//
//  Created by Charles Feinn on 2/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, TastingRecord, User, Wine;

@interface Review : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * reviewText;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) TastingRecord *tastingRecord;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Wine *wine;

@end
