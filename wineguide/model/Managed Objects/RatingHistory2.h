//
//  RatingHistory2.h
//  Corkie
//
//  Created by Charles Feinn on 5/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wine2;

@interface RatingHistory2 : NSManagedObject

@property (nonatomic, retain) NSNumber * average;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * five_star_ratings;
@property (nonatomic, retain) NSNumber * four_star_ratings;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * one_star_ratings;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * three_star_ratings;
@property (nonatomic, retain) NSNumber * total_ratings;
@property (nonatomic, retain) NSNumber * two_star_ratings;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Wine2 *wine;

@end
