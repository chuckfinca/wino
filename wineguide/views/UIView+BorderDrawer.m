//
//  UIView+BorderDrawer.m
//  Corkie
//
//  Created by Charles Feinn on 4/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UIView+BorderDrawer.h"

@implementation UIView (BorderDrawer)

-(void)drawBorderWidth:(float)width withColor:(UIColor *)color onTop:(BOOL)top bottom:(BOOL)bottom left:(BOOL)left andRight:(BOOL)right
{
    if(top) [self topBorderWithWidth:width andColor:color];
    if(bottom) [self bottomBorderWithWidth:width andColor:color];
    if(left) [self leftBorderWithWidth:width andColor:color];
    if(right) [self rightBorderWithWidth:width andColor:color];
    
    [self setNeedsDisplay];
}

-(void)topBorderWithWidth:(float)width andColor:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 0, self.frame.size.width, width);
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

-(void)bottomBorderWithWidth:(float)width andColor:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, self.frame.size.height-width, self.frame.size.width, width);
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

-(void)leftBorderWithWidth:(float)width andColor:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 0, width, self.frame.size.height);
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

-(void)rightBorderWithWidth:(float)width andColor:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height);
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

@end
