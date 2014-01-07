//
//  Rating.h
//  Corkie
//
//  Created by Charles Feinn on 1/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wine;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSNumber * num1StarRatings;
@property (nonatomic, retain) NSNumber * num2StarRatings;
@property (nonatomic, retain) NSNumber * num3StarRatings;
@property (nonatomic, retain) NSNumber * num4StarRatings;
@property (nonatomic, retain) NSNumber * num5StarRatings;
@property (nonatomic, retain) NSDate * lastLocalUpdate;
@property (nonatomic, retain) NSDate * lastServerUpdate;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) Wine *wine;

@end
