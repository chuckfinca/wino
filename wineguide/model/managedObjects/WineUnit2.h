//
//  WineUnit2.h
//  Corkie
//
//  Created by Charles Feinn on 5/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant2, Wine2;

@interface WineUnit2 : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Restaurant2 *restaurant;
@property (nonatomic, retain) Wine2 *wine;

@end
