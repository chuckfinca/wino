//
//  RatingImageGenerator.m
//  Corkie
//
//  Created by Charles Feinn on 4/1/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingPreparer.h"
#import "ColorSchemer.h"

@implementation RatingPreparer

+(void)setupRating:(float)rating inButtonArray:(NSArray *)buttonArray withWineColorString:(NSString *)wineColorString
{
    if(rating && rating > 0){
        UIColor *wineColor;
        if([wineColorString isEqualToString:@"red"]){
            wineColor = [ColorSchemer sharedInstance].redWine;
        } else if([wineColorString isEqualToString:@"rose"]){
            wineColor = [ColorSchemer sharedInstance].roseWine;
        } else if([wineColorString isEqualToString:@"white"]){
            wineColor = [ColorSchemer sharedInstance].whiteWine;
        } else {
            NSLog(@"wine.color != red/rose/white");
        }
        
        for(UIButton *button in buttonArray){
            button.hidden = NO;
            NSInteger glassIndex = button.tag;
            UIImage *image;
            if(glassIndex + 1 > rating){
                image = [[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            } else if(glassIndex + 1 <= rating) {
                image = [[UIImage imageNamed:@"glass_full.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            } else {
                image = [[UIImage imageNamed:@"glass_half.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            button.tintColor = wineColor;
            [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }
    } else {
        for(UIImageView *iv in buttonArray){
            iv.hidden = YES;
        }
    }
}

@end
