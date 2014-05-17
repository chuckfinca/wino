//
//  Rating.h
//  Corkie
//
//  Created by Charles Feinn on 5/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wine;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSNumber * averageRating;
@property (nonatomic, retain) NSNumber * num1StarRatings;
@property (nonatomic, retain) NSNumber * num2StarRatings;
@property (nonatomic, retain) NSNumber * num3StarRatings;
@property (nonatomic, retain) NSNumber * num4StarRatings;
@property (nonatomic, retain) NSNumber * num5StarRatings;
@property (nonatomic, retain) NSNumber * totalRatings;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) Wine *wine;

@end
