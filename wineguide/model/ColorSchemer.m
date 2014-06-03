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
@property (nonatomic, readwrite) UIColor *baseColorLight;

@property (nonatomic, readwrite) UIColor *textPrimary;
@property (nonatomic, readwrite) UIColor *textSecondary;
@property (nonatomic, readwrite) UIColor *textPlaceholder;
@property (nonatomic, readwrite) UIColor *clickable;

@property (nonatomic, readwrite) UIColor *customWhite;

@property (nonatomic, readwrite) UIColor *customBackgroundColor;
@property (nonatomic, readwrite) UIColor *customDarkBackgroundColor;
@property (nonatomic, readwrite) UIColor *menuBackgroundColor;

@property (nonatomic, readwrite) UIColor *shadowColor;

@property (nonatomic, readwrite) UIColor *redWine;
@property (nonatomic, readwrite) UIColor *roseWine;
@property (nonatomic, readwrite) UIColor *whiteWine;

@property (nonatomic, readwrite) UIColor *gray;
@property (nonatomic, readwrite) UIColor *lightGray;

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

-(UIColor *)baseColorLight
{
    if(!_baseColorLight) _baseColorLight = [UIColor colorWithRed:0.968627F green:0.952941F blue:0.972549F alpha:1.0F];
    return _baseColorLight;
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

-(UIColor *)textPlaceholder
{
    if(!_textPlaceholder) _textPlaceholder = [UIColor colorWithRed:0.7F green:0.7F blue:0.7F alpha:1.0F];
        //[UIColor colorWithRed:0.800000F green:0.800000F blue:0.800000F alpha:1.0F];
    return _textPlaceholder;
}

-(UIColor *)clickable
{
    if(!_clickable) _clickable = [UIColor colorWithRed:0.207843F green:0.505882F blue:1.000000F alpha:1.0F]; // light blue
        //[UIColor colorWithRed:0.603922F green:0.803922F blue:0.388235F alpha:1.0F]; // light yellow green
        //[UIColor colorWithRed:0.666667f green:0.470588f blue:0.650980f alpha:1.0]; // purple
    return _clickable;
}

-(UIColor *)customWhite
{
    if(!_customWhite) _customWhite = [UIColor whiteColor];
    return _customWhite;
}

-(UIColor *)customBackgroundColor
{
    if(!_customBackgroundColor) _customBackgroundColor = [UIColor colorWithRed:0.985392F green:0.985392F blue:0.985392F alpha:1.0F];
        //[UIColor colorWithRed:1.000000F green:0.956722F blue:0.915948F alpha:1.0F];
        //[UIColor colorWithRed:0.968627F green:0.894118F blue:0.823529F alpha:1.0F];
    return _customBackgroundColor;
}

-(UIColor *)customDarkBackgroundColor
{
    if(!_customDarkBackgroundColor) _customDarkBackgroundColor = [UIColor colorWithRed:0.800000F green:0.800000F blue:0.800000F alpha:1.0F];
    return _customDarkBackgroundColor;
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

-(UIColor *)redWine
{
    if(!_redWine) _redWine = [UIColor colorWithRed:0.400000F green:0.133333F blue:0.133333F alpha:1.0F];
        //[UIColor colorWithRed:0.768627F green:0.419608F blue:0.545098F alpha:1.0F];
        //[UIColor colorWithRed:0.364706F green:0.129412F blue:0.160784F alpha:1.0F];
    return _redWine;
}


-(UIColor *)roseWine
{
    if(!_roseWine) _roseWine = [UIColor colorWithRed:0.733333F green:0.533333F blue:0.466667F alpha:1.0F];
    return _roseWine;
}


-(UIColor *)whiteWine
{
    if(!_whiteWine) _whiteWine = [UIColor colorWithRed:0.866667F green:0.733333F blue:0.466667F alpha:1.0F];
    //[UIColor colorWithRed:0.937255F green:0.913725F blue:0.749020F alpha:1.0F];
    
    return _whiteWine;
    
    /*
    NSArray *array = @[
                       // lightest
                       [UIColor colorWithRed:0.968627F green:0.913725F blue:0.831373F alpha:1.0F],
                       [UIColor colorWithRed:0.968627F green:0.898039F blue:0.784314F alpha:1.0F],
                       [UIColor colorWithRed:0.960784F green:0.882353F blue:0.745098F alpha:1.0F],
                       [UIColor colorWithRed:0.960784F green:0.870588F blue:0.694118F alpha:1.0F],
                       [UIColor colorWithRed:0.956863F green:0.850980F blue:0.650980F alpha:1.0F],
                       [UIColor colorWithRed:0.952941F green:0.839216F blue:0.611765F alpha:1.0F],
                       [UIColor colorWithRed:0.949020F green:0.815686F blue:0.552941F alpha:1.0F],
                       [UIColor colorWithRed:0.945098F green:0.800000F blue:0.501961F alpha:1.0F],
                       [UIColor colorWithRed:0.945098F green:0.780392F blue:0.458824F alpha:1.0F],
                       [UIColor colorWithRed:0.941176F green:0.768627F blue:0.423529F alpha:1.0F],
                       [UIColor colorWithRed:0.937255F green:0.749020F blue:0.411765F alpha:1.0F],
                       [UIColor colorWithRed:0.933333F green:0.733333F blue:0.349020F alpha:1.0F],
                       [UIColor colorWithRed:0.933333F green:0.721569F blue:0.313725F alpha:1.0F],
                       [UIColor colorWithRed:0.929412F green:0.709804F blue:0.274510F alpha:1.0F],
                       [UIColor colorWithRed:0.929412F green:0.690196F blue:0.247059F alpha:1.0F],
                       [UIColor colorWithRed:0.925490F green:0.682353F blue:0.215686F alpha:1.0F],
                       [UIColor colorWithRed:0.925490F green:0.666667F blue:0.192157F alpha:1.0F],
                       [UIColor colorWithRed:0.925490F green:0.654902F blue:0.164706F alpha:1.0F],
                       [UIColor colorWithRed:0.921569F green:0.643137F blue:0.145098F alpha:1.0F],
                       [UIColor colorWithRed:0.921569F green:0.635294F blue:0.129412F alpha:1.0F],
                       [UIColor colorWithRed:0.917647F green:0.623529F blue:0.105882F alpha:1.0F],
                       [UIColor colorWithRed:0.917647F green:0.611765F blue:0.090196F alpha:1.0F],
                       [UIColor colorWithRed:0.913725F green:0.603922F blue:0.078431F alpha:1.0F],
                       [UIColor colorWithRed:0.913725F green:0.596078F blue:0.058824F alpha:1.0F],
                       [UIColor colorWithRed:0.909804F green:0.580392F blue:0.050980F alpha:1.0F],
                       [UIColor colorWithRed:0.909804F green:0.572549F blue:0.035294F alpha:1.0F]
                       // darkest
                       ];
    int num = arc4random_uniform(26);
    return array[num];
     
     */
}

-(UIColor *)gray
{
    if(!_gray) _gray = [UIColor colorWithRed:0.866667F green:0.866667F blue:0.866667F alpha:1.0F];
    return _gray;
}

-(UIColor *)lightGray
{
    if(!_lightGray) _lightGray = [UIColor colorWithRed:0.933333F green:0.933333F blue:0.933333F alpha:1.0F]; // #EEEEEE
    return _lightGray;
}

-(UIColor *)getWineColorFromCode:(NSNumber *)color_code
{
    UIColor *color;
    
    switch ([color_code integerValue]) {
        case 1:
            color = [ColorSchemer sharedInstance].redWine;
            break;
        case 2:
            color = [ColorSchemer sharedInstance].roseWine;
            break;
        case 3:
            color = [ColorSchemer sharedInstance].whiteWine;
            break;
            
        default:
            break;
    }
    return color;
}

-(void)mixItUp
{
    self.baseColor = [UIColor orangeColor];
    self.textPrimary = [UIColor redColor];
    self.textSecondary = [UIColor greenColor];
    self.clickable = [UIColor brownColor];
    self.customWhite = [UIColor purpleColor];
    self.customBackgroundColor = [UIColor blueColor];
    self.menuBackgroundColor = [UIColor lightGrayColor];
    self.shadowColor = [UIColor yellowColor];
}

@end
