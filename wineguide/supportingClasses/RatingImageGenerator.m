//
//  RatingImageGenerator.m
//  Corkie
//
//  Created by Charles Feinn on 4/1/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingImageGenerator.h"

@implementation RatingImageGenerator

+(void)setupRating:(float)rating inImageViewArray:(NSArray *)imageViewArray
{
    for(UIImageView *iv in imageViewArray){
        NSInteger glassIndex = iv.tag;
        UIImage *image;
        if(glassIndex + 1 > rating){
            image = [UIImage imageNamed:@"glass_empty.png"];
        } else if(glassIndex + 1 <= rating) {
            image = [UIImage imageNamed:@"glass_full.png"];
        } else {
            image = [UIImage imageNamed:@"glass_half.png"];
        }
        [iv setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
}

@end