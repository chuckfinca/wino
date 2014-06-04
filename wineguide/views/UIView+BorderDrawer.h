//
//  UIView+BorderDrawer.h
//  Corkie
//
//  Created by Charles Feinn on 4/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BorderDrawer)

-(void)drawBorderWidth:(float)width withColor:(UIColor *)color onTop:(BOOL)top bottom:(BOOL)bottom left:(BOOL)left andRight:(BOOL)right;

@end
