//
//  IterationCounter.m
//  wineguide
//
//  Created by Charles Feinn on 11/12/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "IterationCounter.h"

@implementation IterationCounter

static IterationCounter *sharedIterationCounter;

+(IterationCounter *)sharedIterationCounter
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedIterationCounter = [[self alloc] init];
    });
    return sharedIterationCounter;
}

-(int)counterOne
{
    if(!_counterOne) _counterOne = 0;
    return _counterOne;
}


-(int)counterTwo
{
    if(!_counterTwo) _counterTwo = 0;
    return _counterTwo;
}

-(int)counterThree
{
    if(!_counterThree) _counterThree = 0;
    return _counterThree;
}

-(int)counterFour
{
    if(!_counterFour) _counterFour = 0;
    return _counterFour;
}

-(int)counterFive
{
    if(!_counterFive) _counterFive = 0;
    return _counterFive;
}

-(int)counterSix
{
    if(!_counterSix) _counterSix = 0;
    return _counterSix;
}


@end
