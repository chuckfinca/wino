//
//  WineColorStringFromCode.m
//  Corkie
//
//  Created by Charles Feinn on 5/22/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineColorStringFromCode.h"

@implementation WineColorStringFromCode

+(NSString *)wineColorStringFromColorCode:(NSInteger)colorCode
{
    switch (colorCode) {
        case 1:
            return @"Red";
            break;
            
        case 2:
            return @"White";
            break;
        case 3:
            return @"Rosé";
            break;
            
        default:
            break;
    }
    return @"";
}

@end
