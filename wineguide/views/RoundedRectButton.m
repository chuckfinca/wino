//
//  RoundedRectButton.m
//  Corkie
//
//  Created by Charles Feinn on 1/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RoundedRectButton.h"
#import "ColorSchemer.h"

#define CORNER_RADIUS_SCALE_FACTOR .02

@implementation RoundedRectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width*CORNER_RADIUS_SCALE_FACTOR];
    [roundedRect addClip];
    [[ColorSchemer sharedInstance].baseColor setFill];
    [roundedRect fill];
}

@end
