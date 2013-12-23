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
    if(!_baseColor) _baseColor = [UIColor colorWithRed:0.596078F green:0.376471F blue:0.600000F alpha:1.0F]; // original purple
        //[UIColor colorWithRed:0.666667f green:0.470588f blue:0.650980f alpha:1.0]; // original slightly lighter purple
        //[UIColor colorWithRed:0.364706F green:0.129412F blue:0.160784F alpha:1.0F]; // dark red wine
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
    if(!_textLink) _textLink = [UIColor colorWithRed:0.603922F green:0.803922F blue:0.388235F alpha:1.0F]; // light yellow green
        //[UIColor colorWithRed:0.666667f green:0.470588f blue:0.650980f alpha:1.0]; // purple
    return _textLink;
}

-(UIColor *)customBackgroundColor
{
    if(!_customBackgroundColor) _customBackgroundColor = [UIColor colorWithRed:0.952941F green:0.952941F blue:0.952941F alpha:1.0F];
        //[UIColor colorWithRed:1.000000F green:0.956722F blue:0.915948F alpha:1.0F];
        //[UIColor colorWithRed:0.968627F green:0.894118F blue:0.823529F alpha:1.0F];
    return _customBackgroundColor;
}

-(UIColor *)menuBackgroundColor
{
    if(!_menuBackgroundColor) _menuBackgroundColor = [UIColor colorWithRed:0.133333F green:0.133333F blue:0.133333F alpha:1.0F];
    return _menuBackgroundColor;
}

-(UIColor *)shadowColor
{
    if(!_shadowColor) _shadowColor = [UIColor colorWithRed:0.133333F green:0.133333F blue:0.133333F alpha:0.5F];
    return _shadowColor;
}


@end
