//
//  RatingsReusableView.m
//  Gimme
//
//  Created by Charles Feinn on 12/18/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RatingsReusableView.h"
#import <math.h>

@implementation RatingsReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupImageViewForGlassNumber:(int)glassNumber andRating:(float)rating
{
    UIImage *glass;
    NSLog(@"glassNumber = %i",glassNumber);
    NSLog(@"rating = %f",rating);
    if(rating - glassNumber >= 1){
        glass = [UIImage imageNamed:@"glass_full.png"];
    } else if(rating - glassNumber > 0){
            glass = [UIImage imageNamed:@"glass_half.png"];
    } else {
        glass = [UIImage imageNamed:@"glass_empty.png"];
    }
    [self.glassImageView setImage:glass];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
