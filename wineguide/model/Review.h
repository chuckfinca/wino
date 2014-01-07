//
//  Review.h
//  Corkie
//
//  Created by Charles Feinn on 1/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, TastingRecord, User, Wine;

@interface Review : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSString * reviewText;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) Wine *wine;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) TastingRecord *tastingRecord;

@end
