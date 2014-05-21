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

+(void)setupRating:(float)rating inImageViewArray:(NSArray *)imageViewArray withWineColor:(NSNumber *)wineColor
{
    if(rating && rating > 0){
        for(UIImageView *iv in imageViewArray){
            iv.hidden = NO;
            NSInteger glassIndex = iv.tag + 1;
            UIImage *image;
            if(glassIndex > rating){
                if(rating + 0.5 >= glassIndex){
                    image = [[UIImage imageNamed:@"glass_half.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                } else {
                    image = [[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                }
            } else {
                image = [[UIImage imageNamed:@"glass_full.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            iv.tintColor = [[ColorSchemer sharedInstance] getWineColorFromCode:wineColor];
            [iv setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
    } else {
        for(UIImageView *iv in imageViewArray){
            iv.hidden = YES;
        }
    }
}

@end
