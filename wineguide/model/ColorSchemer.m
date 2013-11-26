//
//  ColorSchemer.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ColorSchemer.h"
@interface ColorSchemer ()


@property (nonatomic, strong) NSDictionary *baseColorDictionary;

@property (nonatomic, readwrite) UIColor *baseColor;

@property (nonatomic, readwrite) UIColor *textPrimary;
@property (nonatomic, readwrite) UIColor *textSecondary;
@property (nonatomic, readwrite) UIColor *textLink;

@property (nonatomic, readwrite) UIColor *customBackgroundColor;
@property (nonatomic, readwrite) UIColor *menuBackgroundColor;

@property (nonatomic, readwrite) UIColor *shadowColor;

@end

@implementation ColorSchemer

static ColorSchemer *sharedInstance;

+(ColorSchemer *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(UIColor *)baseColor
{
    if(!_baseColor) _baseColor = [UIColor colorWithRed:0.666667f green:0.470588f blue:0.650980f alpha:1.0];
    return _baseColor;
}

-(UIColor *)textPrimary
{
    if(!_textPrimary) _textPrimary = [UIColor colorWithRed:0.133333F green:0.133333F blue:0.133333F alpha:1.0F];
    return _textPrimary;
}
-(UIColor *)textSecondary
{
    if(!_textSecondary) _textSecondary = [UIColor colorWithRed:0.533333F green:0.533333F blue:0.533333F alpha:1.0F];
    return _textSecondary;
}
-(UIColor *)textLink
{
    if(!_textLink) _textLink = [UIColor colorWithRed:0.666667f green:0.470588f blue:0.650980f alpha:1.0];
    return _textLink;
}

-(UIColor *)customBackgroundColor
{
    if(!_customBackgroundColor) _customBackgroundColor = [UIColor whiteColor];
    return _customBackgroundColor;
}

-(UIColor *)menuBackgroundColor
{
    if(!_menuBackgroundColor) _menuBackgroundColor = [UIColor darkGrayColor];
    return _menuBackgroundColor;
}

-(UIColor *)shadowColor
{
    if(!_shadowColor) _shadowColor = [UIColor colorWithRed:0.133333F green:0.133333F blue:0.133333F alpha:0.5F];
    return _shadowColor;
}


@end
