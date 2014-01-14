//
//  MotionEffects.m
//  Corkie
//
//  Created by Charles Feinn on 1/2/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "MotionEffects.h"

#define MAX_MOVEMENT 40

@interface MotionEffects ()

@property (nonatomic, strong) UIInterpolatingMotionEffect *xAxisMotionEffect;
@property (nonatomic, strong) UIInterpolatingMotionEffect *yAxisMotionEffect;

@end

@implementation MotionEffects

+(void)addMotionEffectsToView:(UIView *)view
{
    MotionEffects *motionEffects = [[MotionEffects alloc] init];
    [view addMotionEffect:[motionEffects groupedMotionEffect]];
}

-(UIInterpolatingMotionEffect *)xAxisMotionEffect
{
    if(!_xAxisMotionEffect) {
        _xAxisMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        _xAxisMotionEffect.minimumRelativeValue = @MAX_MOVEMENT;
        _xAxisMotionEffect.maximumRelativeValue = @-MAX_MOVEMENT;
    }
    return _xAxisMotionEffect;
}

-(UIInterpolatingMotionEffect *)yAxisMotionEffect
{
    if(!_yAxisMotionEffect) {
        _yAxisMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        _yAxisMotionEffect.minimumRelativeValue = @MAX_MOVEMENT;
        _yAxisMotionEffect.maximumRelativeValue = @-MAX_MOVEMENT;
    }
    return _xAxisMotionEffect;
}

-(UIMotionEffectGroup *)groupedMotionEffect
{
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[self.xAxisMotionEffect, self.yAxisMotionEffect];
    return group;
}

@end
