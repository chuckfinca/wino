//
//  RatingTextCVCell.m
//  Corkie
//
//  Created by Charles Feinn on 5/1/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingTextCVCell.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@interface RatingTextCVCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation RatingTextCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupForNumberOfReviews:(NSInteger)numberOfReviews
{
    NSAttributedString *attributedString;
    NSString *text;
    if(numberOfReviews > 0){
        text = [NSString stringWithFormat:@"%ld review",(long)numberOfReviews];
        if(numberOfReviews > 1){
            text = [text stringByAppendingString:@"s"];
        }
        attributedString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption1, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    } else {
        text = @"Be the first to try it!";
        attributedString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    }
    
    self.textLabel.attributedText = attributedString;
}









@end
