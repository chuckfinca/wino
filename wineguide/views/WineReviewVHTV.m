//
//  WineReviewVHTV.m
//  Corkie
//
//  Created by Charles Feinn on 1/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineReviewVHTV.h"
#import "ColorSchemer.h"

@implementation WineReviewVHTV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupWithReview
{
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    
}

@end
