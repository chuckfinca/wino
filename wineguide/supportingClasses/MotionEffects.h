//
//  MotionEffects.h
//  Corkie
//
//  Created by Charles Feinn on 1/2/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotionEffects : NSObject

@property (nonatomic, strong) UIInterpolatingMotionEffect *xAxisMotionEffect;
@property (nonatomic, strong) UIInterpolatingMotionEffect *yAxisMotionEffect;

-(UIMotionEffectGroup *)groupedMotionEffect;

@end
