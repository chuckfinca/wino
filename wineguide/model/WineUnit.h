//
//  WineUnit.h
//  Gimme
//
//  Created by Charles Feinn on 12/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, Wine;

@interface WineUnit : NSManagedObject

@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSString * restaurantIdentifier;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isPlaceholderForFutureObject;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSNumber * versionNumber;
@property (nonatomic, retain) NSString * wineIdentifier;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) Wine *wine;
@property (nonatomic, retain) Restaurant *restaurant;

@end
