//
//  UIView+BorderDrawer.m
//  Corkie
//
//  Created by Charles Feinn on 4/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UIView+BorderDrawer.h"

@implementation UIView (BorderDrawer)

-(void)drawBorderColor:(UIColor *)color onTop:(BOOL)top bottom:(BOOL)bottom left:(BOOL)left andRight:(BOOL)right
{
    if(top) [self topBorderWithColor:color];
    if(bottom) [self bottomBorderWithColor:color];
    if(left) [self leftBorderWithColor:color];
    if(right) [self rightBorderWithColor:color];
    
    [self setNeedsDisplay];
}

-(void)topBorderWithColor:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

-(void)bottomBorderWithColor:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

-(void)leftBorderWithColor:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 0, 1, self.frame.size.height);
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

-(void)rightBorderWithColor:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(self.frame.size.width-1, 0, 1, self.frame.size.height);
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

@end
