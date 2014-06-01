//
//  RoundedRectButton.m
//  Corkie
//
//  Created by Charles Feinn on 1/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RoundedRectButton.h"
#import "ColorSchemer.h"

#define CORNER_RADIUS 6
#define BORDER_WIDTH 2

@interface RoundedRectButton ()

@property (nonatomic, strong) UIColor *fill;
@property (nonatomic, strong) UIColor *stroke;

@end

@implementation RoundedRectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)setFillColor:(UIColor *)fill strokeColor:(UIColor *)stroke
{
    if(fill){
        self.fill = fill;
    }
    if(stroke){
        self.stroke = stroke;
    }
}

-(void)drawRect:(CGRect)rect
{
    if(self.stroke){
        self.layer.borderColor = self.stroke.CGColor;
        self.layer.borderWidth = BORDER_WIDTH;
    }
    
    if(self.fill){
        self.layer.backgroundColor = self.fill.CGColor;
    }
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CORNER_RADIUS;
}






@end
