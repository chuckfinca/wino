//
//  RatingsReusableView.m
//  Gimme
//
//  Created by Charles Feinn on 12/18/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RatingsCVC.h"
#import <math.h>
#import "ColorSchemer.h"

@interface RatingsCVC ()

@property (nonatomic, strong) UIImage *full;
@property (nonatomic, strong) UIImage *half;
@property (nonatomic, strong) UIImage *empty;

@end
@implementation RatingsCVC

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIImage *)full
{
    if(!_full) _full = [UIImage imageNamed:@"glass_full.png"];
    return _full;
}

-(UIImage *)half
{
    if(!_half) _half = [UIImage imageNamed:@"glass_half.png"];
    return _half;
}

-(UIImage *)empty
{
    if(!_empty) _empty = [UIImage imageNamed:@"glass_empty.png"];
    return _empty;
}

-(void)setupImageViewForGlassNumber:(int)glassNumber andRating:(float)rating
{
    UIImage *glass;
    if(rating - glassNumber >= 1){
        glass = self.full;
    } else if(rating - glassNumber > 0){
            glass = self.half;
    } else {
        glass = self.empty;
    }
    [self.glassImageView setImage:glass];
    self.glassImageView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
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
