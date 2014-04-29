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

+(void)setupRating:(float)rating inImageViewArray:(NSArray *)imageViewArray withWineColorString:(NSString *)wineColorString
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
        
        for(UIImageView *iv in imageViewArray){
            iv.hidden = NO;
            NSInteger glassIndex = iv.tag;
            UIImage *image;
            if(glassIndex + 1 > rating){
                image = [UIImage imageNamed:@"glass_empty.png"];
            } else if(glassIndex + 1 <= rating) {
                image = [UIImage imageNamed:@"glass_full.png"];
            } else {
                image = [UIImage imageNamed:@"glass_half.png"];
            }
            iv.tintColor = wineColor;
            [iv setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
    } else {
        for(UIImageView *iv in imageViewArray){
            iv.hidden = YES;
        }
    }
}

@end
