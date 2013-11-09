//
//  WineUnit.h
//  wineguide
//
//  Created by Charles Feinn on 11/8/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, Wine;

@interface WineUnit : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastAccessed;
@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * wineIdentifier;
@property (nonatomic, retain) NSString * restaurantIdentifier;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) Wine *wine;

@end
