//
//  ReviewsLabel.m
//  Corkie
//
//  Created by Charles Feinn on 5/15/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewsLabel.h"
#import "FontThemer.h"

@implementation ReviewsLabel

-(void)setupForNumberOfReviews:(NSInteger)numberOfReviews
{
    NSAttributedString *attributedString;
    NSString *text;
    
    if(numberOfReviews > 0){
        text = [NSString stringWithFormat:@"%ld review",(long)numberOfReviews];
        if(numberOfReviews > 1){
            text = [text stringByAppendingString:@"s"];
        }
        attributedString = [[NSAttributedString alloc] initWithString:text attributes:[FontThemer sharedInstance].secondaryCaption1TextAttributes];
    } else {
        text = @"Be the first to try it!";
        attributedString = [[NSAttributedString alloc] initWithString:text attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    }
    
    self.attributedText = attributedString;
}

@end
