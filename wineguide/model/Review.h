//
//  Review.h
//  Corkie
//
//  Created by Charles Feinn on 1/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, Wine;

@interface Review : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSString * reviewText;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) Wine *wine;
@property (nonatomic, retain) NSManagedObject *user;
@property (nonatomic, retain) Restaurant *restaurant;

@end
