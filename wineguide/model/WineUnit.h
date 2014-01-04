//
//  WineUnit.h
//  Corkie
//
//  Created by Charles Feinn on 1/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, Wine;

@interface WineUnit : NSManagedObject

@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isPlaceholderForFutureObject;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * restaurantIdentifier;
@property (nonatomic, retain) NSString * wineIdentifier;
@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) Wine *wine;

@end
