//
//  IterationCounter.h
//  wineguide
//
//  Created by Charles Feinn on 11/12/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IterationCounter : NSObject

@property (nonatomic) int counterOne;
@property (nonatomic) int counterTwo;
@property (nonatomic) int counterThree;
@property (nonatomic) int counterFour;
@property (nonatomic) int counterFive;
@property (nonatomic) int counterSix;

+(IterationCounter *)sharedIterationCounter;

@end
