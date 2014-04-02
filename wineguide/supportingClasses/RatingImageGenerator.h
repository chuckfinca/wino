//
//  RatingImageGenerator.h
//  Corkie
//
//  Created by Charles Feinn on 4/1/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatingImageGenerator : NSObject

+(void)setupRating:(float)rating inImageViewArray:(NSArray *)imageViewArray;

@end